#!/usr/bin/env bash
# pdftools installer
# For each pinned tool in VERSIONS: clone if missing, check out the pin, symlink to /usr/local/bin.

set -euo pipefail

INSTALL_DIR="/usr/local/bin"
SUITE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPOS_DIR="$(cd "$SUITE_DIR/.." && pwd)"
VERSIONS_FILE="$SUITE_DIR/VERSIONS"
GITHUB_USER="marekkowalczyk"

# Suite membership (may be wider than the current pin set).
TOOLS=(pdfclean pdflogo pdfstamp pdfrem pdfbates pdfsecret mdtopdf pdfocr pdfa4)

success() { echo "✓ $*"; }
skip()    { echo "– $*"; }
warn()    { echo "Warning: $*" >&2; }

pin_for() {
    local tool="$1"
    local line
    [ -f "$VERSIONS_FILE" ] || return 0
    line="$(grep -E "^${tool}=" "$VERSIONS_FILE" | tail -n 1 || true)"
    if [ -n "$line" ]; then
        echo "${line#*=}"
    fi
}

echo "=== pdftools installer ==="
echo

if [ ! -f "$VERSIONS_FILE" ]; then
    echo "pdftools: VERSIONS pin file not found at $VERSIONS_FILE" >&2
    exit 1
fi

pinned=0
for tool in "${TOOLS[@]}"; do
    pin="$(pin_for "$tool")"
    if [ -z "$pin" ]; then
        skip "$tool  (not pinned yet — see VERSIONS)"
        continue
    fi

    target="$REPOS_DIR/$tool"

    if [ ! -d "$target/.git" ] && [ ! -d "$target" ]; then
        echo "  Cloning $GITHUB_USER/$tool @ $pin..."
        git clone --branch "$pin" --depth 1 \
            "https://github.com/$GITHUB_USER/$tool.git" "$target" \
            || git clone "https://github.com/$GITHUB_USER/$tool.git" "$target"
    fi

    if [ ! -d "$target/.git" ]; then
        warn "$tool: $target is not a git repo — skipping"
        continue
    fi

    echo "  Checking out $tool @ $pin..."
    if ! git -C "$target" fetch --tags --quiet origin 2>/dev/null; then
        git -C "$target" fetch --tags --quiet || true
    fi
    if ! git -C "$target" checkout --quiet "$pin"; then
        warn "$tool: could not check out '$pin' (local changes?) — skipping"
        continue
    fi

    script="$target/$tool"
    if [ ! -f "$script" ]; then
        warn "$script not found — skipping"
        continue
    fi

    chmod +x "$script"

    link="$INSTALL_DIR/$tool"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$script" ]; then
        success "$tool @ $pin → $link (already linked)"
    else
        if ln -sf "$script" "$link" 2>/dev/null; then
            success "$tool @ $pin → $link"
        else
            warn "could not write $link (try sudo); binary is at $script"
        fi
    fi
    pinned=$((pinned + 1))
done

echo
if [ "$pinned" -eq 0 ]; then
    echo "Done. No pinned tools were installed."
else
    echo "Done. Installed $pinned pinned tool(s) to $INSTALL_DIR."
fi

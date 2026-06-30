#!/usr/bin/env bash
# pdftools installer
# Clones each tool's repo (if missing) and symlinks its script to /usr/local/bin.

set -euo pipefail

INSTALL_DIR="/usr/local/bin"
REPOS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GITHUB_USER="marekkowalczyk"

TOOLS=(pdfclean pdflogo pdfstamp pdfbates pdfsecret mdtopdf pdfocr)

success() { echo "✓ $*"; }
skip()    { echo "– $*  (already up to date)"; }

echo "=== pdftools installer ==="
echo

for tool in "${TOOLS[@]}"; do
    target="$REPOS_DIR/$tool"

    if [ ! -d "$target" ]; then
        echo "  Cloning $GITHUB_USER/$tool..."
        git clone "https://github.com/$GITHUB_USER/$tool.git" "$target"
    fi

    script="$target/$tool"

    if [ ! -f "$script" ]; then
        echo "Warning: $script not found — skipping" >&2
        continue
    fi

    chmod +x "$script"

    link="$INSTALL_DIR/$tool"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$script" ]; then
        skip "$tool"
    else
        ln -sf "$script" "$link"
        success "$tool → $link"
    fi
done

echo
echo "Done. All pdftools installed to $INSTALL_DIR."

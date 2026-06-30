#!/usr/bin/env bash
# pdftools installer
# Clones repos for tools that have their own repos; symlinks everything to /usr/local/bin.

set -euo pipefail

INSTALL_DIR="/usr/local/bin"
REPOS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SUITE_DIR="$(cd "$(dirname "$0")" && pwd)"
GITHUB_USER="marekkowalczyk"

# Tools with their own repos: name -> repo
declare -A REPO_TOOLS=(
    [pdfclean]="pdfclean"
    [mdtopdf]="mdtopdf"
    [pdfocr]="pdfocr"
)

# Tools bundled directly in this repo (tools/)
BUNDLED_TOOLS=(pdflogo pdfstamp pdfbates pdfsecret)

info()    { echo "  $*"; }
success() { echo "✓ $*"; }
skip()    { echo "– $*  (already up to date)"; }

echo "=== pdftools installer ==="
echo

# 1. Repo-based tools: clone if missing, then symlink the script
for tool in "${!REPO_TOOLS[@]}"; do
    repo="${REPO_TOOLS[$tool]}"
    target="$REPOS_DIR/$repo"

    if [ ! -d "$target" ]; then
        info "Cloning $GITHUB_USER/$repo..."
        git clone "https://github.com/$GITHUB_USER/$repo.git" "$target"
    fi

    link="$INSTALL_DIR/$tool"
    script="$target/$tool"

    if [ ! -f "$script" ]; then
        echo "Warning: $script not found — skipping symlink" >&2
        continue
    fi

    chmod +x "$script"

    if [ -L "$link" ] && [ "$(readlink "$link")" = "$script" ]; then
        skip "$tool"
    else
        ln -sf "$script" "$link"
        success "$tool → $link"
    fi
done

# 2. Bundled tools: symlink from tools/ in this repo
for tool in "${BUNDLED_TOOLS[@]}"; do
    script="$SUITE_DIR/tools/$tool"
    link="$INSTALL_DIR/$tool"

    chmod +x "$script"

    if [ -L "$link" ] && [ "$(readlink "$link")" = "$script" ]; then
        skip "$tool"
    else
        ln -sf "$script" "$link"
        success "$tool → $link"
    fi
done

echo
echo "Done. All pdftools installed to $INSTALL_DIR."

#!/bin/bash
#
# install.sh - Install bp-latex classes and packages to TEXMFHOME
#
# This script creates symlinks from the repository to ~/texmf so that
# LaTeX can find the classes and packages. Using symlinks means changes
# to the source files are immediately available without reinstalling.
#
# Usage: ./install.sh
#
# Copyright (c) 2025 Benjamin Peeters
# Licensed under MIT

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory (source of files)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get TEXMFHOME (destination for symlinks)
TEXMF="${TEXMFHOME:-$HOME/texmf}"

echo -e "${GREEN}Installing bp-latex to $TEXMF${NC}"
echo ""

# Create target directories
echo "Creating directories..."
mkdir -p "$TEXMF/tex/latex/bp"
mkdir -p "$TEXMF/bibtex/bst/bp"

# Remove old symlinks if they exist
echo "Cleaning old installation..."
rm -f "$TEXMF/tex/latex/bp/"*.cls 2>/dev/null || true
rm -f "$TEXMF/tex/latex/bp/"*.sty 2>/dev/null || true
rm -f "$TEXMF/tex/latex/bp/"*.tex 2>/dev/null || true
rm -f "$TEXMF/bibtex/bst/bp/"*.bst 2>/dev/null || true

# Create symlinks for classes
echo "Linking document classes..."
for file in "$SCRIPT_DIR/classes/"*.cls; do
    if [ -f "$file" ]; then
        ln -sf "$file" "$TEXMF/tex/latex/bp/"
        echo "  - $(basename "$file")"
    fi
done

# Create symlinks for internal packages
echo "Linking internal packages..."
for file in "$SCRIPT_DIR/internal/"*.sty; do
    if [ -f "$file" ]; then
        ln -sf "$file" "$TEXMF/tex/latex/bp/"
        echo "  - $(basename "$file")"
    fi
done

# Create symlinks for data files
echo "Linking data files..."
for file in "$SCRIPT_DIR/data/"*.tex; do
    if [ -f "$file" ]; then
        ln -sf "$file" "$TEXMF/tex/latex/bp/"
        echo "  - $(basename "$file")"
    fi
done

# Create symlinks for bibliography styles
echo "Linking bibliography styles..."
for file in "$SCRIPT_DIR/bst/"*.bst; do
    if [ -f "$file" ]; then
        ln -sf "$file" "$TEXMF/bibtex/bst/bp/"
        echo "  - $(basename "$file")"
    fi
done

# Update TeX database
echo ""
echo "Updating TeX database..."
if command -v texhash &> /dev/null; then
    texhash "$TEXMF" 2>/dev/null || true
elif command -v mktexlsr &> /dev/null; then
    mktexlsr "$TEXMF" 2>/dev/null || true
fi

# Set up BPBIB environment variable
echo ""
echo "Setting up environment variables..."
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "BPBIB" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# bp-latex bibliography path" >> "$SHELL_RC"
        echo 'export BPBIB="$HOME/MEGA/config/latex/bibliography"' >> "$SHELL_RC"
        echo -e "  Added BPBIB to $SHELL_RC"
    else
        echo -e "  BPBIB already defined in $SHELL_RC"
    fi
fi

# Done
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage in LaTeX documents:"
echo "  \\documentclass[12pt, colorlinks]{bp-article}   % For papers"
echo "  \\documentclass[aspectratio=169]{bp-beamer}     % For slides"
echo "  \\documentclass[12pt, boxes]{bp-book}           % For books"
echo "  \\documentclass[11pt]{bp-note}                  % For notes"
echo ""
echo "Verify installation:"
echo "  kpsewhich bp-article.cls"
echo ""
if [ -n "$SHELL_RC" ]; then
    echo -e "${YELLOW}NOTE: Run 'source $SHELL_RC' or restart your shell to use \$BPBIB${NC}"
fi

#!/bin/bash
#
# uninstall.sh - Remove bp-latex classes and packages from TEXMFHOME
#
# Usage: ./uninstall.sh
#
# Copyright (C) 2025 Benjamin Peeters
# Licensed under AGPL-3.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get TEXMFHOME
TEXMF="${TEXMFHOME:-$HOME/texmf}"

echo -e "${RED}Uninstalling bp-latex from $TEXMF${NC}"
echo ""

# Remove symlinks
echo "Removing files..."

if [ -d "$TEXMF/tex/latex/bp" ]; then
    rm -rf "$TEXMF/tex/latex/bp"
    echo "  - Removed $TEXMF/tex/latex/bp/"
fi

if [ -d "$TEXMF/bibtex/bst/bp" ]; then
    rm -rf "$TEXMF/bibtex/bst/bp"
    echo "  - Removed $TEXMF/bibtex/bst/bp/"
fi

# Update TeX database
echo ""
echo "Updating TeX database..."
if command -v texhash &> /dev/null; then
    texhash "$TEXMF" 2>/dev/null || true
elif command -v mktexlsr &> /dev/null; then
    mktexlsr "$TEXMF" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}Uninstallation complete!${NC}"
echo ""
echo "NOTE: The BPBIB environment variable in your shell config was not removed."
echo "      You can remove it manually if desired."

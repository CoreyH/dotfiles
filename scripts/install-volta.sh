#!/bin/bash

# Volta Installation Script
# Volta is a JavaScript tool manager that makes it easy to install and manage Node.js versions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Volta Installation Script${NC}"
echo -e "${YELLOW}Installing Volta - The Hassle-Free JavaScript Tool Manager${NC}"
echo

# Check if Volta is already installed
if command -v volta &> /dev/null; then
    echo -e "${GREEN}✓${NC} Volta is already installed"
    volta --version
    exit 0
fi

# Install Volta
echo -e "${GREEN}Installing Volta...${NC}"
curl https://get.volta.sh | bash

# Source the new path
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    # Add to zprofile for macOS zsh login shells
    if ! grep -q "VOLTA_HOME" "$HOME/.zprofile" 2>/dev/null; then
        {
          echo ''
          echo '# Volta'
          echo 'export VOLTA_HOME="$HOME/.volta"'
          echo 'export PATH="$VOLTA_HOME/bin:$PATH"'
        } >> "$HOME/.zprofile"
    fi
else
    # Add to bashrc on Linux
    if ! grep -q "VOLTA_HOME" "$HOME/.bashrc" 2>/dev/null; then
        {
          echo ''
          echo '# Volta'
          echo 'export VOLTA_HOME="$HOME/.volta"'
          echo 'export PATH="$VOLTA_HOME/bin:$PATH"'
        } >> "$HOME/.bashrc"
    fi
fi

# Verify installation
if [ -f "$VOLTA_HOME/bin/volta" ]; then
    echo -e "${GREEN}✓${NC} Volta installed successfully!"
    "$VOLTA_HOME/bin/volta" --version
    echo
    echo -e "${GREEN}Next steps:${NC}"
    if [[ "$OS" == "Darwin" ]]; then
      echo "  1. Restart your terminal or run: exec zsh -l"
    else
      echo "  1. Restart your terminal or run: source ~/.bashrc"
    fi
    echo "  2. Install Node.js: volta install node"
    echo "  3. Install Claude Code: volta install @anthropic-ai/claude-code"
    echo
    echo -e "${YELLOW}Why Volta?${NC}"
    echo "  - Manages Node.js versions per project"
    echo "  - Fast, reliable, and works across platforms"
    echo "  - No sudo required for global packages"
else
    echo -e "${RED}✗${NC} Installation failed. Please check the errors above."
    exit 1
fi

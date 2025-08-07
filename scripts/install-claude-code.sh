#!/bin/bash

# Claude Code Installation Script for Fedora
# Installs Anthropic's official Claude Code CLI

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Claude Code Installation Script${NC}"
echo -e "${YELLOW}Installing Anthropic's official CLI for Claude${NC}"
echo

# Check if Claude Code is already installed
if command -v claude &> /dev/null; then
    current_version=$(claude --version | head -1)
    echo -e "${GREEN}✓${NC} Claude Code is already installed"
    echo "  Version: $current_version"
    read -p "  Would you like to update to the latest version? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check for Node.js package manager preference
if command -v volta &> /dev/null; then
    echo -e "${GREEN}Using Volta for installation${NC}"
    INSTALLER="volta"
elif command -v npm &> /dev/null; then
    echo -e "${GREEN}Using npm for installation${NC}"
    INSTALLER="npm"
else
    echo -e "${RED}✗${NC} Neither Volta nor npm found"
    echo "Please install Node.js first:"
    echo "  - Volta (recommended): curl https://get.volta.sh | bash"
    echo "  - Or npm: sudo dnf install nodejs npm"
    exit 1
fi

# Install Claude Code
echo -e "${GREEN}Installing Claude Code...${NC}"

if [ "$INSTALLER" = "volta" ]; then
    volta install @anthropic-ai/claude-code
else
    npm install -g @anthropic-ai/claude-code
fi

# Verify installation
if command -v claude &> /dev/null; then
    version=$(claude --version | head -1)
    echo -e "${GREEN}✓${NC} Claude Code installed successfully!"
    echo "  Version: $version"
    echo "  Path: $(which claude)"
    echo
    echo -e "${GREEN}Getting started:${NC}"
    echo "  1. Start Claude Code from your project directory:"
    echo "     cd ~/dotfiles && claude"
    echo "  2. Or use it for specific tasks:"
    echo "     claude --help"
    echo
    echo -e "${YELLOW}Note:${NC} For best results with dotfiles management,"
    echo "      always start Claude Code from ~/dotfiles directory"
else
    echo -e "${RED}✗${NC} Installation failed. Please check the errors above."
    exit 1
fi

# Check for API key configuration
if [ ! -f "$HOME/.config/claude/config.json" ] && [ -z "$CLAUDE_API_KEY" ]; then
    echo
    echo -e "${YELLOW}API Key Setup:${NC}"
    echo "Claude Code will prompt for your API key on first use."
    echo "Get your key from: https://console.anthropic.com/settings/keys"
fi
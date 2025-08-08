#!/bin/bash

# WSL-specific installer for Fedora dotfiles
# Skips GUI components, focuses on CLI tools

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}  WSL Fedora Dotfiles Installer  ${NC}"
echo -e "${BLUE}==================================${NC}"
echo

# Detect WSL
if ! grep -qi microsoft /proc/version; then
    echo -e "${YELLOW}Warning: This doesn't appear to be WSL${NC}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update DNF
echo -e "${GREEN}Updating package manager...${NC}"
sudo dnf update -y

# Install packages from dnf.txt (skip GUI packages)
if [ -f packages/dnf.txt ]; then
    echo -e "${GREEN}Installing DNF packages...${NC}"
    # Filter out GUI-specific packages
    grep -v -E "gnome-|extension-|flameshot|alacritty" packages/dnf.txt | \
    grep -v "^#" | grep -v "^$" | \
    while read -r package; do
        if ! rpm -q "$package" &>/dev/null; then
            echo "  Installing: $package"
            sudo dnf install -y "$package" || echo "  Skipped: $package (not available)"
        fi
    done
fi

# Setup Git configuration
if [ -f git/.gitconfig.template ]; then
    echo -e "${GREEN}Setting up Git configuration...${NC}"
    if [ ! -f ~/.gitconfig ]; then
        cp git/.gitconfig.template ~/.gitconfig
        echo "  Created ~/.gitconfig from template"
    else
        echo "  ~/.gitconfig already exists, skipping"
    fi
fi

# Link bash configuration
echo -e "${GREEN}Setting up shell configuration...${NC}"
if [ -f shell/.bashrc ]; then
    # Backup existing .bashrc
    [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.backup
    ln -sf "$PWD/shell/.bashrc" ~/.bashrc
    echo "  Linked .bashrc"
fi

if [ -f shell/.bash_aliases ]; then
    ln -sf "$PWD/shell/.bash_aliases" ~/.bash_aliases
    echo "  Linked .bash_aliases"
fi

# Add WSL-specific configuration
echo -e "${GREEN}Adding WSL-specific configuration...${NC}"
cat >> ~/.bashrc.local << 'EOF'
# WSL-specific configuration
if grep -qi microsoft /proc/version; then
    export IS_WSL=1
    
    # Windows paths
    export USERPROFILE="/mnt/c/Users/$USER"
    export DOWNLOADS="$USERPROFILE/Downloads"
    
    # Windows program aliases
    alias explorer="explorer.exe"
    alias code="code.exe"
    alias edge="msedge.exe"
    
    # Clipboard integration
    alias pbcopy="clip.exe"
    alias pbpaste="powershell.exe Get-Clipboard"
    
    # Open in browser
    open() {
        if [ $# -eq 0 ]; then
            explorer.exe .
        else
            explorer.exe "$@"
        fi
    }
    
    # Git credential manager from Windows
    if [ -f "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe" ]; then
        git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
    fi
fi
EOF

# Source local bashrc in main bashrc if not already
if ! grep -q "bashrc.local" ~/.bashrc; then
    echo '[ -f ~/.bashrc.local ] && source ~/.bashrc.local' >> ~/.bashrc
fi

# Install development tools
echo -e "${GREEN}Installing development tools...${NC}"

# Volta (Node.js version manager)
if [ -f scripts/install-volta.sh ]; then
    echo "  Installing Volta..."
    bash scripts/install-volta.sh
fi

# Starship prompt
if command -v starship &> /dev/null; then
    echo "  Starship already installed"
else
    echo "  Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# Claude Code (if desired)
read -p "Install Claude Code CLI? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f scripts/install-claude-code.sh ]; then
        bash scripts/install-claude-code.sh
    fi
fi

# GitHub CLI setup
if command -v gh &> /dev/null; then
    echo -e "${GREEN}GitHub CLI installed. Don't forget to authenticate:${NC}"
    echo "  gh auth login"
fi

# OneDrive setup (optional)
read -p "Set up OneDrive sync? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf install -y onedrive
    echo -e "${YELLOW}Run 'onedrive' to authenticate${NC}"
fi

# Create useful symlinks
echo -e "${GREEN}Creating convenience symlinks...${NC}"
if [ -d "/mnt/c/Users/$USER" ]; then
    [ ! -e ~/windows ] && ln -s "/mnt/c/Users/$USER" ~/windows
    [ ! -e ~/downloads ] && ln -s "/mnt/c/Users/$USER/Downloads" ~/downloads
    echo "  Created ~/windows and ~/downloads symlinks"
fi

echo
echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}  WSL Setup Complete!${NC}"
echo -e "${GREEN}==================================${NC}"
echo
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.bashrc"
echo "  2. Authenticate GitHub: gh auth login"
echo "  3. Set up git user: git config --global user.name 'Your Name'"
echo "  4. Set up git email: git config --global user.email 'your@email.com'"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  5. Set up OneDrive: onedrive"
fi
echo
echo -e "${YELLOW}Tip: VS Code in WSL:${NC} Just type 'code .' in any directory!"
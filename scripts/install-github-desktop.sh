#!/bin/bash

# GitHub Desktop Installation Script for Fedora
# Installs the unofficial Linux port via Flatpak

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}GitHub Desktop Installation Script${NC}"
echo -e "${YELLOW}Installing GitHub Desktop (unofficial Linux port) via Flatpak${NC}"
echo

# Check if already installed
if flatpak list | grep -q "io.github.shiftey.Desktop"; then
    echo -e "${GREEN}✓${NC} GitHub Desktop is already installed"
    echo "  Launch with: flatpak run io.github.shiftey.Desktop"
    echo "  Or find it in your applications menu"
    exit 0
fi

# Ensure Flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Installing Flatpak..."
    sudo dnf install -y flatpak
fi

# Add Flathub if not already added
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install GitHub Desktop
echo -e "${GREEN}Installing GitHub Desktop...${NC}"
flatpak install -y flathub io.github.shiftey.Desktop

# Create desktop shortcut with simpler name
echo -e "${GREEN}Creating desktop shortcut...${NC}"
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/github-desktop.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Name=GitHub Desktop
Comment=Simple collaboration from your desktop
Exec=flatpak run io.github.shiftey.Desktop
Icon=io.github.shiftey.Desktop
Terminal=false
Type=Application
Categories=Development;
StartupWMClass=GitHubDesktop
EOF

update-desktop-database ~/.local/share/applications 2>/dev/null || true

# Verify installation
if flatpak list | grep -q "io.github.shiftey.Desktop"; then
    echo -e "${GREEN}✓${NC} GitHub Desktop installed successfully!"
    echo
    echo "To launch GitHub Desktop:"
    echo "  • From terminal: flatpak run io.github.shiftey.Desktop"
    echo "  • From Activities: Search for 'GitHub Desktop'"
    echo "  • Or use the alias: github-desktop (after reloading shell)"
    echo
    echo "First-time setup:"
    echo "  1. Sign in with your GitHub account"
    echo "  2. Configure Git (name and email)"
    echo "  3. Clone your repositories"
    echo
    echo -e "${YELLOW}Note:${NC} This is the unofficial Linux port by shiftey"
    echo "      It has most features of the official Windows/Mac version"
else
    echo -e "${RED}✗${NC} Installation failed"
    exit 1
fi

# Add alias to bash
if ! grep -q "alias github-desktop" ~/.bash_aliases 2>/dev/null; then
    echo "" >> ~/.bash_aliases
    echo "# GitHub Desktop" >> ~/.bash_aliases
    echo "alias github-desktop='flatpak run io.github.shiftey.Desktop'" >> ~/.bash_aliases
    echo -e "${GREEN}✓${NC} Added 'github-desktop' alias to ~/.bash_aliases"
fi
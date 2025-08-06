#!/bin/bash

# Microsoft Edge Installation Script for Fedora
# Ensures proper installation method for 1Password compatibility

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Microsoft Edge Installation Script${NC}"
echo -e "${YELLOW}Installing from official Microsoft repository for 1Password compatibility${NC}"
echo

# Check if Edge is already installed
if rpm -qa | grep -q microsoft-edge-stable; then
    echo -e "${GREEN}✓${NC} Microsoft Edge is already installed via RPM"
    edge_version=$(rpm -q microsoft-edge-stable)
    echo "  Version: $edge_version"
    exit 0
fi

# Check for Flatpak installation (not recommended)
if flatpak list | grep -q com.microsoft.Edge 2>/dev/null; then
    echo -e "${YELLOW}⚠${NC} Edge is installed via Flatpak"
    echo "  This installation method is not compatible with 1Password"
    read -p "  Would you like to remove Flatpak version and install RPM? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  Removing Flatpak version..."
        flatpak uninstall -y com.microsoft.Edge
    else
        echo "  Keeping Flatpak version. Note: 1Password extension may not work."
        exit 1
    fi
fi

# Add Microsoft Edge repository
echo -e "${GREEN}Adding Microsoft Edge repository...${NC}"
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Update repository cache
echo -e "${GREEN}Updating repository cache...${NC}"
sudo dnf check-update || true

# Install Microsoft Edge
echo -e "${GREEN}Installing Microsoft Edge...${NC}"
sudo dnf install -y microsoft-edge-stable

# Verify installation
if rpm -qa | grep -q microsoft-edge-stable; then
    echo -e "${GREEN}✓${NC} Microsoft Edge installed successfully!"
    edge_version=$(rpm -q microsoft-edge-stable)
    echo "  Version: $edge_version"
    echo
    echo -e "${GREEN}Next steps:${NC}"
    echo "  1. Launch Edge: microsoft-edge"
    echo "  2. Sign in to your Microsoft account for each profile"
    echo "  3. Install 1Password extension from Chrome Web Store"
    echo "  4. See ~/dotfiles/docs/edge-setup.md for profile configuration"
else
    echo -e "${RED}✗${NC} Installation failed. Please check the errors above."
    exit 1
fi
#!/bin/bash

echo "Setting up Workspace Indicator..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if already installed via GNOME extensions
if gnome-extensions list | grep -q "workspace-indicator@gnome-shell-extensions.gcampax.github.com"; then
    echo -e "${GREEN}✓ Workspace Indicator already installed${NC}"
    gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com 2>/dev/null || true
    
    # Configure settings if dconf is available
    if command -v dconf &> /dev/null; then
        echo "Configuring Workspace Indicator settings..."
        # You can add custom dconf settings here if needed
        # Example: dconf write /org/gnome/shell/extensions/workspace-indicator/some-setting value
    fi
else
    echo "Workspace Indicator extension not found."
    echo ""
    echo "Please install it using Extension Manager or from:"
    echo "1. Visit: https://extensions.gnome.org/extension/21/workspace-indicator/"
    echo "2. Click 'Install' button"
    echo "3. Confirm in your browser"
    echo ""
    echo "For a more modern version with better visuals:"
    echo "Visit: https://extensions.gnome.org/extension/3968/improved-workspace-indicator/"
    echo ""
    echo "After installation, run this script again or use:"
    echo "  ~/dotfiles/scripts/setup-extensions.sh"
fi

echo ""
echo -e "${GREEN}Workspace Indicator check complete!${NC}"
echo ""
if gnome-extensions list | grep -q "workspace-indicator@gnome-shell-extensions.gcampax.github.com"; then
    echo "The workspace indicator shows in your top panel:"
    echo "  • Shows current workspace number (e.g., '1' or '2/4')"
    echo "  • Click on numbers to switch workspaces"
    echo "  • Configurable through extension settings"
    echo ""
    echo "To customize:"
    echo "  • Right-click the indicator → Settings"
    echo "  • Or use: gnome-extensions prefs workspace-indicator@gnome-shell-extensions.gcampax.github.com"
fi
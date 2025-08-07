#!/bin/bash

# Windows-style Keyboard Shortcuts for GNOME
# Sets up familiar Windows keyboard shortcuts on Fedora

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Windows Keyboard Shortcuts Setup${NC}"
echo -e "${YELLOW}Applying familiar Windows shortcuts to GNOME${NC}"
echo

# Window Management (already Windows-like by default, but ensure they're set)
echo "Setting window management shortcuts..."
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

# Window Snapping (Super+Left/Right already work by default in GNOME)
echo "Setting window snapping shortcuts..."
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"

# Task Switching
echo "Setting task switching shortcuts..."
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"

# System shortcuts
echo "Setting system shortcuts..."
# Lock screen (Windows+L)
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"

# File Manager (Windows+E)
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

# Terminal (Ctrl+Alt+T is already Linux standard, but add Windows Terminal shortcut)
# Note: Can't use Ctrl+Shift+T as it conflicts with browser tab reopening
custom_shortcuts=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [[ "$custom_shortcuts" == "@as []" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
fi

# Add terminal shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>t'

# Search (Windows key already opens overview/search by default)
# This is the same as Windows Start menu behavior

# Screenshot shortcuts (similar to Windows)
echo "Setting screenshot shortcuts..."
# Print Screen - Full screenshot
gsettings set org.gnome.shell.keybindings screenshot "['Print']"
# Windows+Shift+S equivalent - Area screenshot
gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt>Print']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>s']"

# Text editing shortcuts (these work by default in most apps)
# Ctrl+C - Copy
# Ctrl+X - Cut  
# Ctrl+V - Paste
# Ctrl+Z - Undo
# Ctrl+Y - Redo (app-dependent)
# Ctrl+A - Select All
# Ctrl+S - Save
# Ctrl+F - Find

echo -e "${GREEN}✓${NC} Windows shortcuts applied!"
echo
echo -e "${GREEN}Common Windows shortcuts now available:${NC}"
echo "  • Alt+F4         - Close window"
echo "  • Alt+Tab        - Switch windows"
echo "  • Super+D        - Show desktop"
echo "  • Super+E        - File manager"
echo "  • Super+L        - Lock screen"
echo "  • Super+Up       - Maximize window"
echo "  • Super+Down     - Minimize window"
echo "  • Super+Left     - Snap window left"
echo "  • Super+Right    - Snap window right"
echo "  • Super+Shift+S  - Screenshot selection"
echo "  • Ctrl+Alt+T     - Terminal"
echo ""
echo -e "${YELLOW}Note:${NC} Some shortcuts may require logging out and back in to take effect."
echo
echo -e "${YELLOW}Additional Windows-like features:${NC}"
echo "  • Super key opens search (like Windows Start)"
echo "  • Standard Ctrl shortcuts work in most apps (Copy/Paste/Save/etc.)"
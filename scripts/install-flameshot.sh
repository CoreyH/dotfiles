#!/bin/bash

# Flameshot Installation and Configuration Script
# Installs DHH's preferred screenshot tool from Omakub

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Flameshot Screenshot Tool Installation${NC}"
echo -e "${YELLOW}Installing the powerful screenshot tool used in DHH's Omakub${NC}"
echo

# Check if Flameshot is already installed
if command -v flameshot &> /dev/null; then
    echo -e "${GREEN}✓${NC} Flameshot is already installed"
    flameshot --version
else
    # Install Flameshot
    echo -e "${GREEN}Installing Flameshot...${NC}"
    sudo dnf install -y flameshot
    
    # Verify installation
    if command -v flameshot &> /dev/null; then
        echo -e "${GREEN}✓${NC} Flameshot installed successfully!"
        flameshot --version
    else
        echo -e "${RED}✗${NC} Installation failed"
        exit 1
    fi
fi

# Configure keyboard shortcut
echo
echo -e "${GREEN}Configuring keyboard shortcuts...${NC}"

# Get current custom keybindings
custom_shortcuts=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

# Check if we need to add a new custom binding slot
if [[ "$custom_shortcuts" == "@as []" ]]; then
    # No custom shortcuts yet, create first one
    new_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$new_path']"
elif [[ "$custom_shortcuts" == *"flameshot"* ]]; then
    echo "Flameshot shortcut already configured"
else
    # Add to existing shortcuts
    # Extract the number from the last custom binding and increment
    last_num=$(echo "$custom_shortcuts" | grep -o 'custom[0-9]*' | tail -1 | grep -o '[0-9]*')
    if [ -z "$last_num" ]; then
        next_num=0
    else
        next_num=$((last_num + 1))
    fi
    new_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_num/"
    
    # Remove the closing bracket, add new path, add closing bracket
    updated_shortcuts="${custom_shortcuts%]}, '$new_path']"
    updated_shortcuts="${updated_shortcuts#[}"  # Remove leading bracket if doubled
    updated_shortcuts="[$updated_shortcuts"     # Add back single leading bracket
    
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$updated_shortcuts"
fi

# Configure the Flameshot shortcut (only if new_path is set)
if [ -n "$new_path" ]; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$new_path name 'Flameshot'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$new_path command 'flameshot gui'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$new_path binding '<Control>Print'
    echo -e "${GREEN}✓${NC} Keyboard shortcut configured: Ctrl+Print Screen"
fi

# Create desktop entry for app launcher
echo
echo -e "${GREEN}Creating desktop entry...${NC}"
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/flameshot.desktop << 'EOF'
[Desktop Entry]
Name=Flameshot
Comment=Powerful yet simple to use screenshot software
Exec=flameshot gui
Icon=flameshot
Terminal=false
Type=Application
Categories=Graphics;Utility;
EOF

update-desktop-database ~/.local/share/applications 2>/dev/null || true

# Configure Flameshot settings
echo
echo -e "${GREEN}Configuring Flameshot settings...${NC}"
mkdir -p ~/.config/flameshot

# Create a reasonable default configuration
cat > ~/.config/flameshot/flameshot.ini << 'EOF'
[General]
checkForUpdates=false
contrastOpacity=188
contrastUiColor=#ffffff
drawColor=#ff0000
drawThickness=3
filenamePattern=%F_%H-%M-%S
savePath=/home/$USER/Pictures
savePathFixed=false
showDesktopNotification=true
showHelp=false
showSidePanelButton=true
showStartupLaunchMessage=false
startupLaunch=false
uiColor=#740096

[Shortcuts]
TYPE_ARROW=A
TYPE_CIRCLE=C
TYPE_CIRCLECOUNT=
TYPE_COMMIT_CURRENT_TOOL=Ctrl+Return
TYPE_COPY=Ctrl+C
TYPE_DELETE_CURRENT_TOOL=Del
TYPE_DRAWER=D
TYPE_EXIT=Esc
TYPE_IMAGEUPLOADER=Return
TYPE_MARKER=M
TYPE_MOVESELECTION=Ctrl+M
TYPE_MOVE_DOWN=Down
TYPE_MOVE_LEFT=Left
TYPE_MOVE_RIGHT=Right
TYPE_MOVE_UP=Up
TYPE_OPEN_APP=Ctrl+O
TYPE_PENCIL=P
TYPE_PIN=
TYPE_PIXELATE=B
TYPE_RECTANGLE=R
TYPE_REDO=Ctrl+Shift+Z
TYPE_RESIZE_DOWN=Shift+Down
TYPE_RESIZE_LEFT=Shift+Left
TYPE_RESIZE_RIGHT=Shift+Right
TYPE_RESIZE_UP=Shift+Up
TYPE_SAVE=Ctrl+S
TYPE_SELECTION=S
TYPE_SELECTIONINDICATOR=
TYPE_SELECT_ALL=Ctrl+A
TYPE_TEXT=T
TYPE_TOGGLE_PANEL=Space
TYPE_UNDO=Ctrl+Z
EOF

# Update the savePath in the config to use actual username
sed -i "s/\$USER/$USER/g" ~/.config/flameshot/flameshot.ini

echo -e "${GREEN}✓${NC} Configuration complete!"
echo
echo -e "${GREEN}Flameshot is ready to use!${NC}"
echo
echo "Usage:"
echo "  • ${YELLOW}Ctrl+Print Screen${NC} - Launch Flameshot GUI"
echo "  • ${YELLOW}flameshot gui${NC} - Launch from terminal"
echo "  • ${YELLOW}flameshot full -c${NC} - Capture full screen to clipboard"
echo "  • ${YELLOW}flameshot screen -c${NC} - Capture current screen to clipboard"
echo
echo "Features:"
echo "  • Draw arrows, rectangles, circles, and text"
echo "  • Blur/pixelate sensitive information"
echo "  • Copy to clipboard or save to file"
echo "  • Upload directly to image hosting services"
echo "  • Pin screenshots to screen"
echo
echo -e "${YELLOW}Note:${NC} You can also use Super+Shift+S for GNOME's built-in screenshot tool"
#!/bin/bash

echo "Setting up Windows-style clipboard manager for Fedora..."

# Install gnome-extensions-app if not already installed
if ! command -v gnome-extensions-app &> /dev/null; then
    echo "Installing GNOME Extensions app..."
    sudo dnf install -y gnome-extensions-app
fi

# Download and install Clipboard Indicator extension
echo "Installing Clipboard Indicator extension..."
EXTENSION_UUID="clipboard-indicator@tudmotu.com"
EXTENSION_ID="779"

# Check if already installed
if gnome-extensions list | grep -q "$EXTENSION_UUID"; then
    echo "Clipboard Indicator already installed"
else
    echo "Please install Clipboard Indicator manually:"
    echo "1. Open https://extensions.gnome.org/extension/$EXTENSION_ID/clipboard-indicator/"
    echo "2. Click 'Install' button"
    echo "3. Confirm installation in your browser"
    echo ""
    echo "Alternatively, use Extension Manager app to search for 'Clipboard Indicator'"
    read -p "Press Enter after installing the extension..."
fi

# Enable the extension
gnome-extensions enable "$EXTENSION_UUID" 2>/dev/null || true

# Configure the keyboard shortcut to Super+V
echo "Configuring Super+V keyboard shortcut..."

# First, disable any existing Super+V shortcuts
gsettings set org.gnome.shell.keybindings toggle-message-tray "[]"

# Set the Clipboard Indicator shortcut
# Note: The extension uses its own settings schema
if command -v dconf &> /dev/null; then
    dconf write /org/gnome/shell/extensions/clipboard-indicator/toggle-menu "['<Super>v']"
    dconf write /org/gnome/shell/extensions/clipboard-indicator/history-size 50
    dconf write /org/gnome/shell/extensions/clipboard-indicator/display-mode 0
    dconf write /org/gnome/shell/extensions/clipboard-indicator/move-item-first true
    dconf write /org/gnome/shell/extensions/clipboard-indicator/enable-keybindings true
    echo "Keyboard shortcut configured: Super+V"
else
    echo "Warning: dconf not found. Please manually set the shortcut in the extension settings."
fi

echo ""
echo "Setup complete! Clipboard Indicator is now configured."
echo ""
echo "Features:"
echo "  • Press Super+V to open clipboard history"
echo "  • Click any item to paste it"
echo "  • Search through clipboard history"
echo "  • Stores last 50 clipboard items"
echo ""
echo "To customize settings:"
echo "  • Right-click the clipboard icon in the top panel"
echo "  • Select 'Settings'"
echo ""
echo "Note: You may need to log out and back in for all changes to take effect."
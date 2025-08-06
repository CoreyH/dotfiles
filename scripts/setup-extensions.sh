#!/bin/bash
# Setup GNOME extensions after they're installed

echo "=== Configuring GNOME Extensions ==="
echo ""

# Enable the extensions
echo "Enabling extensions..."
gnome-extensions enable dash-to-panel@jderose9.github.com 2>/dev/null || echo "  ⚠ Dash to Panel not installed yet"
gnome-extensions enable auto-move-windows@gnome-shell-extensions.gcampax.github.com 2>/dev/null || echo "  ⚠ Auto Move Windows not installed yet"

# Wait a moment for extensions to initialize
sleep 2

# Apply extension settings
if [ -f "$HOME/dotfiles/gnome/extension-settings.ini" ]; then
    echo "Applying extension settings..."
    dconf load /org/gnome/shell/extensions/ < "$HOME/dotfiles/gnome/extension-settings.ini"
    echo "  ✓ Extension settings applied"
fi

# Specific settings for dash-to-panel
echo "Configuring Dash to Panel..."
dconf write /org/gnome/shell/extensions/dash-to-panel/panel-positions '{"0":"TOP"}' 2>/dev/null || true
dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes '{"0":48}' 2>/dev/null || true
dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-margin 4 2>/dev/null || true
dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-padding 4 2>/dev/null || true

# Configure Auto Move Windows for 1Password
echo "Configuring Auto Move Windows..."
dconf write /org/gnome/shell/extensions/auto-move-windows/application-list "['1password.desktop:0']" 2>/dev/null || true

echo ""
echo "Extensions configured!"
echo ""

# Check if running Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "NOTE: Running on Wayland - you need to log out and back in"
    echo "      for all changes to take effect."
    echo ""
    echo "Log out now? (y/n)"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gnome-session-quit --logout --no-prompt
    fi
else
    echo "NOTE: Restart GNOME Shell (Alt+F2, type 'r', Enter)"
    echo "      or log out and back in for all changes to take effect."
fi
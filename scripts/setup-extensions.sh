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

# Apply dash-to-panel specific settings
if [ -f "$HOME/dotfiles/gnome/dash-to-panel-settings.ini" ]; then
    echo "Applying Dash to Panel settings..."
    dconf load / < "$HOME/dotfiles/gnome/dash-to-panel-settings.ini"
    echo "  ✓ Dash to Panel settings applied"
fi

# Specific settings for dash-to-panel
echo "Configuring Dash to Panel..."

# Get the primary monitor name (might be different on each system)
MONITOR=$(dconf read /org/gnome/shell/extensions/dash-to-panel/primary-monitor 2>/dev/null | tr -d "'")
if [ -z "$MONITOR" ]; then
    # If no monitor set, use first available or default
    MONITOR="0"
fi

# Core panel configuration
dconf write /org/gnome/shell/extensions/dash-to-panel/panel-anchors "{\"$MONITOR\":\"MIDDLE\"}" 2>/dev/null || \
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-anchors '{"0":"MIDDLE"}' 2>/dev/null || true

dconf write /org/gnome/shell/extensions/dash-to-panel/panel-positions "{\"$MONITOR\":\"TOP\"}" 2>/dev/null || \
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-positions '{"0":"TOP"}' 2>/dev/null || true

dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes "{\"$MONITOR\":48}" 2>/dev/null || \
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes '{"0":48}' 2>/dev/null || true

# Additional settings for consistent appearance
dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-margin 4 2>/dev/null || true
dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-padding 4 2>/dev/null || true
dconf write /org/gnome/shell/extensions/dash-to-panel/dot-position "'BOTTOM'" 2>/dev/null || true
dconf write /org/gnome/shell/extensions/dash-to-panel/isolate-workspaces true 2>/dev/null || true

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
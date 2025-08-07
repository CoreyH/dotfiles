#!/bin/bash

echo "Customizing Workspace Indicator size..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Extension path
EXT_PATH="$HOME/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com"

if [ ! -d "$EXT_PATH" ]; then
    echo "Workspace Indicator extension not found in user directory."
    echo "Make sure it's installed via Extension Manager."
    exit 1
fi

# Backup original stylesheets
if [ ! -f "$EXT_PATH/stylesheet-dark.css.backup" ]; then
    cp "$EXT_PATH/stylesheet-dark.css" "$EXT_PATH/stylesheet-dark.css.backup"
    echo "Created backup of original stylesheet"
fi

# Create custom stylesheet with smaller workspace buttons
cat > "$EXT_PATH/stylesheet-dark-custom.css" << 'EOF'
/*
 * Custom stylesheet for smaller workspace indicators
 * Optimized for 7+ workspaces
 */

.workspace-indicator .status-label {
  padding: 0 4px;  /* Reduced from 8px */
}

.workspace-indicator .workspaces-view.hfade {
  -st-hfade-offset: 20px;
}

.workspace-indicator-menu .workspaces-view {
  max-width: 480px;
}

.workspace-indicator .workspaces-box {
  spacing: 2px;  /* Reduced from 3px */
}

.workspace-indicator-menu .workspaces-box {
  padding: 5px;
  spacing: 6px;
}

.workspace-indicator .workspace-box {
  padding-top: 3px;  /* Reduced from 5px */
  padding-bottom: 3px;  /* Reduced from 5px */
}

.workspace-indicator StButton:first-child:ltr > .workspace-box,
.workspace-indicator StButton:last-child:rtl > .workspace-box {
  padding-left: 3px;  /* Reduced from 5px */
}
.workspace-indicator StButton:last-child:ltr > .workspace-box,
.workspace-indicator StButton:first-child:rtl > .workspace-box {
  padding-right: 3px;  /* Reduced from 5px */
}

.workspace-indicator-menu .workspace-box {
  spacing: 6px;
}

.workspace-indicator-menu .workspace,
.workspace-indicator .workspace {
  border: 1px solid transparent;
  border-radius: 4px;
  background-color: #3f3f3f;
}

.workspace-indicator .workspace {
  width: 36px;  /* Reduced from 52px - good for 7+ workspaces */
}

.workspace-indicator-menu .workspace {
  height: 80px;
  width: 160px;
}

.workspace-indicator-menu .workspace.active,
.workspace-indicator .workspace.active {
  border-color: #fff;
}

.workspace-indicator-window-preview {
  background-color: #bebebe;
  border: 1px solid #828282;
  border-radius: 1px;
}

.workspace-indicator-window-preview.active {
  background-color: #d4d4d4;
}
EOF

# Replace the original with custom version
cp "$EXT_PATH/stylesheet-dark-custom.css" "$EXT_PATH/stylesheet-dark.css"

echo -e "${GREEN}✓ Workspace Indicator customized!${NC}"
echo ""
echo "Changes made:"
echo "  • Workspace width: 52px → 36px (30% smaller)"
echo "  • Reduced padding between workspaces"
echo "  • Optimized for 7+ workspaces"
echo ""
echo "To restore original size:"
echo "  cp $EXT_PATH/stylesheet-dark.css.backup $EXT_PATH/stylesheet-dark.css"
echo ""
echo -e "${YELLOW}You need to restart GNOME Shell or log out/in for changes to take effect.${NC}"
echo ""
echo "Press Alt+F2, type 'r' and press Enter (X11 only)"
echo "Or log out and back in (required for Wayland)"
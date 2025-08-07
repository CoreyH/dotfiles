# Workspace Indicator Customization

## Overview
The default GNOME Workspace Indicator extension displays workspace buttons that can be too large when using many workspaces (7+). This customization reduces their size for better fit.

## Installation
1. First install Workspace Indicator extension via Extension Manager
2. Run the customization script:
   ```bash
   ~/dotfiles/scripts/customize-workspace-indicator.sh
   ```
3. Log out and back in (required on Wayland)

## What It Changes
- Workspace button width: 52px → 36px (30% smaller)
- Reduced padding between workspaces
- Reduced status label padding
- Optimized for 7+ workspaces

## Further Customization
To make workspaces even smaller, edit the script and change line 53:
- Current: `width: 36px;`
- Smaller: `width: 30px;` or `width: 28px;`

Then run the script again and restart GNOME Shell.

## Restore Original Size
To revert to default size:
```bash
cp ~/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com/stylesheet-dark.css.backup \
   ~/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com/stylesheet-dark.css
```
Then log out and back in.

## Files Modified
- `~/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com/stylesheet-dark.css`
- Backup saved as: `stylesheet-dark.css.backup`

## Notes
- Changes persist across extension updates (may need to re-run after major updates)
- Works with both dark and light themes (light theme imports dark stylesheet)
- Compatible with Dash to Panel extension
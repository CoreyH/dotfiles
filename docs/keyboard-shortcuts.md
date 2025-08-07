# Keyboard Shortcuts Reference

## Windows-Style Shortcuts (Current Configuration)

These shortcuts have been configured to match Windows behavior on your Fedora system.

### Window Management
| Shortcut | Action | Notes |
|----------|--------|-------|
| **Alt+F4** | Close window | Same as Windows |
| **Alt+Tab** | Switch between windows | Same as Windows |
| **Super+Tab** | Switch between applications | Groups windows by app |
| **Super+D** | Show desktop | Same as Windows |
| **Super+Up** | Maximize window | Same as Windows |
| **Super+Down** | Minimize/Restore window | Same as Windows |
| **Super+Left** | Snap window to left half | Same as Windows |
| **Super+Right** | Snap window to right half | Same as Windows |

### System Shortcuts
| Shortcut | Action | Notes |
|----------|--------|-------|
| **Super** | Open search/activities | Like Windows Start |
| **Super+L** | Lock screen | Same as Windows |
| **Super+E** | Open file manager | Same as Windows Explorer |
| **Ctrl+Alt+T** | Open terminal | Linux standard |

### Screenshots
| Shortcut | Action | Notes |
|----------|--------|-------|
| **Ctrl+Print Screen** | Flameshot (advanced) | DHH's Omakub choice - annotations, blur, etc. |
| **Super+Shift+S** | GNOME screenshot | Like Windows Snipping Tool - simple selection |
| **Print Screen** | Full screenshot | Standard full screen capture |
| **Alt+Print Screen** | Window screenshot | Current window |

### Text Editing (Work in Most Apps)
| Shortcut | Action | Notes |
|----------|--------|-------|
| **Ctrl+C** | Copy | Universal |
| **Ctrl+X** | Cut | Universal |
| **Ctrl+V** | Paste | Universal |
| **Ctrl+Z** | Undo | Universal |
| **Ctrl+A** | Select all | Universal |
| **Ctrl+S** | Save | Universal |
| **Ctrl+F** | Find | Universal |

### Browser Shortcuts (Edge/Chrome/Firefox)
| Shortcut | Action | Notes |
|----------|--------|-------|
| **Ctrl+T** | New tab | Same as Windows |
| **Ctrl+Shift+T** | Reopen closed tab | Same as Windows |
| **Ctrl+W** | Close tab | Same as Windows |
| **Ctrl+Tab** | Next tab | Same as Windows |
| **Ctrl+Shift+Tab** | Previous tab | Same as Windows |
| **F5** | Refresh | Same as Windows |
| **Ctrl+D** | Bookmark page | Same as Windows |
| **F11** | Full screen | Same as Windows |

## Differences from Windows

### What's Different
- **No Windows+X menu** - Use right-click on Activities instead
- **No Windows+Tab** - Super+Tab switches apps instead
- **No Windows+Number** - Not configured for launching dock apps
- **Virtual Desktops** - Use Super+Page Up/Down to switch

### Linux-Specific Additions
| Shortcut | Action | Notes |
|----------|--------|-------|
| **Ctrl+Alt+F2-F6** | Switch to TTY | Text terminals |
| **Ctrl+Alt+F1/F7** | Return to GUI | From TTY |
| **Alt+F2** | Run command | Quick launcher |

## Customization

### Apply Windows Shortcuts
```bash
~/dotfiles/scripts/setup-windows-shortcuts.sh
```

### View Current Shortcuts
```bash
# Open GNOME Settings
gnome-control-center keyboard

# Or use fedora-config menu
fedora-config
# Select: Set Keyboard Shortcuts
```

### Reset to Defaults
```bash
# Reset all keyboard shortcuts
dconf reset -f /org/gnome/desktop/wm/keybindings/
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/
```

## Tips

1. **Super Key** (Windows key) behavior:
   - Single press: Opens Activities (search/overview)
   - Hold + other key: Triggers shortcuts

2. **Virtual Desktops** (Workspaces):
   - Super+Page Up/Down: Switch workspaces
   - Super+Shift+Page Up/Down: Move window to workspace

3. **Quick App Switching**:
   - Alt+Tab: Switch windows (shows all windows)
   - Super+Tab: Switch apps (groups by application)

4. **Terminal Shortcuts**:
   - Ctrl+Shift+C: Copy in terminal
   - Ctrl+Shift+V: Paste in terminal
   - Ctrl+Shift+T: New terminal tab

## Troubleshooting

### Shortcuts Not Working
1. Log out and back in after applying changes
2. Check for conflicts in Settings → Keyboard
3. Some apps may override system shortcuts

### Reset Specific Shortcut
```bash
# Example: Reset close window
gsettings reset org.gnome.desktop.wm.keybindings close
```

### View Current Setting
```bash
# Example: Check close window shortcut
gsettings get org.gnome.desktop.wm.keybindings close
```
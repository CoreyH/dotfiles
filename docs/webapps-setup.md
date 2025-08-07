# Web Apps Setup Guide

## Overview
Creates Edge-based Progressive Web Apps (PWAs) that run like native applications, similar to Linux Mint's webapp-manager but using Microsoft Edge.

## Features
- Each app runs in its own Edge profile (separate cookies/storage)
- Apps appear as standalone windows without browser UI
- Pin to dock/dash for quick access
- Native desktop integration

## Current Web Apps

### Communication
- **WhatsApp** - WhatsApp Web
- **Google Messages** - SMS/RCS from computer
- **Google Contacts** - Contact management

### Productivity
- **ChatGPT** - OpenAI's ChatGPT
- **Claude** - Anthropic's Claude AI
- **Notion** - Notes and project management
- **GitHub** - Code repository hosting

### Media
- **YouTube** - Video streaming
- **Google Photos** - Photo storage and management
- **Spotify** - Music streaming

### Social
- **X** (Twitter) - Social media platform

## Installation

### Automated Setup
```bash
# Run the webapp creation script
~/dotfiles/scripts/create-webapps.sh

# Options:
# 1) Install all preconfigured apps
# 2) Select specific apps
# 3) Add custom app
```

### Manual Creation
To create a web app manually:

1. Create desktop file in `~/.local/share/applications/AppName.desktop`:
```ini
[Desktop Entry]
Version=1.0
Name=AppName
Comment=AppName Web App
Exec=microsoft-edge --new-window --app="https://example.com/" --class="AppName" --user-data-dir="/home/username/.config/microsoft-edge-webapps/AppName"
Terminal=false
Type=Application
Icon=/home/username/.local/share/applications/icons/AppName.png
StartupNotify=true
StartupWMClass=AppName
Categories=Network;WebBrowser;
```

2. Add icon to `~/.local/share/applications/icons/AppName.png`

3. Update desktop database:
```bash
update-desktop-database ~/.local/share/applications
```

## Configuration

### Web App List
The list of available web apps is stored in `~/dotfiles/webapps/webapp-list.json`. Edit this file to add or modify apps.

### Icons
Icons are stored in `~/dotfiles/webapps/icons/`. Use PNG format, ideally 256x256 or larger.

### Edge Profiles
Each web app uses a separate Edge profile stored in:
```
~/.config/microsoft-edge-webapps/AppName/
```

This provides:
- Separate cookies and session storage
- Independent settings
- Isolated browsing data

## Usage

### Launching Apps
1. **From Activities**: Press Super key and search for app name
2. **From Terminal**: Click the desktop file or run the Exec command
3. **Pinned to Dock**: Right-click running app → "Pin to Dash"

### Managing Apps
- **Remove app**: Delete the .desktop file and profile directory
- **Reset app**: Delete the profile directory in `~/.config/microsoft-edge-webapps/`
- **Update URL**: Edit the .desktop file

## Tips

### Best Apps for Web App Treatment
- Apps you keep open all day (WhatsApp, Slack, Discord)
- Apps that send notifications (Gmail, Messages)
- Single-purpose tools (ChatGPT, Calculator)
- Media players (YouTube, Spotify)

### Keyboard Shortcuts
Assign keyboard shortcuts in Settings → Keyboard → Custom Shortcuts:
- Super+W for WhatsApp
- Super+G for GitHub
- Super+C for ChatGPT

### Notifications
Most web apps support native desktop notifications. Allow notifications when prompted on first launch.

## Troubleshooting

### App Won't Launch
- Ensure Microsoft Edge is installed: `which microsoft-edge`
- Check the desktop file has execute permissions: `chmod +x ~/.local/share/applications/AppName.desktop`

### Icon Not Showing
- Verify icon path in desktop file
- Ensure icon is PNG format
- Run `update-desktop-database ~/.local/share/applications`

### Multiple Windows Opening
- Check `StartupWMClass` matches the `--class` parameter
- Ensure `X-GNOME-SingleWindow=true` is set

### Reset Web App
```bash
# Remove app data but keep desktop entry
rm -rf ~/.config/microsoft-edge-webapps/AppName/
```

## Alternative: GNOME Web (Epiphany)
GNOME Web also supports installing sites as web apps:
```bash
sudo dnf install epiphany
```
Then use "Install as Web Application" from the menu.

## Comparison with webapp-manager
| Feature | Our Solution | webapp-manager |
|---------|-------------|----------------|
| Browser | Microsoft Edge | Various (Chrome, Firefox, etc.) |
| Profiles | Separate Edge profiles | Browser-specific |
| Icons | Manual/Script | Automatic download |
| Categories | Yes | Yes |
| Easy removal | Manual | GUI |

## References
- [Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/latest/)
- [Microsoft Edge Command Line Options](https://docs.microsoft.com/en-us/deployedge/microsoft-edge-configure-kiosk-mode)
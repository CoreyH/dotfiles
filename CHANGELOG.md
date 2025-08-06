# Changelog

## 2024-08-06 - Omakub-Inspired Features

### Added
- `fedora-config` interactive configuration menu
  - Theme management
  - Extension configuration
  - Software installation
  - System updates
  - OneDrive controls
  - Quick actions
- Bash aliases file with productivity shortcuts
- Helper functions (extract, mkcd, backup, sysinfo)
- Omakub-style installer with ASCII art
- ~/bin directory for user commands

### Inspired By
- DHH's Omakub/Omarchy approach to Linux configuration
- Focus on single command (`fedora-config`) for all settings
- Opinionated defaults with easy customization

## 2024-08-06 - VM Testing & Fixes

### Added
- Extension configuration script (`scripts/setup-extensions.sh`)
- Dash to Panel settings with proper centering
- Wayland session detection and handling
- Comprehensive error handling in installer
- Essential GNOME settings file for better compatibility
- Optional packages list for non-critical software

### Fixed
- Package installation now handles missing packages gracefully
- GNOME settings application doesn't fail on locked/missing keys  
- Extension settings properly apply including panel centering
- Scripts preserve executable permissions through Git

### Tested
- Full replication on Fedora VM successful
- OneDrive selective sync working
- GNOME extensions configure properly
- All core functionality verified

## 2024-08-06 - Initial Setup

### Created
- GitHub private repository for dotfiles
- Modular installation script
- OneDrive selective sync configuration
- Package management system
- GNOME settings export/import
- Helper scripts for common tasks

### Configured
- Fedora 42 base environment
- Dash to Panel extension
- Auto Move Windows for 1Password
- Microsoft Edge as default browser
- Dark mode and productivity settings
# Changelog

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
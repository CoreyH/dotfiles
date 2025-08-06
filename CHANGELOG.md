# Changelog

## 2025-08-06 - Microsoft Edge Configuration

### Added
- **Edge Installation & Setup Documentation** (`docs/edge-setup.md`)
  - Proper RPM installation method for 1Password compatibility
  - Profile management for 7 different contexts
  - Clear breakdown of what syncs vs manual configuration
- **Edge Profile Configuration Script** (`scripts/configure-edge-profiles.sh`)
  - Automated common settings across all profiles
  - Desktop shortcut creation for each profile
  - Theme, downloads, and privacy settings
- **Edge Installation Script** (`scripts/install-edge.sh`)
  - Ensures RPM installation (not Flatpak)
  - Handles existing Flatpak installations
- **Menu Integration**
  - Added Edge configuration to `fedora-config` menu

### Key Decisions
- Must use RPM installation for 1Password browser extension compatibility
- Accepted that some settings (theme, search) require manual configuration per profile
- Created automation for repetitive settings while respecting Microsoft sync

### Known Limitations
- Microsoft account sign-in must be done manually per profile
- Theme selection doesn't fully sync and needs manual setting
- Search engine preference often overridden by account sync

## 2025-08-06 - CLAUDE.md Synchronization

### Fixed
- Resolved CLAUDE.md file duplication issue
- Created symlink from ~/CLAUDE.md to ~/dotfiles/CLAUDE.md
- Ensured single source of truth for AI context

### Changed
- Claude Code should now be started from ~/dotfiles directory

## 2024-08-06 - Terminal and Prompt Enhancements

### Added
- **Alacritty Configuration**
  - Tokyo Night theme (default)
  - Multiple theme options (Catppuccin, Dracula)
  - CaskaydiaCove Nerd Font setup
  - Automated setup script
- **Starship Prompt**
  - Modern, fast prompt with Git integration
  - Language version detection
  - Custom configuration
- **Prompt Options**
  - Starship (recommended)
  - Custom bash prompt
  - PowerShell-style prompt
  - `prompt-switch` command for easy switching

### Fixed
- Color escape sequences in prompts
- Bash comparison operators for Git status

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
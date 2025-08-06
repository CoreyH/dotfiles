# Corey's Fedora Dotfiles

My personal Fedora Workstation configuration for multi-machine setup.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles
./install.sh
```

## What's Included

- **GNOME Settings**: Dark mode, extensions, keyboard shortcuts
- **OneDrive**: Selective sync configuration (Documents & Desktop)
- **Apps**: Edge, 1Password, development tools
- **Shell**: Bash configuration and aliases
- **Scripts**: Helper utilities for system management

## Structure

```
.
├── bash/           # Shell configuration
├── git/            # Git configuration
├── gnome/          # GNOME settings and extensions
├── onedrive/       # OneDrive sync configuration
├── packages/       # Package lists
├── scripts/        # Helper scripts
├── CLAUDE.md       # AI assistant context
└── install.sh      # Main installation script
```

## Manual Steps After Installation

1. **OneDrive Authentication**:
   ```bash
   onedrive
   # Follow the prompts
   onedrive --sync --resync
   systemctl --user enable --now onedrive
   ```

2. **Install GNOME Extensions**:
   - Open Extension Manager
   - Install: Dash to Panel, Auto Move Windows

3. **Sign in to Apps**:
   - Microsoft Edge
   - 1Password

## Updating

```bash
cd ~/dotfiles
git pull
./install.sh  # Re-run to apply updates
```
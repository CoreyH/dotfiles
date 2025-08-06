# Corey's Fedora Dotfiles

My personal Fedora Workstation configuration for multi-machine setup.

**Note**: This is a private repository for personal use.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles
chmod +x install.sh  # Only needed if executable bit wasn't preserved
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

1. **Install GNOME Extensions**:
   - Open Extension Manager
   - Search and install: 
     - Dash to Panel
     - Auto Move Windows
   - After installing, run: `~/dotfiles/scripts/setup-extensions.sh`
   - Log out and back in (required on Wayland)

2. **OneDrive Authentication**:
   ```bash
   onedrive
   # Follow the prompts
   onedrive --sync --resync
   systemctl --user enable --now onedrive
   ```

3. **Sign in to Apps**:
   - Microsoft Edge
   - 1Password
   - GitHub CLI: `gh auth login --web`

## Updating

```bash
cd ~/dotfiles
git pull
./install.sh  # Re-run to apply updates
```
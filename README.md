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
- **Shell**: Bash configuration and productivity aliases
- **Scripts**: Helper utilities for system management
- **Config Menu**: `fedora-config` command for easy customization (Omakub-inspired)

## Structure

```
.
├── bash/           # Shell configuration and aliases
├── bin/            # User commands (fedora-config)
├── git/            # Git configuration
├── gnome/          # GNOME settings and extensions
├── onedrive/       # OneDrive sync configuration
├── packages/       # Package lists
├── scripts/        # Helper scripts
├── CLAUDE.md       # AI assistant context
└── install.sh      # Main installation script
```

## Key Features

### 🎛️ Configuration Menu (`fedora-config`)
Access all settings from one place:
- Theme switching (dark/light/auto)
- Extension configuration
- Software installation
- Keyboard shortcuts
- System updates
- OneDrive management
- Quick actions

### 🚀 Starship Prompt
Beautiful, fast, Git-aware prompt showing:
- Current directory with smart truncation
- Git branch, status, and changes
- Language versions (Python, Node, Rust, etc.)
- Command execution status
- Customizable via `~/.config/starship.toml`

### 🖥️ Alacritty Terminal
Pre-configured with:
- Tokyo Night theme (default)
- Multiple themes available (Catppuccin, Dracula)
- CaskaydiaCove Nerd Font
- Proper keybindings for copy/paste
- 95% opacity with blur

### ⚡ Productivity Aliases
Quick commands for common tasks:
- `config` - Open configuration menu
- `dots` - Jump to dotfiles directory
- `update` - Update system and flatpaks
- `odsync` - Sync OneDrive
- `backup <file>` - Quick file backup
- `extract <archive>` - Extract any archive format
- `mkcd <dir>` - Make directory and enter it
- `sysinfo` - System information overview
- `prompt-switch` - Switch between prompt styles

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
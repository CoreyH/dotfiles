# Corey's Dotfiles (Fedora + macOS)

My personal workstation configuration. Originally targeting Fedora; now with macOS support.

**Note**: This is a private repository for personal use.

## Fedora Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles
chmod +x install.sh  # Only needed if executable bit wasn't preserved
./install.sh
```

## What's Included (Fedora)

- **GNOME Settings**: Dark mode, extensions, keyboard shortcuts
- **OneDrive**: Selective sync configuration (Documents & Desktop)
- **Apps**: Edge, 1Password, development tools, Claude Code
- **Shell**: Bash configuration and productivity aliases
- **Scripts**: Helper utilities for system management
- **Config Menu**: `fedora-config` command for easy customization (Omakub-inspired)
- **Development Tools**: Volta (Node.js manager), Claude Code CLI
- **Web Apps**: Edge-based PWAs for ChatGPT, WhatsApp, GitHub, etc.

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
├── zsh/            # macOS zsh configs
├── homebrew/       # macOS Brewfile
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

## macOS Quick Start

1) Bootstrap macOS (links zsh configs, user bin, etc.):

```
./scripts/bootstrap-macos.sh
```

2) Install recommended tools via Homebrew Bundle (optional):

```
brew bundle --file homebrew/Brewfile
```

3) Restart terminal or run `exec zsh -l`.

Notes:
- Homebrew shellenv is set in `~/.zprofile`. Interactive customizations live in `~/.zshrc`.
- Volta is recommended for Node.js. See `scripts/migrate-nvm-to-volta.sh` if coming from nvm.

## Windows Quick Start

1) Bootstrap Windows (installs PowerShell profile and user bin):

```
powershell -ExecutionPolicy Bypass -File .\\windows\\bootstrap.ps1
```

2) Optional packages: install via `winget` or Scoop (not included yet).

Notes:
- PowerShell profile lives at `$PROFILE`. Repo profile is `windows/profile.ps1`.
- Volta works on Windows; consider standardizing Node.js via Volta here too.
- If using direnv, add it via Scoop and the profile hook will enable it.

## Linux Quick Start (generic)

If you want only dotfile links (not full Fedora installer):

```
./scripts/bootstrap-linux.sh
```

Then continue using distro-specific package managers as needed.

## Manual Steps After Installation (Fedora)

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

3. **Microsoft Edge Setup**:
   - Sign in to each profile (7 profiles for different contexts)
   - For each profile, manually set:
     - Theme (Settings → Appearance → Theme)
     - Downloads location
     - 1Password extension verification
   - See `docs/edge-setup.md` for detailed instructions

4. **Sign in to Apps**:
   - 1Password desktop app
   - GitHub CLI: `gh auth login --web`

## Updating

```bash
cd ~/dotfiles
git pull
./install.sh  # Re-run to apply updates
```

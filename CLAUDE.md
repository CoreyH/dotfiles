# Corey's Fedora Environment Setup

> Note: Live status and daily changes moved to STATUS.md. This doc stays evergreen and concise.

## Table of Contents
- Quick Start
- Current Environment
- Useful Commands
- Setup Guide (Edge, 1Password, Volta, Extensions, OneDrive)
- Web Apps (Edge PWAs)
- Multi‑Machine Sync Strategy
- Key Learnings & Decisions
- Building Apps on ARM64 Fedora
- Troubleshooting

## Quick Start
```bash
# Prereqs
sudo dnf install -y gh desktop-file-utils
gh auth login --web

# Clone dotfiles (choose one)
gh repo clone <owner>/dotfiles ~/dotfiles
# or
git clone git@github.com:<owner>/dotfiles.git ~/dotfiles

cd ~/dotfiles
./install.sh

# Optional but recommended
./scripts/install-volta.sh
source ~/.bashrc
./scripts/install-claude-code.sh

# GNOME extensions and clipboard manager
./scripts/setup-extensions.sh
./scripts/setup-clipboard-manager.sh

# OneDrive
onedrive            # authenticate
onedrive --sync --resync
systemctl --user enable --now onedrive
systemctl --user status onedrive --no-pager

# Edge profiles and PWAs
./scripts/configure-edge-profiles.sh
```

## Current Environment
- **OS**: Fedora Linux 42
- **Desktop Environment**: GNOME with Dash to Panel extension
- **Browser**: Microsoft Edge (preferred over Firefox)
- **Multi-computer sync**: Planning to sync across multiple machines

## Completed Customizations

### Apps on All Workspaces
For apps like 1Password to appear on all virtual desktops:
1. **Temporary**: Right-click title bar → "Always on Visible Workspace"
2. **Permanent**: Using Auto Move Windows extension
   ```bash
   # View current settings
   dconf read /org/gnome/shell/extensions/auto-move-windows/application-list
   
   # Set app to all workspaces (use :0)
   dconf write /org/gnome/shell/extensions/auto-move-windows/application-list "['1password.desktop:0']"
   ```

## Goals & Preferences
- Emulate best features from Windows and macOS
- Set up consistent environment across multiple computers
- Productivity-focused workflow

## Useful Commands
```bash
# Find window class for Auto Move Windows
xprop WM_CLASS  # Then click on target window

# Manage GNOME extensions
gnome-extensions list
gnome-extensions prefs [extension-name]
```

## Setup Guide

### Install Microsoft Edge (RPM)
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[microsoft-edge]\nname=Microsoft Edge\nbaseurl=https://packages.microsoft.com/yumrepos/edge\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/microsoft-edge.repo'
sudo dnf install -y microsoft-edge-stable
```

### Install 1Password (RPM)
```bash
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'cat << REPO > /etc/yum.repos.d/1password.repo
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/
enabled=1
gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
repo_gpgcheck=1
REPO'
sudo dnf install -y 1password 1password-cli
```

### Desktop File Utilities
```bash
sudo dnf install -y desktop-file-utils
# Needed for update-desktop-database
```

### Claude Code + Volta
```bash
./scripts/install-volta.sh
source ~/.bashrc
./scripts/install-claude-code.sh
```

### GNOME Extensions
```bash
./scripts/setup-extensions.sh
```

### Clipboard Manager (Super+V)
```bash
./scripts/setup-clipboard-manager.sh
```

### OneDrive (abraunegg client)
```bash
sudo dnf install -y onedrive
onedrive                 # authenticate
onedrive --sync --resync
systemctl --user enable --now onedrive
systemctl --user status onedrive --no-pager
journalctl --user -u onedrive --since today --no-pager
```

## Web Apps (Edge PWAs)
- Include `--class` for separate dock icons
- Required format: `browser --app="URL" --class="AppName" --user-data-dir="/path"`
- Icon path must be absolute; `StartupWMClass` must match `--class`
- `update-desktop-database` requires `desktop-file-utils`

Example mapping `WM_CLASS` to `StartupWMClass`:
```bash
xprop WM_CLASS   # click the target window
# Use the first returned value (exact case) as StartupWMClass
```

## Multi-Machine Sync Strategy

### File Syncing (Tiered Approach)
1. **Hot Files** (OneDrive via abraunegg client): Active documents, projects
   - Already have 1TB with Microsoft 365
   - Using abraunegg/onedrive client (stable, production-ready)
   - Selective sync configured via `~/.config/onedrive/sync_list`
   - Currently syncing: Documents/, Desktop/
2. **Cold Storage** (NAS): Photography archives, backups
3. **Local SSD**: Current projects for speed

### OneDrive Setup (abraunegg client)
- **Installation**: `sudo dnf install onedrive`
- **Config location**: `~/.config/onedrive/`
- **Selective sync**: Edit `~/.config/onedrive/sync_list`
  - Format: Simple folder names with trailing slash (e.g., `Documents/`)
  - Changes require `onedrive --sync --resync`
- **Commands**:
  ```bash
  onedrive --sync          # Manual sync
  onedrive --monitor       # Real-time monitoring
  systemctl --user enable onedrive  # Auto-sync service
  systemctl --user status onedrive --no-pager
  journalctl --user -u onedrive --since today --no-pager
  ```
- **Scripts created**:
  - `~/setup-onedrive.sh` - Initial setup helper
  - `~/clean-restart-onedrive.sh` - Clean restart with selective sync

### Dotfiles Management (GitHub Private Repo)
- **Repository**: Private GitHub repo (security > sharing)
- **Structure**: Organized by component:
  - `packages/` - DNF package lists
  - `scripts/` - Setup and helper scripts
  - `gnome/` - GNOME settings and extensions
  - `onedrive/` - OneDrive sync configuration
  - `git/` - Git configuration templates
- **Installation**: Clone and run `./install.sh`
- **Workflow for new software**:
  1. Install locally: `sudo dnf install package-name`
  2. Add to `packages/dnf.txt`
  3. Commit and push: `cd ~/dotfiles && git add -A && git commit -m "Add package" && git push`
  4. On other machines: `cd ~/dotfiles && git pull && ./install.sh`
- **Authentication**: Handled per-machine (gh auth, OneDrive auth, etc.)

### Other Sync Components
- **Passwords**: 1Password (already configured)
- **Browser**: Microsoft Edge with account sync
- **System Settings**: dconf dumps stored in dotfiles repo

## Key Learnings & Decisions

### Things to Know Before Starting
These are insights gained during setup that would have been helpful from the beginning:

#### Installation Order Matters
1. **Edge before 1Password** - Must use RPM installation, not Flatpak, for 1Password extension compatibility
2. **Volta before Claude Code** - Better Node.js management without sudo requirements
3. **GNOME extensions before customization** - Extensions must be installed via GUI first, then configured

#### Multi-Machine Sync Realities
- **What doesn't sync**: API keys, authentication tokens, Edge themes per profile
- **What partially syncs**: Edge settings (theme still manual), GNOME settings (some keys locked)
- **What syncs well**: Files via OneDrive, browser bookmarks/extensions, dotfiles via Git

#### Tool Choices That Worked
- **OneDrive**: abraunegg client > OneDriver (handles thousands of files better)
- **Screenshots**: Flameshot > default (annotation features worth the extra tool)
- **Prompts**: Starship > custom bash (better Git integration, easier maintenance)
- **Terminal**: Alacritty > GNOME Terminal (better performance, themes)
- **Web Apps**: Edge PWAs > webapp-manager (already have Edge, simpler)

#### Script Design Lessons
- **Idempotency is key**: Scripts should detect existing configs and skip
- **Symlinks > copies**: Link configs from dotfiles repo for easy updates
- **Check before configuring**: Avoid duplicate desktop entries, redundant settings
- **User feedback**: Show what's happening, but skip what's already done

#### Fedora/GNOME Specifics
- **Wayland limitations**: Can't restart GNOME Shell with Alt+F2 'r', must log out/in
- **dconf quirks**: Some keys are locked/unavailable, handle gracefully
- **Package availability**: Not all Ubuntu packages exist in Fedora (neofetch, etc.)
- **Fingerprint + sudo**: Works great on Framework laptop, occasional timeouts

#### Edge Profile Management
- **7 profiles = complexity**: Each needs manual theme setting after sign-in
- **Separate data dirs**: Each web app needs its own Edge profile for isolation
- **Desktop entries**: Careful with StartupWMClass to prevent multiple windows
- **1Password compatibility**: RPM only, Flatpak sandboxing breaks native messaging

#### What Can't Be Automated
- **Authentication**: OneDrive, GitHub, Microsoft accounts - all need manual auth
- **Browser profiles**: Sign-in and theme selection remain manual per profile
- **Extension installation**: GNOME extensions need GUI installation first
- **Some preferences**: Certain GNOME/app settings locked or reset on sync

#### Web App Desktop Files (Edge/Brave/Chromium)
- **Must include --class parameter**: Without `--class="AppName"`, apps won't get separate dock icons
- **Required format**: `browser-command --app="URL" --class="AppName" --user-data-dir="/path"`
- **Icon path must be absolute**: Use full path like `/home/user/.local/share/applications/icons/App.png`
- **StartupWMClass must match --class**: Both should use the same "AppName" for proper window grouping
- **Icon filename must match app name exactly**: Including spaces (e.g., "Gmail - Work.png" not "Gmail-Work.png")
- **Multiple profiles for same site**: Use different app names like "Gmail - Personal" and "Gmail - Work"
- **Brave PWA support**: Works identically to Edge, just use `brave-browser` command
- **Script error handling**: Use `set -Eeuo pipefail`; guard non‑critical steps (e.g., icon downloads)
- **Browser selection**: Script at `~/dotfiles/scripts/create-webapps.sh` supports Brave, Edge, and Chromium

## Building Apps on ARM64 Fedora

### Native ARM64 Apps Available
- **1Password**: Full native ARM64 support! Download from official site
- **Obsidian**: Native ARM64 AppImage available
- **Cursor IDE**: ARM64 builds available
- **VSCode**: Microsoft provides ARM64 builds

### AppImage Compatibility
- **x86_64 AppImages won't run on ARM64**: Architecture mismatch causes FUSE/FEX emulator failures
- **Solution**: Build from source or find ARM64-specific releases
- **Common error**: "fuse: failed to open /dev/fuse: Permission denied" when trying x86_64 AppImage on ARM64
- **Install deps**: `sudo dnf install -y fuse fuse3` (some AppImages still require FUSE v2)
- **Workaround**: Extract AppImage with `--appimage-extract` to bypass FUSE

### Building Tauri Apps from Source (like Claudia)

#### Required System Dependencies
```bash
# Core development tools
sudo dnf install -y gcc gcc-c++ make

# GTK and system libraries
sudo dnf install -y gtk3-devel glib2-devel cairo-devel pango-devel \
  atk-devel gdk-pixbuf2-devel libsoup3-devel webkit2gtk4.1-devel \
  librsvg2-devel openssl-devel javascriptcoregtk4.1-devel

# Perl modules for OpenSSL compilation
sudo dnf install -y perl-IPC-Cmd perl-devel perl-FindBin \
  perl-File-Compare perl-File-Copy
```

#### Build Tools Setup
1. **Rust**: Install via rustup, not dnf
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   source "$HOME/.cargo/env"
   ```

2. **Bun** (JavaScript runtime): Better than npm for Tauri
   ```bash
   curl -fsSL https://bun.sh/install | bash
   source ~/.bashrc
   ```

3. **Create GCC symlinks for ARM64** (Rust looks for specific names):
   ```bash
   mkdir -p ~/.local/bin
   ln -s /usr/bin/gcc ~/.local/bin/aarch64-linux-gnu-gcc
   ln -s /usr/bin/g++ ~/.local/bin/aarch64-linux-gnu-g++
   export PATH="$HOME/.local/bin:$PATH"
   ```

#### Common Build Issues & Solutions
- **OpenSSL fails**: Missing perl-IPC-Cmd module (install it)
- **GTK/GLib errors**: Missing development packages (install gtk3-devel, etc.)
- **"Can't detect appindicator"**: Non-critical for running app, only affects system tray
- **Long build times**: First build compiles all dependencies (~5-10 minutes on ARM64)

#### Creating Desktop Entries for Built Apps
```bash
# Create .desktop file
cat > ~/.local/share/applications/appname.desktop << EOF
[Desktop Entry]
Name=AppName
Comment=Description
Exec=/path/to/binary
Icon=appname
Terminal=false
Type=Application
Categories=Development;
StartupWMClass=appname
EOF

# Copy icon
mkdir -p ~/.local/share/icons
cp /path/to/icon.png ~/.local/share/icons/appname.png

# Update desktop database
update-desktop-database ~/.local/share/applications/
```

## Current Status
Moved to STATUS.md

## Quick Reference

### Replicate on New Machine
```bash
sudo dnf install -y gh desktop-file-utils
gh auth login --web

# Clone (pick one)
gh repo clone <owner>/dotfiles ~/dotfiles
# or
git clone git@github.com:<owner>/dotfiles.git ~/dotfiles

cd ~/dotfiles && ./install.sh

# Optional
./scripts/install-volta.sh && source ~/.bashrc
./scripts/install-claude-code.sh
./scripts/setup-extensions.sh
./scripts/setup-clipboard-manager.sh

# OneDrive
onedrive && onedrive --sync --resync
systemctl --user enable --now onedrive

# Edge
./scripts/configure-edge-profiles.sh
```

### Known Issues & Fixes
- **Missing packages**: Some packages (neofetch, gnome-shell-extension-manager) may not be available - installer handles gracefully
- **GNOME settings errors**: Some dconf keys may be locked or unavailable - normal, essential settings still apply
- **Wayland limitations**: Can't restart GNOME Shell with Alt+F2 'r' - must log out/in for extension changes
- **Panel not centered**: Run `~/dotfiles/scripts/setup-extensions.sh` after installing extensions

### Add New Software
```bash
# Install locally
sudo dnf install -y new-package

# Add to dotfiles
echo "new-package" >> ~/dotfiles/packages/dnf.txt
cd ~/dotfiles
git add -A && git commit -m "Add new-package" && git push
```

## GNOME Settings (dconf)
Repository dumps: `gnome/*.ini`.
```bash
# Dump current settings
dconf dump / > ~/dotfiles/gnome/full-dump.ini

# Load curated essentials from repo
dconf load / < ~/dotfiles/gnome/essential-settings.ini
```

## ARM64 Notes
If `webkit2gtk4.1-devel` isn’t available:
```bash
dnf search webkit2gtk | rg -i devel
```

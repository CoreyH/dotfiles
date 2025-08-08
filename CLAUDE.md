# Corey's Fedora Environment Setup

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

#### Edge Web App Desktop Files
- **Must include --class parameter**: Without `--class="AppName"`, apps won't get separate dock icons
- **Required format**: `microsoft-edge --new-window --app="URL" --class="AppName" --user-data-dir="/path"`
- **Icon path must be absolute**: Use full path like `/home/user/.local/share/applications/icons/App.png`
- **StartupWMClass must match --class**: Both should use the same "AppName" for proper window grouping

## Current Status (2025-08-06)

### Completed Today
- ✅ Fixed CLAUDE.md synchronization (symlinked to dotfiles)
- ✅ Created comprehensive Edge setup documentation and scripts
- ✅ Added Edge profile configuration to fedora-config menu
- ✅ Documented RPM vs Flatpak installation requirements for 1Password
- ✅ Added Claude Code installation to dotfiles
- ✅ Configured Windows-style keyboard shortcuts

### Keyboard Shortcuts
- Using Windows-style shortcuts (Alt+F4, Super+D, Super+E, etc.)
- Script: `scripts/setup-windows-shortcuts.sh`
- Documentation: `docs/keyboard-shortcuts.md`
- Most important shortcuts already match Windows defaults

### Claude Code Updates with Volta
- **Issue**: Claude Code self-updates but Volta registry doesn't reflect new version
- **Solution**: Run `~/dotfiles/scripts/update-claude-code.sh` to sync
- **How it works**: 
  1. Claude Code updates itself in-place
  2. Script runs `claude update` then `volta install @anthropic-ai/claude-code@latest`
  3. This syncs Volta's registry with the actual installed version

### Remaining Tasks
- Set up NAS mounting for cold storage access
- Test complete multi-machine sync workflow
- Answer remaining setup questions in `fedora-setup-questions.md`

## Quick Reference

### Replicate on New Machine
```bash
# Install gh and authenticate
sudo dnf install -y gh
gh auth login --web

# Clone and install
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh  # Only if needed
./install.sh

# Choose and setup prompt
./scripts/setup-prompt.sh  # Choose Starship (recommended)
source ~/.bashrc

# Setup Alacritty (if using)
./scripts/setup-alacritty.sh

# Install Claude Code (optional but recommended)
./scripts/install-volta.sh
source ~/.bashrc
volta install @anthropic-ai/claude-code
# Or use: ./scripts/install-claude-code.sh

# Install and configure GNOME extensions
# Use Extension Manager to install Dash to Panel and Auto Move Windows
~/dotfiles/scripts/setup-extensions.sh

# Set up clipboard manager (Windows-style Super+V)
./scripts/setup-clipboard-manager.sh
# Log out and back in

# Set up OneDrive
onedrive  # Authenticate
onedrive --sync --resync
systemctl --user enable --now onedrive

# Configure Edge profiles
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
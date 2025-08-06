# Corey's Fedora Environment Setup

## Current Environment
- **OS**: Fedora Linux 42
- **Desktop Environment**: GNOME with dock-to-panel extension
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

## Next Steps
- Push dotfiles to GitHub (run `~/push-dotfiles-to-github.sh`)
- Test replication on Fedora VM
- Configure NAS mounting for cold storage
- Answer setup questions in `fedora-setup-questions.md`
- Configure remaining Windows/macOS-like features

## Quick Reference

### Replicate on New Machine
```bash
# Install gh and authenticate
sudo dnf install -y gh
gh auth login --web

# Clone and install
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh

# Set up OneDrive
onedrive  # Authenticate
onedrive --sync --resync
systemctl --user enable --now onedrive
```

### Add New Software
```bash
# Install locally
sudo dnf install -y new-package

# Add to dotfiles
echo "new-package" >> ~/dotfiles/packages/dnf.txt
cd ~/dotfiles
git add -A && git commit -m "Add new-package" && git push
```
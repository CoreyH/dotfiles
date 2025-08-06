# Microsoft Edge Setup Guide

## Installation Method for 1Password Compatibility

### Important: Use Microsoft's Official RPM Repository
For 1Password browser extension to work properly, Edge must be installed from Microsoft's official repository, **not** from Flatpak or third-party sources.

```bash
# Add Microsoft Edge repository
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Install Edge
sudo dnf install microsoft-edge-stable

# Verify installation (should show RPM package)
rpm -qa | grep -i edge
# Expected: microsoft-edge-stable-XXX.x86_64
```

### Why Not Flatpak?
- Flatpak sandboxing prevents proper communication with 1Password desktop app
- Native messaging (required for 1Password) doesn't work across sandbox boundaries
- RPM installation provides system-level integration needed for password manager extensions

## Profile Management

### Current Setup
- **7 profiles** for different contexts (work, personal, development, etc.)
- Each profile syncs through Microsoft account sign-in

### What Syncs Automatically (via Microsoft Account)
✅ Extensions
✅ Bookmarks/Favorites
✅ Passwords (if enabled)
✅ Settings (most)
✅ History (if enabled)
✅ Open tabs (if enabled)

### What Requires Manual Configuration per Profile
❌ Theme selection (must set manually)
❌ Default search engine (sometimes)
❌ Downloads location
❌ Hardware acceleration settings
❌ Site permissions
❌ Startup behavior
❌ Some privacy settings

## Automated Configuration

### Apply Common Settings to All Profiles
Run the configuration script to set common preferences:

```bash
~/dotfiles/scripts/configure-edge-profiles.sh
```

This script will:
- Set dark theme as default (system_theme = 1)
- Configure downloads directory to ~/Downloads
- Enable hardware acceleration
- Set privacy settings
- Create desktop shortcuts for each profile (optional)

### What Can Be Automated
✅ Downloads directory
✅ Hardware acceleration settings
✅ Privacy sandbox settings
✅ Desktop shortcuts for profiles
✅ Some theme settings (limited)

### What Cannot Be Automated
❌ Microsoft account sign-in (requires interactive auth)
❌ Extension sync (requires account sign-in)
❌ Search engine preference (often overridden by sync)
❌ Site-specific permissions
❌ Saved passwords (requires account)
❌ Full theme selection (only basic dark/light/system)

## Post-Installation Steps

### 1. Sign in to Each Profile
```bash
# Launch Edge with profile selector
microsoft-edge --profile-directory="Default"

# Or create shortcuts for each profile
microsoft-edge --profile-directory="Profile 1" # Work
microsoft-edge --profile-directory="Profile 2" # Personal
# etc.
```

### 2. Manual Settings per Profile
After signing in to each profile:

1. **Theme**: 
   - Settings → Appearance → Theme → Dark/Light/System
   
2. **Downloads**:
   - Settings → Downloads → Location → Set to ~/Downloads or profile-specific folder

3. **1Password Extension**:
   - Should sync automatically, but verify it connects to desktop app
   - If not working: Extensions → 1Password → Details → Allow access to file URLs

4. **Startup Pages**:
   - Settings → On startup → Configure as needed

5. **Search Engine** (if needed):
   - Settings → Privacy, search, and services → Address bar and search

### 3. Create Profile Launcher Script (Optional)
```bash
#!/bin/bash
# Save as ~/bin/edge-profiles

echo "Select Edge Profile:"
echo "1) Default (Personal)"
echo "2) Work"
echo "3) Development"
echo "4) Testing"
echo "5) Client Projects"
echo "6) Research"
echo "7) Banking/Finance"

read -p "Enter choice [1-7]: " choice

case $choice in
    1) microsoft-edge --profile-directory="Default" ;;
    2) microsoft-edge --profile-directory="Profile 1" ;;
    3) microsoft-edge --profile-directory="Profile 2" ;;
    4) microsoft-edge --profile-directory="Profile 3" ;;
    5) microsoft-edge --profile-directory="Profile 4" ;;
    6) microsoft-edge --profile-directory="Profile 5" ;;
    7) microsoft-edge --profile-directory="Profile 6" ;;
    *) echo "Invalid choice" ;;
esac
```

## Profile Desktop Entries (Optional)
Create separate desktop shortcuts for frequently used profiles:

```bash
# Example: Work profile desktop entry
cat > ~/.local/share/applications/edge-work.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Name=Edge (Work)
Comment=Microsoft Edge - Work Profile
Exec=/usr/bin/microsoft-edge --profile-directory="Profile 1"
Terminal=false
Icon=microsoft-edge
Type=Application
Categories=Network;WebBrowser;
EOF
```

## Backup Profile Data
Edge profiles are stored in:
```
~/.config/microsoft-edge/
├── Default/          # Main profile
├── Profile 1/        # Additional profiles
├── Profile 2/
└── ...
```

Consider backing up profile preferences:
```bash
# Backup specific profile settings (not passwords/cookies)
cp ~/.config/microsoft-edge/"Profile 1"/Preferences ~/dotfiles/edge/work-preferences.json
```

## Known Issues & Solutions

### 1Password Extension Not Connecting
- Ensure Edge installed via RPM, not Flatpak
- Check 1Password desktop app is running
- In 1Password desktop: Settings → Browser → Verify Edge is listed
- May need to restart both Edge and 1Password after installation

### Profile Sync Issues
- Sign out and back in to Microsoft account
- Check sync settings: edge://settings/profiles/sync
- Some settings may take time to sync after initial sign-in

### Hardware Acceleration Issues
- If video playback issues: Settings → System → Use hardware acceleration
- May need to disable for some Linux graphics drivers

## Command-Line Flags
Useful Edge flags for Linux:
```bash
# Disable GPU sandbox (if graphics issues)
microsoft-edge --disable-gpu-sandbox

# Force dark mode for all websites
microsoft-edge --force-dark-mode

# Enable Wayland support (experimental)
microsoft-edge --ozone-platform=wayland
```

## References
- [Microsoft Edge for Linux](https://www.microsoft.com/en-us/edge/business/download)
- [1Password Browser Extension](https://support.1password.com/getting-started-browser/)
- [Edge Profiles Documentation](https://support.microsoft.com/en-us/microsoft-edge/sign-in-and-create-multiple-profiles-in-microsoft-edge-df94e622-2061-49ae-ad1d-6f0e43ce6435)
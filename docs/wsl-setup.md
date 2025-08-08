# Using Dotfiles in WSL2 Fedora

## Installation

### 1. Install Fedora in WSL2
```powershell
# In Windows PowerShell/Terminal
wsl --install -d Fedora
# Or for Fedora 39:
wsl --install -d Fedora-39
```

### 2. Clone and Setup Dotfiles
```bash
# In WSL2 Fedora
sudo dnf install -y git gh
gh auth login

# Clone dotfiles
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run modified install for WSL
./install-wsl.sh  # Create this script
```

## What Works in WSL2

### ✅ Fully Compatible
- **Package management**: DNF packages from `packages/dnf.txt`
- **Git configuration**: All git configs and aliases
- **Shell environment**: bashrc, aliases, environment variables
- **Development tools**:
  - Volta for Node.js management
  - Claude Code CLI
  - GitHub CLI (gh)
- **Terminal emulators**: Windows Terminal can use your Linux configs
- **File syncing**: OneDrive client works in WSL2!
- **Prompt**: Starship prompt works perfectly

### ⚠️ Needs Modification
- **System services**: Use Windows Task Scheduler or WSL2 boot commands
- **Desktop apps**: Skip GNOME-specific scripts
- **Clipboard**: Use Windows clipboard via `clip.exe` and `powershell.exe Get-Clipboard`

### ❌ Not Applicable
- GNOME extensions and settings
- Keyboard shortcut configurations  
- Display manager settings
- Full desktop environments (GNOME Shell itself)

### 🖥️ GUI Apps with WSLg

WSL2 includes WSLg (GUI support) on Windows 10 Build 19044+ and Windows 11!

#### Working GUI Apps from Dotfiles:
```bash
# These work great in WSLg:
sudo dnf install -y \
    alacritty \           # Terminal emulator (though Windows Terminal is better integrated)
    flameshot \           # Screenshot tool (captures WSL windows)
    gnome-text-editor \   # Text editor
    nautilus \            # File manager
    firefox \             # Browser (though Edge on Windows is faster)
    code                  # VS Code (better to use Windows version with WSL remote)

# Run them normally:
alacritty &
nautilus &
flameshot gui &
```

#### Edge Web Apps in WSLg:
```bash
# Your Edge web apps scripts would work!
# Edge for Linux runs in WSLg
sudo dnf install -y microsoft-edge-stable

# Then your web apps creation script works:
~/dotfiles/scripts/create-webapps.sh
```

#### Better Alternatives:
Instead of Linux GUI apps in WSL, consider:
- **Terminal**: Windows Terminal > Alacritty in WSLg
- **Browser**: Windows Edge > Linux Edge in WSLg  
- **VS Code**: Windows VS Code with WSL Remote > Linux VS Code
- **File Manager**: Windows Explorer (access with `explorer.exe .`)

#### When WSLg Makes Sense:
- Linux-only GUI development tools
- Testing Linux GUI applications
- Running GUI git tools (gitk, git-gui)
- Linux-specific IDEs or editors

## WSL-Specific Enhancements

### Windows Integration
```bash
# Add to ~/.bashrc for WSL
if grep -qi microsoft /proc/version; then
    # Running in WSL
    export IS_WSL=1
    
    # Windows paths
    export USERPROFILE="/mnt/c/Users/$USER"
    export DOWNLOADS="$USERPROFILE/Downloads"
    
    # Aliases for Windows programs
    alias explorer="explorer.exe"
    alias code="code.exe"
    alias edge="msedge.exe"
    
    # Copy/paste integration
    alias pbcopy="clip.exe"
    alias pbpaste="powershell.exe Get-Clipboard"
fi
```

### Shared Development Environment
```bash
# Work on Windows files from Linux
cd /mnt/c/Users/$USER/projects

# Or symlink for easier access
ln -s /mnt/c/Users/$USER/projects ~/win-projects
```

### OneDrive in WSL2
```bash
# Install OneDrive client (same as native Linux!)
sudo dnf install onedrive
onedrive --synchronize

# Mount Windows OneDrive if already synced
ln -s "/mnt/c/Users/$USER/OneDrive" ~/OneDrive-Windows
```

## Multi-Distro Strategy

### Share dotfiles between WSL distros
```bash
# In Debian WSL
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# In Fedora WSL  
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Both use the same configs!
```

### Cross-distro file access
```bash
# From Fedora, access Debian files
cd /mnt/wsl/instances/Debian/rootfs/home/username

# Or use \\wsl$ in Windows Explorer
```

## Recommended WSL2 Fedora Setup

1. **Core Development**
   ```bash
   # Install from dotfiles
   ./scripts/install-volta.sh
   ./scripts/install-claude-code.sh
   ./scripts/setup-prompt.sh  # Choose Starship
   ```

2. **Windows Terminal Profile**
   - Use Alacritty theme colors in Windows Terminal
   - Set Fedora as default profile
   - Use same fonts (FiraCode Nerd Font)

3. **VS Code Integration**
   ```bash
   # In WSL
   code .  # Opens in Windows VS Code with WSL remote
   ```

4. **Git Credentials**
   ```bash
   # Share credentials with Windows
   git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
   ```

## Benefits of Fedora WSL + Dotfiles

- **Consistency**: Same environment as your Linux machines
- **Portability**: Develop on Windows with Linux tools
- **Separation**: Keep Windows and Linux environments distinct
- **Testing**: Test scripts/configs before deploying to real Linux
- **Speed**: WSL2 is nearly native Linux performance

## Quick Commands

```bash
# Check if running in WSL
grep -qi microsoft /proc/version && echo "In WSL" || echo "Not in WSL"

# Open current directory in Windows Explorer
explorer.exe .

# Use Windows browser from WSL
sensible-browser() {
    if [[ -n "$IS_WSL" ]]; then
        msedge.exe "$@"
    else
        xdg-open "$@"
    fi
}
```
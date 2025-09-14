# macOS Adaptation Guide for Linux Dotfiles

This guide documents which components from the Linux (Fedora) dotfiles are relevant for macOS, what needs adaptation, and what should be skipped entirely.

## Overview

Your Linux dotfiles are designed for Fedora with GNOME. Many components can be adapted for macOS, while others are Linux-specific and should be skipped.

## ✅ Directly Applicable to macOS

These components work on macOS with little to no modification:

### 1. Git Configuration
- **What works**: All git aliases and settings
- **Location**: `git/.gitconfig` (if it exists) or create new
- **Installation**: Copy directly to `~/.gitconfig`
- **Status**: Ready to use

### 2. Alacritty Terminal
- **What works**: All configuration files and themes
- **Files**: 
  - `alacritty/alacritty.toml`
  - `alacritty/font.toml`
  - `alacritty/shared.toml`
  - `alacritty/themes/*.toml`
- **Installation**: 
  ```bash
  brew install --cask alacritty
  cp -r alacritty ~/.config/
  ```
- **Status**: Ready to use

### 3. Development Tools
- **Volta** (Node.js version manager)
  - Works identically on macOS
  - Install: `curl https://get.volta.sh | bash`
- **Claude Code CLI**
  - Cross-platform tool
  - Install via Volta: `volta install @anthropic-ai/claude-code`
- **GitHub CLI**
  - Already installed: `/opt/homebrew/bin/gh`

## ⚠️ Needs Adaptation for macOS

These components need modifications to work on macOS:

### 1. Shell Configuration (Priority: High)
- **Current**: Bash configuration for Linux
- **Target**: Adapt for Zsh (macOS default)
- **Key changes needed**:
  - Convert `.bashrc` → `.zshrc`
  - Update prompt functions for Zsh syntax
  - Modify path variables
  - Update system-specific aliases

**Portable elements**:
```bash
# Navigation aliases - work as-is
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Git aliases - work as-is
alias g='git'
alias gc='git commit'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias ga='git add'
alias gd='git diff'

# Utility functions - work with minor tweaks
extract() { ... }  # Works as-is
mkcd() { ... }     # Works as-is
backup() { ... }   # Works as-is
```

**Need modification**:
```bash
# Package management
alias update='brew update && brew upgrade'  # was: sudo dnf update
alias install='brew install'                # was: sudo dnf install
alias search='brew search'                  # was: dnf search

# Clipboard
alias pbcopy='pbcopy'   # was: wl-copy
alias pbpaste='pbpaste' # was: wl-paste

# System paths
export PATH="/opt/homebrew/bin:$PATH"  # Homebrew on Apple Silicon
```

### 2. Package Management (Priority: Medium)
- **Current**: DNF package lists
- **Target**: Homebrew Brewfile
- **Create**: `homebrew/Brewfile`
- **Benefits**: 
  - Version control for installed packages
  - Easy replication across machines
  - `brew bundle` to install everything

### 3. System Information Scripts (Priority: Low)
- **Current**: Linux-specific commands
- **Target**: macOS equivalents
- **Examples**:
  ```bash
  # Linux: cat /etc/fedora-release
  # macOS: sw_vers -productVersion
  
  # Linux: lscpu
  # macOS: sysctl -n machdep.cpu.brand_string
  
  # Linux: free -h
  # macOS: vm_stat
  ```

## ❌ Not Applicable to macOS

Skip these Linux-specific components entirely:

### 1. Desktop Environment
- All GNOME settings and extensions
- Dash to Panel configuration
- Workspace indicators
- Wayland-specific settings
- Linux keyboard shortcuts

### 2. Linux-Specific Package Managers
- Flatpak configurations
- DNF-specific scripts
- Snap packages

### 3. System Services
- systemd/systemctl commands
- OneDrive Linux client (use native macOS app)
- Linux-specific daemons

### 4. Linux-Specific Applications
- Flameshot (use macOS built-in screenshot tools)
- Edge browser profile scripts (different on macOS)
- Linux-specific paths and permissions

## 📋 Implementation Checklist

Work through these in order of priority:

### Phase 1: Essential Shell Setup
- [ ] Create `.zshrc` with adapted bash configurations
- [ ] Port git-aware prompt to Zsh (or use Starship/Oh My Zsh)
- [ ] Set up basic aliases (navigation, git)
- [ ] Configure PATH for Homebrew and tools

### Phase 2: Terminal Enhancement
- [ ] Install and configure Alacritty
- [ ] Set up preferred color theme
- [ ] Configure fonts (may need to install CaskaydiaCove Nerd Font)

### Phase 3: Development Environment
- [ ] Install Volta for Node.js management
- [ ] Install Claude Code CLI
- [ ] Set up development aliases and functions
- [ ] Configure git with your preferences

### Phase 4: Package Management
- [ ] Create Brewfile with essential packages
- [ ] Document installation process
- [ ] Set up update/upgrade aliases

### Phase 5: Advanced Customization
- [ ] Create macOS-specific utility scripts
- [ ] Set up cloud sync preferences
- [ ] Configure remaining productivity tools

## 🚀 Quick Start Commands

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install essential tools
brew install git gh
brew install --cask alacritty

# 3. Install Volta
curl https://get.volta.sh | bash

# 4. Install Claude Code
volta install @anthropic-ai/claude-code

# 5. Copy relevant configs
cp -r ~/dotfiles/alacritty ~/.config/
# Adapt other configs as needed
```

## 📝 Notes

- **Zsh vs Bash**: macOS uses Zsh by default since Catalina. While you can switch to Bash, it's recommended to adapt to Zsh for better macOS integration.
- **Homebrew paths**: On Apple Silicon Macs, Homebrew installs to `/opt/homebrew` instead of `/usr/local`
- **Configuration locations**: macOS follows Unix conventions, so most dotfiles go in `~` or `~/.config/`

## Next Steps

1. Start with Phase 1 (Essential Shell Setup)
2. Test each component before moving to the next
3. Keep both Linux and macOS dotfiles separate to avoid conflicts
4. Consider creating a `dotfiles-mac` repository for macOS-specific configurations
#!/bin/bash
# Fedora Dotfiles Installation Script
# Clone with: git clone https://github.com/YOUR_USERNAME/dotfiles.git
# Run with: ./install.sh

set -e  # Exit on error

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "======================================"
echo "     Fedora Dotfiles Installer"
echo "======================================"
echo ""
echo "This will set up your Fedora environment from scratch."
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# ============================================
# STEP 1: System Update & Base Packages
# ============================================
echo "[1/8] System update and base packages..."

# Check if RPM Fusion is already enabled
if ! dnf repolist | grep -q "rpmfusion-free"; then
    echo "Enabling RPM Fusion repositories..."
    sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
else
    echo "  ✓ RPM Fusion already enabled"
fi

read -p "Update system packages? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf update -y
fi

# ============================================
# STEP 1.5: First Run Setup (if needed)
# ============================================
if [ ! -f ~/.config/fedora-setup/preferences.conf ]; then
    echo ""
    echo "[1.5/8] First-time setup..."
    if [ -f "$DOTFILES_DIR/scripts/first-run.sh" ]; then
        bash "$DOTFILES_DIR/scripts/first-run.sh"
    fi
fi

# ============================================
# STEP 2: Install Software
# ============================================
echo ""
echo "[2/8] Installing software..."

# Install packages from list
if [ -f "$DOTFILES_DIR/packages/dnf.txt" ]; then
    echo "Installing DNF packages..."
    # Install packages one by one to handle missing packages gracefully
    while IFS= read -r package; do
        if [ ! -z "$package" ] && [ "${package:0:1}" != "#" ]; then
            echo "  Installing: $package"
            sudo dnf install -y "$package" 2>/dev/null || echo "  ⚠ Package not found: $package"
        fi
    done < "$DOTFILES_DIR/packages/dnf.txt"
fi

# Try optional packages
if [ -f "$DOTFILES_DIR/packages/optional.txt" ]; then
    echo ""
    echo "Attempting optional packages..."
    while IFS= read -r package; do
        if [ ! -z "$package" ] && [ "${package:0:1}" != "#" ]; then
            sudo dnf install -y "$package" 2>/dev/null || true
        fi
    done < "$DOTFILES_DIR/packages/optional.txt"
fi

# Install third-party apps
if [ -f "$DOTFILES_DIR/scripts/install-third-party.sh" ]; then
    echo "Installing third-party apps..."
    bash "$DOTFILES_DIR/scripts/install-third-party.sh"
fi

# Install Typora
if [ -f "$DOTFILES_DIR/scripts/install-typora.sh" ]; then
    echo "Installing Typora..."
    bash "$DOTFILES_DIR/scripts/install-typora.sh"
fi

# Configure Flameshot if installed
if command -v flameshot &> /dev/null; then
    if [ ! -f ~/.config/flameshot/flameshot.ini ]; then
        echo "Configuring Flameshot..."
        if [ -f "$DOTFILES_DIR/scripts/install-flameshot.sh" ]; then
            bash "$DOTFILES_DIR/scripts/install-flameshot.sh"
        fi
    else
        echo "  ✓ Flameshot already configured"
    fi
fi

# Install Flatpak applications (optional - skip if having issues)
if [ -f "$DOTFILES_DIR/packages/flatpak.txt" ]; then
    echo ""
    echo "Flatpak applications setup (optional)..."
    
    # Check if Typora is already installed via RPM
    if rpm -q typora &>/dev/null; then
        echo "  ✓ Typora already installed via RPM, skipping Flatpak setup"
    else
        read -p "Install Flatpak applications? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "  Skipping Flatpak applications"
        else
            echo "Installing Flatpak applications..."
    
    # Ensure Flatpak is installed
    if ! command -v flatpak &> /dev/null; then
        echo "  Installing Flatpak..."
        sudo dnf install -y flatpak
    fi
    
    # Set up XDG_DATA_DIRS for Flatpak (if not already set)
    if [[ ":$XDG_DATA_DIRS:" != *":/var/lib/flatpak/exports/share:"* ]]; then
        echo "  Setting up Flatpak environment variables..."
        export XDG_DATA_DIRS="${XDG_DATA_DIRS}:/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share"
        
        # Add to bashrc for persistence
        if ! grep -q "flatpak/exports/share" ~/.bashrc; then
            echo 'export XDG_DATA_DIRS="${XDG_DATA_DIRS}:/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share"' >> ~/.bashrc
        fi
    fi
    
    # Add Flathub repository at system level (requires sudo but you have NOPASSWD)
    echo "  Adding Flathub repository (system-wide)..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Update Flatpak
    echo "  Updating Flatpak metadata..."
    sudo flatpak update --appstream
    
    # Install each Flatpak app at system level
    while IFS= read -r line; do
        if [ ! -z "$line" ] && [ "${line:0:1}" != "#" ]; then
            remote=$(echo "$line" | awk '{print $1}')
            app_id=$(echo "$line" | awk '{print $2}')
            if [ ! -z "$app_id" ]; then
                # Check if already installed
                if flatpak list | grep -q "$app_id"; then
                    echo "  ✓ Already installed: $app_id"
                else
                    echo "  Installing: $app_id"
                    sudo flatpak install -y "$remote" "$app_id" || echo "  ⚠ Failed to install: $app_id"
                fi
            fi
        fi
    done < "$DOTFILES_DIR/packages/flatpak.txt"
    
    echo ""
    echo "  Note: You may need to log out and back in for Flatpak apps to appear in menus"
        fi  # End of REPLY check
    fi  # End of Typora check
fi  # End of flatpak.txt file check

# ============================================
# STEP 3: Create Symlinks
# ============================================
echo ""
echo "[3/8] Creating configuration symlinks..."

# OneDrive config
if [ -f "$DOTFILES_DIR/onedrive/sync_list" ]; then
    mkdir -p ~/.config/onedrive
    if [ ! -L ~/.config/onedrive/sync_list ]; then
        ln -sf "$DOTFILES_DIR/onedrive/sync_list" ~/.config/onedrive/sync_list
        echo "  ✓ OneDrive sync_list"
    else
        echo "  ✓ OneDrive sync_list (already linked)"
    fi
fi

# Bash config
if [ -f "$DOTFILES_DIR/bash/.bashrc" ]; then
    ln -sf "$DOTFILES_DIR/bash/.bashrc" ~/.bashrc
    echo "  ✓ .bashrc"
fi

# Bash aliases
if [ -f "$DOTFILES_DIR/bash/.bash_aliases" ]; then
    ln -sf "$DOTFILES_DIR/bash/.bash_aliases" ~/.bash_aliases
    echo "  ✓ .bash_aliases"
fi

# Git config
if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
    ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
    echo "  ✓ .gitconfig"
fi

# CLAUDE.md
if [ -f "$DOTFILES_DIR/CLAUDE.md" ]; then
    ln -sf "$DOTFILES_DIR/CLAUDE.md" ~/CLAUDE.md
    echo "  ✓ CLAUDE.md"
fi

# User commands
if [ -d "$DOTFILES_DIR/bin" ]; then
    mkdir -p ~/bin
    for cmd in "$DOTFILES_DIR/bin"/*; do
        if [ -f "$cmd" ]; then
            cmd_name=$(basename "$cmd")
            ln -sf "$cmd" ~/bin/"$cmd_name"
            chmod +x ~/bin/"$cmd_name"
            echo "  ✓ $cmd_name command"
        fi
    done
    
    # Add ~/bin to PATH if not already there
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        echo "  ✓ Added ~/bin to PATH"
    fi
fi

# ============================================
# STEP 4: GNOME Settings
# ============================================
echo ""
echo "[4/8] Applying GNOME settings..."

# Try essential settings first (these should always work)
if [ -f "$DOTFILES_DIR/gnome/essential-settings.ini" ]; then
    echo "  Applying essential settings..."
    dconf load / < "$DOTFILES_DIR/gnome/essential-settings.ini" 2>/dev/null && \
        echo "  ✓ Essential settings applied" || \
        echo "  ⚠ Some settings couldn't be applied"
fi

# Try full settings (may have system-specific keys)
if [ -f "$DOTFILES_DIR/gnome/settings.ini" ]; then
    echo "  Attempting full settings restore..."
    dconf load / < "$DOTFILES_DIR/gnome/settings.ini" 2>/dev/null || \
        echo "  ⚠ Some system-specific settings skipped (this is normal)"
fi

# ============================================
# STEP 5: GNOME Extensions
# ============================================
echo ""
echo "[5/8] GNOME Extensions..."
if [ -f "$DOTFILES_DIR/gnome/extensions.txt" ]; then
    # Check if extensions are already installed
    if gnome-extensions list | grep -q "dash-to-panel"; then
        echo "  ✓ Extensions already installed"
        # Try to configure them
        if [ -f "$DOTFILES_DIR/scripts/setup-extensions.sh" ]; then
            echo "  Applying extension settings..."
            bash "$DOTFILES_DIR/scripts/setup-extensions.sh"
        fi
    else
        echo "Extensions to install:"
        cat "$DOTFILES_DIR/gnome/extensions.txt"
        echo ""
        echo "After installing via Extension Manager, run:"
        echo "  ~/dotfiles/scripts/setup-extensions.sh"
        echo ""
        read -p "Press Enter to continue..."
    fi
fi

# ============================================
# STEP 5.5: Setup Clipboard Manager
# ============================================
echo ""
echo "[5.5/8] Setting up Clipboard Manager..."
# Check if clipboard-indicator extension is already installed
if gnome-extensions list 2>/dev/null | grep -q "clipboard-indicator@tudmotu.com"; then
    echo "  ✓ Clipboard manager already installed"
else
    read -p "Would you like to set up the Windows-style clipboard manager (Super+V)? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "$DOTFILES_DIR/scripts/setup-clipboard-manager.sh" ]; then
            bash "$DOTFILES_DIR/scripts/setup-clipboard-manager.sh"
        fi
    fi
fi

# ============================================
# STEP 6: OneDrive Setup
# ============================================
echo ""
echo "[6/8] OneDrive setup..."
if command -v onedrive &> /dev/null; then
    # Check if OneDrive is already authenticated
    if [ -f ~/.config/onedrive/refresh_token ]; then
        echo "  ✓ OneDrive already authenticated"
        # Check if service is running
        if systemctl --user is-active --quiet onedrive; then
            echo "  ✓ OneDrive service is running"
        else
            echo "  ⚠ OneDrive service not running. To enable:"
            echo "    systemctl --user enable --now onedrive"
        fi
    else
        echo "OneDrive needs authentication:"
        echo "  1. Run: onedrive"
        echo "  2. Authenticate with Microsoft"
        echo "  3. Run: onedrive --sync --resync"
        echo "  4. Enable service: systemctl --user enable --now onedrive"
        read -p "Press Enter to continue..."
    fi
else
    echo "  ⚠ OneDrive not installed"
fi

# ============================================
# STEP 6.5: Setup Alacritty (if installed)
# ============================================
if command -v alacritty &> /dev/null; then
    if [ ! -f ~/.config/alacritty/alacritty.toml ]; then
        echo ""
        echo "[6.5/8] Setting up Alacritty..."
        if [ -f "$DOTFILES_DIR/scripts/setup-alacritty.sh" ]; then
            bash "$DOTFILES_DIR/scripts/setup-alacritty.sh"
        fi
    else
        echo "  ✓ Alacritty already configured"
    fi
fi

# ============================================
# STEP 7: Create Helper Scripts
# ============================================
echo ""
echo "[7/8] Installing helper scripts..."
if [ -d "$DOTFILES_DIR/scripts" ]; then
    mkdir -p ~/bin
    for script in "$DOTFILES_DIR/scripts"/*.sh; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            ln -sf "$script" ~/bin/"$script_name"
            chmod +x ~/bin/"$script_name"
            echo "  ✓ $script_name"
        fi
    done
fi

# ============================================
# STEP 8: Final Steps
# ============================================
echo ""
echo "[8/8] Final setup..."

# Reload shell configuration
source ~/.bashrc 2>/dev/null || true

echo ""
echo "======================================"
echo "        Installation Complete!"
echo "======================================"
echo ""

# Show only uncompleted tasks
UNCOMPLETED_TASKS=()

# Check GNOME extensions
if ! gnome-extensions list | grep -q "dash-to-panel"; then
    UNCOMPLETED_TASKS+=("Install GNOME extensions via Extension Manager")
fi

# Check OneDrive auth
if command -v onedrive &> /dev/null && [ ! -f ~/.config/onedrive/refresh_token ]; then
    UNCOMPLETED_TASKS+=("Authenticate OneDrive: onedrive")
fi

# Check Claude Code
if ! command -v claude &> /dev/null; then
    UNCOMPLETED_TASKS+=("Install Claude Code: ~/dotfiles/scripts/install-claude-code.sh")
fi

# Check Volta
if ! command -v volta &> /dev/null; then
    UNCOMPLETED_TASKS+=("Install Volta: ~/dotfiles/scripts/install-volta.sh")
fi

if [ ${#UNCOMPLETED_TASKS[@]} -gt 0 ]; then
    echo "Remaining setup tasks:"
    for i in "${!UNCOMPLETED_TASKS[@]}"; do
        echo "  $((i+1)). ${UNCOMPLETED_TASKS[$i]}"
    done
    echo ""
else
    echo "✓ All setup tasks completed!"
    echo ""
fi

echo "Quick commands:"
echo "  • fedora-config - Configuration menu"
echo "  • cd ~/dotfiles && git pull - Update dotfiles"

if command -v flameshot &> /dev/null; then
    echo "  • Ctrl+Print Screen - Screenshot with Flameshot"
fi

echo ""
echo "Done!"
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
read -p "Update system packages? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf update -y
    
    # Enable RPM Fusion
    sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
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

# ============================================
# STEP 3: Create Symlinks
# ============================================
echo ""
echo "[3/8] Creating configuration symlinks..."

# OneDrive config
if [ -f "$DOTFILES_DIR/onedrive/sync_list" ]; then
    mkdir -p ~/.config/onedrive
    ln -sf "$DOTFILES_DIR/onedrive/sync_list" ~/.config/onedrive/sync_list
    echo "  ✓ OneDrive sync_list"
fi

# Bash config
if [ -f "$DOTFILES_DIR/bash/.bashrc" ]; then
    ln -sf "$DOTFILES_DIR/bash/.bashrc" ~/.bashrc
    echo "  ✓ .bashrc"
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
    echo "Extensions to install:"
    cat "$DOTFILES_DIR/gnome/extensions.txt"
    echo ""
    
    # Check if extensions are already installed
    if gnome-extensions list | grep -q "dash-to-panel"; then
        echo "  ✓ Some extensions already installed"
        # Try to configure them
        if [ -f "$DOTFILES_DIR/scripts/setup-extensions.sh" ]; then
            bash "$DOTFILES_DIR/scripts/setup-extensions.sh"
        fi
    else
        echo "After installing extensions via Extension Manager, run:"
        echo "  ~/dotfiles/scripts/setup-extensions.sh"
        echo ""
        read -p "Press Enter to continue..."
    fi
fi

# ============================================
# STEP 6: OneDrive Setup
# ============================================
echo ""
echo "[6/8] OneDrive setup..."
if command -v onedrive &> /dev/null; then
    echo "OneDrive is installed. To complete setup:"
    echo "  1. Run: onedrive"
    echo "  2. Authenticate with Microsoft"
    echo "  3. Run: onedrive --sync --resync"
    echo "  4. Enable service: systemctl --user enable --now onedrive"
    read -p "Press Enter to continue..."
else
    echo "OneDrive not installed. Skipping..."
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
echo "Next steps:"
echo "1. Restart GNOME Shell (Alt+F2, type 'r', Enter)"
echo "2. Install GNOME extensions via Extension Manager"
echo "3. Set up OneDrive authentication"
echo "4. Sign in to Microsoft Edge and 1Password"
echo ""
echo "To update dotfiles later:"
echo "  cd ~/dotfiles && git pull"
echo ""
echo "Done!"
#!/bin/bash

# Install Obsidian via Flatpak for Fedora
# This integrates well with dotfiles and provides sandboxing

set -euo pipefail

echo "Installing Obsidian via Flatpak..."

# Check if Flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak not found. Installing..."
    sudo dnf install -y flatpak
fi

# Add Flathub if not already added
if ! flatpak remote-list | grep -q flathub; then
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Obsidian
echo "Installing Obsidian..."
flatpak install -y flathub md.obsidian.Obsidian

# Create desktop file in user applications (for better dotfiles compatibility)
mkdir -p ~/.local/share/applications

# Check if desktop file already exists
if [ ! -f ~/.local/share/applications/obsidian.desktop ]; then
    cat > ~/.local/share/applications/obsidian.desktop << 'EOF'
[Desktop Entry]
Name=Obsidian
Comment=Knowledge base
Exec=flatpak run md.obsidian.Obsidian %U
Icon=md.obsidian.Obsidian
Type=Application
Categories=Office;
MimeType=x-scheme-handler/obsidian;
StartupWMClass=obsidian
EOF
fi

echo "Obsidian installed successfully!"
echo ""
echo "Notes:"
echo "- Disable 'Automatic Updates' in Obsidian settings (Flatpak handles updates)"
echo "- Your vaults will be accessible from ~/Documents or wherever you store them"
echo "- To enable Wayland support, use Flatseal and add --socket=wayland"

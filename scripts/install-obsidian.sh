#!/bin/bash

# Install Obsidian on ARM64 Fedora
# This script downloads and sets up Obsidian for ARM64 Linux systems

set -euo pipefail

echo "📝 Installing Obsidian for ARM64..."

# Create Applications directory if it doesn't exist
mkdir -p ~/Applications

# Check if Obsidian is already installed
if [ -f ~/Applications/squashfs-root/obsidian ]; then
    echo "✅ Obsidian is already installed"
    exit 0
fi

# Download latest Obsidian ARM64 AppImage
echo "Downloading Obsidian ARM64 AppImage..."
OBSIDIAN_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.9.10/Obsidian-1.9.10-arm64.AppImage"
wget -q --show-progress -O ~/Applications/Obsidian.AppImage "$OBSIDIAN_URL"

# Make it executable
chmod +x ~/Applications/Obsidian.AppImage

# Extract AppImage (to avoid FUSE issues)
echo "Extracting AppImage (bypassing FUSE requirement)..."
cd ~/Applications
./Obsidian.AppImage --appimage-extract > /dev/null 2>&1

# Create desktop entry
echo "Creating desktop entry..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/obsidian.desktop << 'EOF'
[Desktop Entry]
Name=Obsidian
Comment=Obsidian - A knowledge base that works on local Markdown files
Exec=/home/corey/Applications/squashfs-root/obsidian %U
Icon=obsidian
Terminal=false
Type=Application
Categories=Office;Productivity;
MimeType=x-scheme-handler/obsidian;
StartupWMClass=obsidian
EOF

# Replace /home/corey with actual home directory
sed -i "s|/home/corey|$HOME|g" ~/.local/share/applications/obsidian.desktop

# Copy icon
echo "Installing icon..."
mkdir -p ~/.local/share/icons
cp ~/Applications/squashfs-root/obsidian.png ~/.local/share/icons/obsidian.png

# Update desktop database
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true

# Clean up AppImage if extraction was successful
if [ -f ~/Applications/squashfs-root/obsidian ]; then
    rm -f ~/Applications/Obsidian.AppImage
    echo "✅ Obsidian installed successfully!"
    echo "   Launch from GNOME activities or run: ~/Applications/squashfs-root/obsidian"
else
    echo "❌ Installation failed - extraction unsuccessful"
    exit 1
fi
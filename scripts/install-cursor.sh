#!/bin/bash

# Install Cursor (VS Code AI fork) for Linux
# Supports both x64 and ARM64 architectures

set -e

echo "=== Installing Cursor IDE ==="

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    CURSOR_ARCH="x64"
    ARCH_DISPLAY="x64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    CURSOR_ARCH="arm64"
    ARCH_DISPLAY="ARM64"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

echo "Detected architecture: $ARCH ($ARCH_DISPLAY)"
echo

# Create directories
mkdir -p ~/Applications
mkdir -p ~/.local/share/applications

# Check if Cursor is already installed
if [ -f ~/Applications/cursor.AppImage ]; then
    echo "✅ Cursor appears to be already installed at ~/Applications/cursor.AppImage"
    read -p "Reinstall/update? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping installation."
        exit 0
    fi
fi

echo "📥 Manual Download Required"
echo "=============================="
echo
echo "The direct download URLs are currently not accessible."
echo "Please download Cursor manually:"
echo
echo "1. Open your browser and go to: https://www.cursor.com/downloads"
echo "2. Download the Linux AppImage for $ARCH_DISPLAY"
echo "3. Save it as: ~/Applications/cursor.AppImage"
echo
echo "Alternatively, you can try these URLs in your browser:"
echo "  • https://downloader.cursor.sh/linux/appImage/$CURSOR_ARCH"
echo "  • https://download.todesktop.com/230313mzl4w4u92/cursor-latest-linux-$CURSOR_ARCH.AppImage"
echo
read -p "Press Enter once you've downloaded the file to ~/Applications/cursor.AppImage..."

# Check if file exists
if [ ! -f ~/Applications/cursor.AppImage ]; then
    echo "❌ File not found at ~/Applications/cursor.AppImage"
    echo "Please download the file and run this script again."
    exit 1
fi

echo "✅ File found! Setting up Cursor..."

# Make it executable
chmod +x ~/Applications/cursor.AppImage

# Create desktop entry for AppImage
cat > ~/.local/share/applications/cursor.desktop << EOF
[Desktop Entry]
Name=Cursor
Comment=Cursor - The AI-first Code Editor
Exec=$HOME/Applications/cursor.AppImage --no-sandbox %F
Icon=$HOME/Applications/cursor.AppImage
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=Cursor
MimeType=text/plain;
EOF

# Create symlink in ~/bin for command line access
mkdir -p ~/bin
ln -sf ~/Applications/cursor.AppImage ~/bin/cursor

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    # Add to bashrc if not already there
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    fi
    echo
    echo "⚠️  Added ~/bin to PATH in ~/.bashrc"
    echo "   Run: source ~/.bashrc"
fi

# Test if libfuse2 is needed
echo
echo "Testing if Cursor can run..."
if ~/Applications/cursor.AppImage --version &>/dev/null; then
    echo "✅ Cursor is working!"
else
    echo "⚠️  Cursor may need libfuse2 to run"
    echo "   If you get a fuse error, install it with:"
    echo "   sudo dnf install fuse fuse-libs"
fi

echo
echo "=== Cursor Installation Complete ==="
echo
echo "✅ Cursor is set up!"
echo
echo "Launch Cursor:"
echo "  • From application menu (may need to log out/in)"
echo "  • From terminal: cursor"
echo "  • Direct: ~/Applications/cursor.AppImage"
echo
echo "Note: If you get a sandbox error, use: cursor --no-sandbox"
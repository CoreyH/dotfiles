#!/bin/bash

# Install 1Password on Fedora (x86_64 and ARM64)
# This script installs the native 1Password app with proper architecture detection

set -euo pipefail

echo "🔐 Installing 1Password..."

# Check if 1Password is already installed
if [ -f /opt/1Password/1password ]; then
    echo "✅ 1Password is already installed"
    echo "   To update, run: sudo dnf update 1password"
    exit 0
fi

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    DOWNLOAD_URL="https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz"
    echo "  Detected x86_64 architecture"
elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    DOWNLOAD_URL="https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz"
    echo "  Detected ARM64 architecture"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

# Create temp directory for download
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download 1Password
echo "  Downloading 1Password..."
wget -q --show-progress -O 1password-latest.tar.gz "$DOWNLOAD_URL"

# Extract
echo "  Extracting..."
tar -xf 1password-latest.tar.gz

# Find the extracted directory (handles version numbers)
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "1password-*" | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "❌ Failed to find extracted 1Password directory"
    exit 1
fi

# Install to /opt/1Password
echo "  Installing to /opt/1Password (requires sudo)..."
sudo mkdir -p /opt/1Password
sudo cp -r "$EXTRACTED_DIR"/* /opt/1Password/

# Run the installation script
echo "  Running post-installation setup..."
cd /opt/1Password
sudo ./after-install.sh

# Clean up
rm -rf "$TEMP_DIR"

echo "✅ 1Password installed successfully!"
echo ""
echo "   Desktop app: Launch from GNOME activities"
echo "   CLI: op (after installing with: sudo dnf install 1password-cli)"
echo "   Browser extension: Will be offered when you first launch 1Password"
echo ""
echo "   Note: 1Password will auto-update through the DNF repository"
#!/bin/bash

# Install Typora on Fedora using Flatpak
# Since RPM repository is no longer available, using Flatpak instead

echo "Installing Typora via Flatpak..."

# Ensure Flatpak is installed (should already be on Fedora)
if ! command -v flatpak &> /dev/null; then
    echo "Installing Flatpak..."
    sudo dnf install -y flatpak
fi

# Add Flathub repository if not already added
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Typora
flatpak install -y flathub io.typora.Typora

echo "Typora installation complete!"
echo "You can run Typora with: flatpak run io.typora.Typora"
echo "Or find it in your application menu"
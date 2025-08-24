#!/bin/bash
# Install third-party applications

# Detect system architecture
ARCH=$(uname -m)
IS_ARM64=false
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    IS_ARM64=true
fi

# Microsoft Edge (x86_64 only)
if ! command -v microsoft-edge &> /dev/null; then
    if [ "$IS_ARM64" = true ]; then
        echo "  ⚠ Skipping Microsoft Edge (not available for ARM64)"
        echo "    Consider using Firefox or Chromium instead"
    else
        echo "Installing Microsoft Edge..."
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[microsoft-edge]\nname=Microsoft Edge\nbaseurl=https://packages.microsoft.com/yumrepos/edge\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/microsoft-edge.repo'
        sudo dnf install -y microsoft-edge-stable || echo "  ⚠ Failed to install Microsoft Edge"
    fi
else
    echo "  ✓ Microsoft Edge already installed"
fi

# 1Password (x86_64 only)
if ! command -v 1password &> /dev/null; then
    if [ "$IS_ARM64" = true ]; then
        echo "  ⚠ Skipping 1Password (not available for ARM64 Linux)"
        echo "    Consider using the web version or Bitwarden"
    else
        echo "Installing 1Password..."
        sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
        sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
        sudo dnf install -y 1password || echo "  ⚠ Failed to install 1Password"
    fi
else
    echo "  ✓ 1Password already installed"
fi

# Return success even if some packages failed
exit 0
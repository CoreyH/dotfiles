#!/bin/bash
# Install third-party applications

# Microsoft Edge
if ! command -v microsoft-edge &> /dev/null; then
    echo "Installing Microsoft Edge..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[microsoft-edge]\nname=Microsoft Edge\nbaseurl=https://packages.microsoft.com/yumrepos/edge\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/microsoft-edge.repo'
    sudo dnf install -y microsoft-edge-stable
fi

# 1Password
if ! command -v 1password &> /dev/null; then
    echo "Installing 1Password..."
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install -y 1password
fi
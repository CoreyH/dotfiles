#!/bin/bash

# 1Password Setup for ARM64 Fedora
# Consolidated script for all 1Password configuration

set -e

show_menu() {
    echo "=== 1Password Setup for ARM64 Fedora ==="
    echo
    echo "1) Install 1Password CLI"
    echo "2) Configure 30-day sessions"
    echo "3) Setup auto-login with GNOME Keyring"
    echo "4) Show Chromium multi-profile tips"
    echo "5) Show easy sign-in methods"
    echo "6) Check current status"
    echo "0) Exit"
    echo
    read -p "Choose an option: " choice
}

install_cli() {
    echo "## Installing 1Password CLI"
    
    if command -v op &> /dev/null; then
        echo "✅ 1Password CLI is already installed"
        return
    fi
    
    echo "Installing 1Password CLI..."
    sudo dnf install -y 1password-cli
    echo "✅ 1Password CLI installed"
}

configure_sessions() {
    echo "## Configuring 30-day sessions"
    
    # Check if already configured
    if grep -q "OP_SESSION_DURATION=2592000" ~/.bashrc 2>/dev/null; then
        echo "✅ Already configured for 30-day sessions"
        return
    fi
    
    # Add to bashrc
    cat >> ~/.bashrc << 'EOF'

# 1Password CLI configuration
export OP_SESSION_DURATION=2592000  # 30 days (maximum)
export OP_BIOMETRIC_UNLOCK_ENABLED=false  # No Touch ID on Linux

# 1Password CLI helpers
op-login() {
    echo "Signing into 1Password CLI..."
    eval $(op signin)
    if [ $? -eq 0 ]; then
        echo "✅ Successfully signed in to 1Password"
        echo "Session will last 30 days"
    else
        echo "❌ Sign-in failed"
        return 1
    fi
}

op-get() {
    # Usage: op-get "item name"
    if [ -z "$1" ]; then
        echo "Usage: op-get 'item name'"
        return 1
    fi
    op item get "$1" --fields password
}

op-copy() {
    # Usage: op-copy "item name"
    if [ -z "$1" ]; then
        echo "Usage: op-copy 'item name'"
        return 1
    fi
    op item get "$1" --fields password | xclip -selection clipboard
    echo "Password copied to clipboard"
}

op-list() {
    op item list --format=json | jq -r '.[].title' | sort
}

op-session-check() {
    if op vault list &>/dev/null; then
        echo "✅ 1Password session is active"
        return 0
    else
        echo "❌ No active session. Run: op-login"
        return 1
    fi
}
EOF
    
    echo "✅ Added 1Password helpers to ~/.bashrc"
    echo "Run: source ~/.bashrc"
}

setup_auto_login() {
    echo "## Setting up auto-login with GNOME Keyring"
    echo "⚠️  This stores your credentials in GNOME Keyring"
    read -p "Continue? (y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    
    # Install secret-tool if needed
    if ! command -v secret-tool &> /dev/null; then
        sudo dnf install -y libsecret-tools
    fi
    
    read -p "Enter your 1Password account email: " email
    read -p "Enter your 1Password account address (e.g., my.1password.com): " address
    read -s -p "Enter your master password: " password
    echo
    read -s -p "Enter your secret key (A3-XXXXXX-...): " secret_key
    echo
    
    # Store in keyring
    echo "$password" | secret-tool store --label="1Password Master Password" service 1password-cli username "$email" type password
    echo "$secret_key" | secret-tool store --label="1Password Secret Key" service 1password-cli username "$email" type secret-key
    echo "$address" | secret-tool store --label="1Password Account" service 1password-cli username "$email" type account
    
    echo "✅ Credentials stored in GNOME Keyring"
}

show_chromium_tips() {
    echo "## Chromium Multi-Profile Tips"
    echo
    echo "For managing 1Password across multiple Chromium profiles:"
    echo
    echo "1. Use 1Password X extension (standalone, no desktop app needed)"
    echo "   Install from: https://chrome.google.com/webstore/detail/1password-x/aeblfdkhhhdcdjpifhhbdiojplfjncoa"
    echo
    echo "2. Configure each profile (one-time setup):"
    echo "   - Install extension"
    echo "   - Sign in with credentials"
    echo "   - Set Auto-lock to 'Never' or 'On browser restart'"
    echo "   - Enable 'Unlock with system authentication'"
    echo
    echo "3. Launch profiles with:"
    echo "   chromium --profile-directory='Profile 1'"
    echo "   chromium --profile-directory='Profile 2'"
    echo
    echo "4. Use CLI as backup:"
    echo "   op-copy 'item name'  # Quick password copy"
    echo
    echo "Note: Browser security prevents sharing auth between profiles"
}

show_signin_methods() {
    echo "## Easy Sign-in Methods"
    echo
    echo "1. After first device setup, no secret key needed:"
    echo "   op signin  # Just email and master password"
    echo
    echo "2. Using QR code from phone:"
    echo "   - On phone: Settings → Set Up Another Device → Command-line tool"
    echo "   - Run: op signin --setup-code"
    echo "   - Paste the setupcode://... URL"
    echo
    echo "3. Check your accounts:"
    echo "   op account list"
    echo
    
    if op account list &>/dev/null 2>&1; then
        echo
        echo "Your configured accounts:"
        op account list
    fi
}

check_status() {
    echo "## 1Password Status Check"
    echo
    
    # CLI installation
    if command -v op &> /dev/null; then
        echo "✅ 1Password CLI installed ($(op --version))"
    else
        echo "❌ 1Password CLI not installed"
    fi
    
    # Session configuration
    if grep -q "OP_SESSION_DURATION=2592000" ~/.bashrc 2>/dev/null; then
        echo "✅ 30-day sessions configured"
    else
        echo "❌ 30-day sessions not configured"
    fi
    
    # Account setup
    if op account list &>/dev/null 2>&1; then
        echo "✅ Account configured:"
        op account list
    else
        echo "❌ No accounts configured"
    fi
    
    # Active session
    if op vault list &>/dev/null 2>&1; then
        echo "✅ Active session"
    else
        echo "❌ No active session (run: op-login)"
    fi
}

# Main menu loop
while true; do
    show_menu
    case $choice in
        1) install_cli ;;
        2) configure_sessions ;;
        3) setup_auto_login ;;
        4) show_chromium_tips ;;
        5) show_signin_methods ;;
        6) check_status ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
    echo
    read -p "Press Enter to continue..."
    clear
done
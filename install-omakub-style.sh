#!/bin/bash
# Fedora Setup - Omakub-inspired installer

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ASCII Art Header
show_header() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ______        __                    _____      __            
   / ____/__  ___/ /____  _________ _  / ___/___  / /___  ______ 
  / /_  / _ \/ _  / __ \/ ___/ __ `/  \__ \/ _ \/ __/ / / / __ \
 / __/ /  __/ /_/ / /_/ / /  / /_/ /  ___/ /  __/ /_/ /_/ / /_/ /
/_/    \___/\__,_/\____/_/   \__,_/  /____/\___/\__/\__,_/ .___/ 
                                                         /_/      
EOF
    echo -e "${NC}"
    echo -e "${GREEN}Transform your Fedora into a productivity powerhouse!${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
}

# Progress indicator
progress() {
    echo -e "${YELLOW}▶ $1${NC}"
}

# Success indicator
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Error handler
error() {
    echo -e "${RED}✗ $1${NC}"
}

# Confirmation prompt
confirm() {
    read -p "$(echo -e ${CYAN}"$1 (y/n): "${NC})" -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Main installation
main() {
    show_header
    
    echo "This installer will:"
    echo "  • Install essential packages and development tools"
    echo "  • Configure GNOME with productivity enhancements"
    echo "  • Set up OneDrive selective sync"
    echo "  • Apply dark theme and modern aesthetics"
    echo "  • Install productivity apps (Edge, 1Password)"
    echo
    
    if ! confirm "Ready to begin?"; then
        echo "Installation cancelled."
        exit 0
    fi
    
    # Update system
    progress "Updating system packages..."
    sudo dnf update -y &>/dev/null && success "System updated"
    
    # Install packages
    progress "Installing essential packages..."
    source "$HOME/dotfiles/install.sh"
    
    # Configure GNOME
    progress "Applying GNOME settings..."
    if [ -f "$HOME/dotfiles/gnome/essential-settings.ini" ]; then
        dconf load / < "$HOME/dotfiles/gnome/essential-settings.ini" 2>/dev/null
        success "GNOME configured"
    fi
    
    # Set up command
    progress "Installing fedora-config command..."
    mkdir -p ~/bin
    ln -sf "$HOME/dotfiles/bin/fedora-config" ~/bin/fedora-config
    
    # Add to PATH if not already there
    if ! echo $PATH | grep -q "$HOME/bin"; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    fi
    success "fedora-config command installed"
    
    echo
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Installation Complete!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo "Next steps:"
    echo "  1. Run 'fedora-config' to access the configuration menu"
    echo "  2. Install GNOME extensions via Extension Manager"
    echo "  3. Sign in to Edge, 1Password, and OneDrive"
    echo
    echo -e "${CYAN}Type 'fedora-config' anytime to customize your setup!${NC}"
    echo
    
    if confirm "Log out now to apply all changes?"; then
        gnome-session-quit --logout --no-prompt
    fi
}

main "$@"
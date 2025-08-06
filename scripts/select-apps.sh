#!/bin/bash
# App selection script - Omakub-inspired

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Select applications to install:${NC}"
echo "(Enter numbers separated by spaces, e.g., 1 3 5)"
echo

# Development tools
echo -e "${YELLOW}Development Tools:${NC}"
echo "1) Visual Studio Code"
echo "2) Sublime Text"
echo "3) Docker & Docker Compose"
echo "4) Postman"
echo "5) DBeaver (Database GUI)"

# Productivity
echo
echo -e "${YELLOW}Productivity:${NC}"
echo "6) Obsidian (Note-taking)"
echo "7) Notion (Web app)"
echo "8) LibreOffice"
echo "9) Thunderbird (Email)"
echo "10) Bitwarden (Password manager)"

# Media
echo
echo -e "${YELLOW}Media & Communication:${NC}"
echo "11) Spotify"
echo "12) VLC Media Player"
echo "13) Discord"
echo "14) Slack"
echo "15) Zoom"

# Utilities
echo
echo -e "${YELLOW}Utilities:${NC}"
echo "16) Flameshot (Screenshots)"
echo "17) Pinta (Image editor)"
echo "18) Transmission (Torrents)"
echo "19) VirtualBox"
echo "20) Steam"

echo
read -p "Enter your choices: " -a CHOICES

# Process selections
for choice in "${CHOICES[@]}"; do
    case $choice in
        1)
            echo "Installing VS Code..."
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf install -y code
            ;;
        2)
            echo "Installing Sublime Text..."
            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            sudo dnf install -y sublime-text
            ;;
        3)
            echo "Installing Docker..."
            sudo dnf install -y docker docker-compose
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            ;;
        4)
            echo "Installing Postman..."
            flatpak install -y flathub com.getpostman.Postman
            ;;
        5)
            echo "Installing DBeaver..."
            flatpak install -y flathub io.dbeaver.DBeaverCommunity
            ;;
        6)
            echo "Installing Obsidian..."
            flatpak install -y flathub md.obsidian.Obsidian
            ;;
        7)
            echo "Opening Notion in browser..."
            xdg-open "https://notion.so"
            ;;
        8)
            echo "Installing LibreOffice..."
            sudo dnf install -y libreoffice
            ;;
        9)
            echo "Installing Thunderbird..."
            sudo dnf install -y thunderbird
            ;;
        10)
            echo "Installing Bitwarden..."
            flatpak install -y flathub com.bitwarden.desktop
            ;;
        11)
            echo "Installing Spotify..."
            flatpak install -y flathub com.spotify.Client
            ;;
        12)
            echo "Installing VLC..."
            sudo dnf install -y vlc
            ;;
        13)
            echo "Installing Discord..."
            flatpak install -y flathub com.discordapp.Discord
            ;;
        14)
            echo "Installing Slack..."
            flatpak install -y flathub com.slack.Slack
            ;;
        15)
            echo "Installing Zoom..."
            flatpak install -y flathub us.zoom.Zoom
            ;;
        16)
            echo "Installing Flameshot..."
            sudo dnf install -y flameshot
            ;;
        17)
            echo "Installing Pinta..."
            sudo dnf install -y pinta
            ;;
        18)
            echo "Installing Transmission..."
            sudo dnf install -y transmission-gtk
            ;;
        19)
            echo "Installing VirtualBox..."
            sudo dnf install -y VirtualBox
            ;;
        20)
            echo "Installing Steam..."
            sudo dnf install -y steam
            ;;
        *)
            echo "Unknown selection: $choice"
            ;;
    esac
done

echo
echo -e "${GREEN}✓ App installation complete!${NC}"
echo "Some apps may require logout/login to appear in the menu."
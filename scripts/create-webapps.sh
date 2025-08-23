#!/bin/bash

# Web Apps Creation Script
# Creates Chromium-based web apps similar to webapp-manager
# Works on both x86_64 (Edge) and ARM64 (Chromium)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Web app definitions
declare -A WEBAPPS=(
    ["ChatGPT"]="https://chatgpt.com/"
    ["GitHub"]="https://github.com/"
    ["WhatsApp"]="https://web.whatsapp.com/"
    ["YouTube"]="https://youtube.com/"
    ["X"]="https://x.com/"
    ["Google Messages"]="https://messages.google.com/"
    ["Google Photos"]="https://photos.google.com/"
    ["Google Contacts"]="https://contacts.google.com/"
    ["Todoist"]="https://todoist.com/"
    ["Slack"]="https://app.slack.com/"
)

# Icon URLs (optional - will try to download if not exists)
declare -A ICON_URLS=(
    ["ChatGPT"]="https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg"
    ["GitHub"]="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
    ["WhatsApp"]="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg"
    ["YouTube"]="https://upload.wikimedia.org/wikipedia/commons/4/42/YouTube_icon_%282013-2017%29.png"
    ["X"]="https://upload.wikimedia.org/wikipedia/commons/c/ce/X_logo_2023.svg"
    ["Google Messages"]="https://upload.wikimedia.org/wikipedia/commons/d/d7/Google_Messages_logo.svg"
    ["Google Photos"]="https://upload.wikimedia.org/wikipedia/commons/3/3c/Google_Photos_icon_%282020%29.svg"
    ["Google Contacts"]="https://upload.wikimedia.org/wikipedia/commons/9/93/Google_Contacts_icon.svg"
    ["Todoist"]="https://upload.wikimedia.org/wikipedia/en/8/8c/Todoist_2015_logo.png"
    ["Slack"]="https://a.slack-edge.com/80588/marketing/img/meta/slack_hash_256.png"
)

echo -e "${BLUE}Web Apps Creation Script${NC}"

# Detect which browser to use
if command -v microsoft-edge &> /dev/null; then
    BROWSER_CMD="microsoft-edge"
    BROWSER_NAME="Edge"
    DATA_DIR="$HOME/.config/microsoft-edge-webapps"
elif flatpak list | grep -q org.chromium.Chromium; then
    BROWSER_CMD="flatpak run org.chromium.Chromium"
    BROWSER_NAME="Chromium"
    DATA_DIR="$HOME/.config/chromium-webapps"
else
    echo -e "${RED}Neither Edge nor Chromium found!${NC}"
    echo "Please install Chromium: flatpak install flathub org.chromium.Chromium"
    exit 1
fi

echo -e "${YELLOW}Creating $BROWSER_NAME-based progressive web apps${NC}"
echo

# Create directories
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$APPS_DIR/icons"

mkdir -p "$APPS_DIR"
mkdir -p "$ICONS_DIR"
mkdir -p "$DATA_DIR"

# Function to download icon
download_icon() {
    local name="$1"
    local url="$2"
    local icon_file="$ICONS_DIR/$name.png"
    
    if [ ! -f "$icon_file" ]; then
        if [ ! -z "$url" ]; then
            echo "  Downloading icon for $name..."
            # Try to download and convert to PNG if needed
            if [[ "$url" == *.svg ]]; then
                # Download SVG and convert to PNG
                local temp_svg="/tmp/${name}.svg"
                if curl -sL "$url" -o "$temp_svg" 2>/dev/null; then
                    # Convert SVG to PNG using ImageMagick (256x256 for high quality)
                    if command -v convert &> /dev/null; then
                        convert -background none -resize 256x256 "$temp_svg" "$icon_file" 2>/dev/null && {
                            echo "    ✓ Downloaded and converted SVG icon"
                            rm -f "$temp_svg"
                            return 0
                        } || {
                            echo "    Failed to convert SVG to PNG"
                            rm -f "$temp_svg"
                            return 1
                        }
                    else
                        echo "    ImageMagick not installed, cannot convert SVG"
                        rm -f "$temp_svg"
                        return 1
                    fi
                else
                    echo "    Failed to download SVG icon"
                    return 1
                fi
            else
                curl -sL "$url" -o "$icon_file" 2>/dev/null || {
                    echo "    Failed to download icon"
                    return 1
                }
                echo "    ✓ Downloaded icon"
            fi
        fi
    else
        echo "  Icon already exists: $icon_file"
    fi
    return 0
}

# Function to create web app
create_webapp() {
    local name="$1"
    local url="$2"
    local desktop_file="$APPS_DIR/$name.desktop"
    local icon_file="$ICONS_DIR/$name.png"
    local class_name="${name// /}"  # Remove spaces for class name
    
    echo -e "${GREEN}Creating web app: $name${NC}"
    
    # Download icon if URL provided and icon doesn't exist
    if [ ! -f "$icon_file" ]; then
        if [ "${ICON_URLS[$name]}" ]; then
            download_icon "$name" "${ICON_URLS[$name]}"
        fi
    fi
    
    # Create desktop entry
    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Name=$name
Comment=$name Web App
Exec=$BROWSER_CMD --app="$url" --class="$class_name" --user-data-dir="$DATA_DIR/$class_name"
Terminal=false
Type=Application
Icon=$icon_file
StartupNotify=true
StartupWMClass=$class_name
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;
X-GNOME-Autostart-enabled=true
X-GNOME-SingleWindow=true
EOF
    
    chmod +x "$desktop_file"
    echo "  ✓ Created $name.desktop"
}

# Main menu
echo -e "${GREEN}Available web apps to create:${NC}"
echo
echo "  1) All apps (recommended)"
echo "  2) Select individual apps"
echo "  3) Add custom app"
echo "  0) Exit"
echo
read -p "Enter your choice: " choice

case $choice in
    1)
        echo
        echo "Creating all web apps..."
        for app_name in "${!WEBAPPS[@]}"; do
            create_webapp "$app_name" "${WEBAPPS[$app_name]}"
        done
        ;;
    2)
        echo
        echo "Select apps to install:"
        select app_name in "${!WEBAPPS[@]}" "Done"; do
            if [ "$app_name" = "Done" ]; then
                break
            elif [ "$app_name" ]; then
                create_webapp "$app_name" "${WEBAPPS[$app_name]}"
            fi
        done
        ;;
    3)
        echo
        read -p "Enter app name: " custom_name
        read -p "Enter app URL: " custom_url
        if [ "$custom_name" ] && [ "$custom_url" ]; then
            create_webapp "$custom_name" "$custom_url"
        else
            echo -e "${RED}Name and URL are required${NC}"
        fi
        ;;
    0)
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Update desktop database
echo
echo "Updating desktop database..."
update-desktop-database "$APPS_DIR" 2>/dev/null || true

echo
echo -e "${GREEN}✓ Web apps created successfully!${NC}"
echo
echo "To use the web apps:"
echo "  1. Press Super key and search for the app name"
echo "  2. Pin frequently used apps to dash/dock"
echo "  3. Each app runs in its own profile with separate cookies/storage"
echo
echo -e "${YELLOW}Note:${NC} Icons may need to be added manually for some apps"
echo "      Place PNG icons in: $ICONS_DIR/"
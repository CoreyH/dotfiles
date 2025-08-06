#!/bin/bash

# Edge Profile Configuration Script
# Applies common settings to all Edge profiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

EDGE_CONFIG_DIR="$HOME/.config/microsoft-edge"

echo -e "${BLUE}Microsoft Edge Profile Configuration${NC}"
echo -e "${YELLOW}This script will apply common settings to your Edge profiles${NC}"
echo

# Check if Edge config exists
if [ ! -d "$EDGE_CONFIG_DIR" ]; then
    echo -e "${RED}Edge configuration directory not found${NC}"
    echo "Please run Edge at least once before running this script"
    exit 1
fi

# Find all profiles
PROFILES=$(ls -d "$EDGE_CONFIG_DIR"/Profile* "$EDGE_CONFIG_DIR/Default" 2>/dev/null || true)

if [ -z "$PROFILES" ]; then
    echo -e "${RED}No Edge profiles found${NC}"
    exit 1
fi

echo -e "${GREEN}Found profiles:${NC}"
for profile in $PROFILES; do
    profile_name=$(basename "$profile")
    echo "  - $profile_name"
done
echo

# Function to update preferences JSON
update_preferences() {
    local profile_dir=$1
    local pref_file="$profile_dir/Preferences"
    
    if [ ! -f "$pref_file" ]; then
        echo "  ${YELLOW}⚠${NC} Preferences file not found, skipping"
        return
    fi
    
    # Create backup
    cp "$pref_file" "$pref_file.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Apply settings using Python (safer JSON manipulation)
    python3 << EOF
import json
import sys

try:
    with open('$pref_file', 'r') as f:
        prefs = json.load(f)
    
    # Theme settings (0=default, 1=dark, 2=light, 3=system)
    if 'extensions' not in prefs:
        prefs['extensions'] = {}
    if 'theme' not in prefs['extensions']:
        prefs['extensions']['theme'] = {}
    
    # Set to dark theme by default
    prefs['extensions']['theme']['system_theme'] = 1  # 1=dark, change to 3 for system
    
    # Downloads location
    if 'download' not in prefs:
        prefs['download'] = {}
    prefs['download']['default_directory'] = '$HOME/Downloads'
    prefs['download']['prompt_for_download'] = False
    
    # Hardware acceleration (usually better on Linux)
    if 'hardware_acceleration_mode' not in prefs:
        prefs['hardware_acceleration_mode'] = {}
    prefs['hardware_acceleration_mode']['enabled'] = True
    
    # Startup behavior
    if 'session' not in prefs:
        prefs['session'] = {}
    if 'startup_urls' not in prefs['session']:
        prefs['session']['startup_urls'] = []
    
    # Privacy settings
    if 'privacy_sandbox' not in prefs:
        prefs['privacy_sandbox'] = {}
    prefs['privacy_sandbox']['topics_consent_given'] = False
    prefs['privacy_sandbox']['fledge_consent_given'] = False
    
    # Write back
    with open('$pref_file', 'w') as f:
        json.dump(prefs, f, indent=2)
    
    print("  ✓ Preferences updated successfully")
    
except Exception as e:
    print(f"  ✗ Error updating preferences: {e}")
    sys.exit(1)
EOF
}

# Function to create desktop shortcuts for profiles
create_desktop_shortcuts() {
    echo
    echo -e "${BLUE}Creating desktop shortcuts for profiles...${NC}"
    
    local desktop_dir="$HOME/.local/share/applications"
    mkdir -p "$desktop_dir"
    
    # Profile names mapping (customize these)
    declare -A profile_names=(
        ["Default"]="Personal"
        ["Profile 1"]="Work"
        ["Profile 2"]="Development"
        ["Profile 3"]="Testing"
        ["Profile 4"]="Client Projects"
        ["Profile 5"]="Research"
        ["Profile 6"]="Banking"
    )
    
    for profile_dir in $PROFILES; do
        profile=$(basename "$profile_dir")
        
        # Get friendly name or use profile name
        if [ "${profile_names[$profile]}" ]; then
            friendly_name="${profile_names[$profile]}"
        else
            friendly_name="$profile"
        fi
        
        # Create desktop entry
        desktop_file="$desktop_dir/edge-${friendly_name,,}.desktop"
        
        cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Name=Edge ($friendly_name)
Comment=Microsoft Edge - $friendly_name Profile
Exec=/usr/bin/microsoft-edge --profile-directory="$profile" %U
Terminal=false
Icon=microsoft-edge
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=microsoft-edge
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
EOF
        
        chmod +x "$desktop_file"
        echo -e "  ${GREEN}✓${NC} Created shortcut for $friendly_name profile"
    done
    
    # Update desktop database
    update-desktop-database "$desktop_dir" 2>/dev/null || true
}

# Main execution
echo -e "${BLUE}Applying settings to profiles...${NC}"

for profile_dir in $PROFILES; do
    profile_name=$(basename "$profile_dir")
    echo -e "${GREEN}Processing $profile_name...${NC}"
    update_preferences "$profile_dir"
done

# Ask about desktop shortcuts
echo
read -p "Create desktop shortcuts for each profile? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    create_desktop_shortcuts
fi

echo
echo -e "${GREEN}Configuration complete!${NC}"
echo
echo -e "${YELLOW}Note: Some settings only take effect after restarting Edge${NC}"
echo -e "${YELLOW}Theme and other settings still need Microsoft account sync${NC}"
echo
echo "Manual steps still required per profile:"
echo "  1. Sign in with Microsoft account"
echo "  2. Verify 1Password extension connection"
echo "  3. Configure search engine if needed"
echo "  4. Set any profile-specific preferences"
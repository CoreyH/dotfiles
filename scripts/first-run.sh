#!/bin/bash
# First-run setup script - Omakub-inspired

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# ASCII Art Welcome
clear
echo -e "${CYAN}"
cat << "EOF"
    ___       __   __                          __ 
   | o |     /  \ |  \  _.  _  _   _  | _ |_  |  |
   |___|elcome \ / |__/ (_| (_ |< |_) (_| |_ |< |__|
                                    |              

         Your Fedora is about to get awesome!
EOF
echo -e "${NC}"
echo

# Get user information
echo -e "${GREEN}Let's personalize your setup!${NC}"
echo

# Name for git
read -p "Your name (for Git commits): " GIT_NAME
read -p "Your email (for Git): " GIT_EMAIL

# Configure git
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo -e "${GREEN}✓ Git configured${NC}"

# Development language preferences
echo
echo -e "${PURPLE}Select your primary development languages:${NC}"
echo "(Space to select, Enter when done)"
echo

LANGUAGES=("JavaScript/Node.js" "Python" "Go" "Rust" "Ruby" "PHP" "Java" "C/C++" ".NET/C#")
SELECTED_LANGS=()

select_languages() {
    PS3="Enter numbers separated by spaces: "
    select lang in "${LANGUAGES[@]}" "Done"; do
        case $lang in
            "Done")
                break
                ;;
            *)
                if [[ -n $lang ]]; then
                    SELECTED_LANGS+=("$lang")
                    echo "Added: $lang"
                fi
                ;;
        esac
    done
}

select_languages

# Install language-specific tools
for lang in "${SELECTED_LANGS[@]}"; do
    case $lang in
        "JavaScript/Node.js")
            echo "Installing Node.js..."
            sudo dnf install -y nodejs npm 2>/dev/null || true
            ;;
        "Python")
            echo "Installing Python tools..."
            sudo dnf install -y python3-pip python3-virtualenv 2>/dev/null || true
            ;;
        "Go")
            echo "Installing Go..."
            sudo dnf install -y golang 2>/dev/null || true
            ;;
        "Rust")
            echo "Installing Rust..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>/dev/null || true
            ;;
        "Ruby")
            echo "Installing Ruby..."
            sudo dnf install -y ruby ruby-devel 2>/dev/null || true
            ;;
        *)
            echo "Language $lang noted for future setup"
            ;;
    esac
done

# Theme preference
echo
echo -e "${PURPLE}Select your preferred theme:${NC}"
echo "1) Dark mode (recommended)"
echo "2) Light mode"
echo "3) Auto (follow time of day)"
read -p "Choice (1-3): " THEME_CHOICE

case $THEME_CHOICE in
    1) dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'" ;;
    2) dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'" ;;
    3) dconf write /org/gnome/desktop/interface/color-scheme "'default'" ;;
esac

# Terminal preference
echo
echo -e "${PURPLE}Select your terminal emulator:${NC}"
echo "1) GNOME Terminal (default)"
echo "2) Alacritty (fast, GPU-accelerated)"
echo "3) Kitty (feature-rich)"
read -p "Choice (1-3): " TERM_CHOICE

case $TERM_CHOICE in
    2)
        echo "Installing Alacritty..."
        sudo dnf install -y alacritty 2>/dev/null || true
        ;;
    3)
        echo "Installing Kitty..."
        sudo dnf install -y kitty 2>/dev/null || true
        ;;
esac

# Save preferences
mkdir -p ~/.config/fedora-setup
cat > ~/.config/fedora-setup/preferences.conf << EOF
# Fedora Setup Preferences
GIT_NAME="$GIT_NAME"
GIT_EMAIL="$GIT_EMAIL"
LANGUAGES="${SELECTED_LANGS[*]}"
THEME="$THEME_CHOICE"
TERMINAL="$TERM_CHOICE"
SETUP_DATE="$(date)"
EOF

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}First-run setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo "Your preferences have been saved."
echo "Run 'fedora-config' anytime to adjust settings."
echo
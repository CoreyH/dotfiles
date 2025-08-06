#!/bin/bash
# Setup Alacritty terminal configuration

set -e

DOTFILES_DIR="$HOME/dotfiles"
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Setting up Alacritty terminal...${NC}"

# Create config directory
mkdir -p "$ALACRITTY_CONFIG_DIR/themes"

# Link main config
ln -sf "$DOTFILES_DIR/alacritty/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"
echo -e "${GREEN}✓ Main config linked${NC}"

# Link font config
ln -sf "$DOTFILES_DIR/alacritty/font.toml" "$ALACRITTY_CONFIG_DIR/font.toml"
echo -e "${GREEN}✓ Font config linked${NC}"

# Link shared config
ln -sf "$DOTFILES_DIR/alacritty/shared.toml" "$ALACRITTY_CONFIG_DIR/shared.toml"
echo -e "${GREEN}✓ Shared config linked${NC}"

# Link all theme files
for theme in "$DOTFILES_DIR/alacritty/themes"/*.toml; do
    if [ -f "$theme" ]; then
        theme_name=$(basename "$theme")
        ln -sf "$theme" "$ALACRITTY_CONFIG_DIR/themes/$theme_name"
        echo -e "${GREEN}✓ Theme '$theme_name' linked${NC}"
    fi
done

# Set default theme (Tokyo Night)
ln -sf "$ALACRITTY_CONFIG_DIR/themes/tokyo-night.toml" "$ALACRITTY_CONFIG_DIR/theme.toml"
echo -e "${GREEN}✓ Default theme set to Tokyo Night${NC}"

# Install fonts if not present
if ! fc-list | grep -q "CaskaydiaCove"; then
    echo -e "${YELLOW}Installing Nerd Fonts...${NC}"
    
    # Create fonts directory
    mkdir -p ~/.local/share/fonts
    
    # Download CaskaydiaCove Nerd Font
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -O /tmp/CascadiaCode.zip
    unzip -q /tmp/CascadiaCode.zip -d ~/.local/share/fonts/
    rm /tmp/CascadiaCode.zip
    
    # Update font cache
    fc-cache -fv ~/.local/share/fonts/
    echo -e "${GREEN}✓ Nerd Fonts installed${NC}"
fi

echo
echo -e "${GREEN}Alacritty setup complete!${NC}"
echo
echo "Available themes:"
echo "  - tokyo-night (default)"
echo "  - catppuccin-mocha"
echo "  - dracula"
echo
echo "To change theme, run:"
echo "  ln -sf ~/.config/alacritty/themes/THEME_NAME.toml ~/.config/alacritty/theme.toml"
echo
echo "Or use 'fedora-config' to change themes interactively!"
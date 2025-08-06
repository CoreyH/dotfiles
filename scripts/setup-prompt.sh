#!/bin/bash
# Setup prompt - choose between custom bash or Starship

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Choose your prompt style:${NC}"
echo
echo "1) Custom Bash Prompt (posh-git style)"
echo "   - Git branch and status"
echo "   - Dirty file count"
echo "   - Ahead/behind indicators"
echo "   - Virtual env support"
echo
echo "2) Starship Prompt (modern, fast)"
echo "   - Beautiful icons and colors"
echo "   - Git status with details"
echo "   - Language version detection"
echo "   - Highly customizable"
echo
read -p "Your choice (1 or 2): " choice

case $choice in
    1)
        echo -e "${GREEN}Using custom Bash prompt${NC}"
        # Already configured in .bashrc
        ;;
    2)
        echo -e "${YELLOW}Installing Starship...${NC}"
        
        # Install Starship
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        
        # Create Starship config
        mkdir -p ~/.config
        cat > ~/.config/starship.toml << 'EOF'
# Starship configuration - posh-git inspired

format = """
$status\
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$git_state\
$python\
$nodejs\
$rust\
$golang\
$docker_context\
$line_break\
$character"""

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[status]
disabled = false
format = "[$symbol]($style) "
symbol = "✗"
success_symbol = "✓"

[username]
style_user = "green bold"
style_root = "red bold"
format = "[$user]($style)"
show_always = true

[hostname]
format = "[@$hostname]($style):"
style = "green"

[directory]
style = "blue bold"
truncation_length = 3
truncate_to_repo = true
format = "[$path]($style)"

[git_branch]
symbol = ""
style = "cyan"
format = " \\[[$symbol$branch]($style)"

[git_status]
format = "( [+$added]($style))( [-$deleted]($style))( [!$modified]($style))( [?$untracked]($style))( [↑$ahead_behind](green))\\]"
style = "yellow"
conflicted = "="
ahead = "↑${count}"
behind = "↓${count}"
diverged = "↑${ahead_count}↓${behind_count}"
untracked = "?"
modified = "!"
staged = "+"
deleted = "-"

[python]
symbol = "🐍 "
format = " [$symbol$version]($style)"

[nodejs]
symbol = "⬢ "
format = " [$symbol$version]($style)"

[rust]
symbol = "🦀 "
format = " [$symbol$version]($style)"

[golang]
symbol = "🐹 "
format = " [$symbol$version]($style)"

[docker_context]
symbol = "🐳 "
format = " [$symbol$context]($style)"
EOF
        
        # Add Starship to bashrc
        if ! grep -q "starship init bash" ~/.bashrc; then
            echo "" >> ~/.bashrc
            echo "# Starship prompt" >> ~/.bashrc
            echo 'eval "$(starship init bash)"' >> ~/.bashrc
        fi
        
        echo -e "${GREEN}✓ Starship installed!${NC}"
        echo "Restart your terminal or run: source ~/.bashrc"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo
echo -e "${GREEN}Prompt setup complete!${NC}"
echo
echo "To switch prompts later:"
echo "  - Edit ~/.bashrc and comment/uncomment the prompt section"
echo "  - Or run this script again"
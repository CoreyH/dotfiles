# Fedora Bash Aliases - Omakub-inspired

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Better defaults
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# Shortcuts
alias g='git'
alias gc='git commit'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias ga='git add'
alias gd='git diff'

# System
alias update='sudo dnf update -y && flatpak update -y'
alias install='sudo dnf install'
alias search='dnf search'
alias cleanup='sudo dnf autoremove -y && sudo dnf clean all'

# Productivity
alias config='fedora-config'
alias dots='cd ~/dotfiles'
alias reload='source ~/.bashrc'
alias edit='${EDITOR:-nano}'

# OneDrive
alias odsync='onedrive --sync'
alias odstatus='systemctl --user status onedrive'
alias odstart='systemctl --user start onedrive'
alias odstop='systemctl --user stop onedrive'

# Development
alias serve='python3 -m http.server'
alias ports='netstat -tulanp'
alias myip='curl -s https://api.ipify.org && echo'

# Clipboard (works with Wayland)
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'

# Quick edits
alias bashrc='${EDITOR:-nano} ~/.bashrc && source ~/.bashrc'
alias aliases='${EDITOR:-nano} ~/dotfiles/bash/.bash_aliases && source ~/.bashrc'

# Fun
alias weather='curl wttr.in'
alias moon='curl wttr.in/Moon'

# Functions
# Extract any archive
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# System info
sysinfo() {
    echo -e "\n${CYAN}System Information${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}OS:${NC} $(cat /etc/fedora-release)"
    echo -e "${GREEN}Kernel:${NC} $(uname -r)"
    echo -e "${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo -e "${GREEN}Memory:${NC} $(free -h | awk '/^Mem:/ {print $3 " / " $2}')"
    echo -e "${GREEN}Disk:${NC} $(df -h / | awk 'NR==2 {print $3 " / " $2}')"
    echo -e "${GREEN}Uptime:${NC} $(uptime -p)"
}

# Colors for prompt (if not already set)
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
# GitHub Desktop
alias github-desktop='flatpak run io.github.shiftey.Desktop'

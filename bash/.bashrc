#!/bin/bash
# Fedora Bash Configuration with Git-aware prompt

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
export BROWSER="/home/corey/edge-last-active.sh"

# Quick Edge profile switching aliases
alias edge1='~/set-edge-profile.sh 1'
alias edge2='~/set-edge-profile.sh 2'
alias edge3='~/set-edge-profile.sh 3'
alias edge4='~/set-edge-profile.sh 4'
alias edge5='~/set-edge-profile.sh 5'
alias edge6='~/set-edge-profile.sh 6'
alias edge7='~/set-edge-profile.sh 7'
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# History settings
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Better tab completion
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"

# Colors
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[0;37m\]'
RESET='\[\033[0m\]'
BOLD='\[\033[1m\]'

# Git prompt functions (posh-git style)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_dirty() {
    git status --porcelain 2> /dev/null | wc -l
}

parse_git_ahead() {
    git status -sb 2> /dev/null | grep -o "ahead [0-9]*" | grep -o "[0-9]*"
}

parse_git_behind() {
    git status -sb 2> /dev/null | grep -o "behind [0-9]*" | grep -o "[0-9]*"
}

git_prompt_info() {
    local branch=$(parse_git_branch)
    if [ -n "$branch" ]; then
        local dirty=$(parse_git_dirty)
        local ahead=$(parse_git_ahead)
        local behind=$(parse_git_behind)
        
        # Build git status string
        local git_status=""
        
        # Branch name
        if [ "$dirty" -gt 0 ]; then
            git_status="${YELLOW}$branch${RESET}"
        else
            git_status="${GREEN}$branch${RESET}"
        fi
        
        # Dirty files indicator
        if [ "$dirty" -gt 0 ]; then
            git_status="$git_status ${RED}+$dirty${RESET}"
        fi
        
        # Ahead/behind indicators
        if [ -n "$ahead" ]; then
            git_status="$git_status ${GREEN}↑$ahead${RESET}"
        fi
        if [ -n "$behind" ]; then
            git_status="$git_status ${RED}↓$behind${RESET}"
        fi
        
        echo " ${CYAN}[${RESET}$git_status${CYAN}]${RESET}"
    fi
}

# Virtual environment detection
virtualenv_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "${PURPLE}($(basename $VIRTUAL_ENV))${RESET} "
    fi
}

# Exit status indicator
exit_status() {
    local status=$?
    if [ $status -ne 0 ]; then
        echo "${RED}✗${RESET} "
    else
        echo "${GREEN}✓${RESET} "
    fi
}

# Build the prompt (posh-git style)
build_prompt() {
    local last_status=$?
    PS1=""
    
    # Exit status
    if [ $last_status -ne 0 ]; then
        PS1="${RED}✗${RESET} "
    else
        PS1="${GREEN}✓${RESET} "
    fi
    
    # Virtual environment
    PS1="${PS1}$(virtualenv_info)"
    
    # Username@hostname
    if [ "$EUID" -eq 0 ]; then
        PS1="${PS1}${RED}\u@\h${RESET}"
    else
        PS1="${PS1}${GREEN}\u@\h${RESET}"
    fi
    
    PS1="${PS1}:"
    
    # Current directory (shortened)
    PS1="${PS1}${BLUE}\w${RESET}"
    
    # Git information
    PS1="${PS1}$(git_prompt_info)"
    
    # Prompt character
    if [ "$EUID" -eq 0 ]; then
        PS1="${PS1}\n${RED}#${RESET} "
    else
        PS1="${PS1}\n${BOLD}\$${RESET} "
    fi
}

# Set the prompt command
PROMPT_COMMAND=build_prompt

# Alternative simpler prompt (uncomment to use)
# PS1='${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}$(git_prompt_info)\n$ '

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# FZF integration (if installed)
if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    source /usr/share/fzf/shell/key-bindings.bash
fi

# Node Version Manager (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust (if installed)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Welcome message (only in interactive shells)
if [[ $- == *i* ]]; then
    echo -e "\033[0;36mWelcome to Fedora Linux\033[0m"
    echo -e "Type \033[0;32mfedora-config\033[0m or \033[0;32momakub\033[0m for configuration menu"
    echo
fi

export PATH="$HOME/bin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Starship prompt
eval "$(starship init bash)"
# 1Password CLI configuration
export OP_BIOMETRIC_UNLOCK_ENABLED=false  # No Touch ID on Linux

# Check for 1Password CLI dependencies
for dep in jq; do
    command -v "$dep" >/dev/null || echo "⚠ Missing dependency for 1Password helpers: $dep"
done

# 1Password CLI helpers
op-login() {
    # Sign in and get session token
    command -v op >/dev/null || { echo "op not installed"; return 1; }
    echo "Signing into 1Password CLI..."
    local tok
    tok=$(op signin --raw) || { echo "❌ Sign-in failed"; return 1; }
    export OP_SESSION="$tok"
    echo "✅ Successfully signed in to 1Password"
    echo "Session active for this shell (expires after ~30 min inactivity)"
}

op-get() {
    # Quick password retrieval
    # Usage: op-get "item name"
    if [ -z "$1" ]; then
        echo "Usage: op-get 'item name'"
        return 1
    fi
    op item get "$1" --fields password
}

op-copy() {
    # Copy password to clipboard
    # Usage: op-copy "item name"
    [[ -z "$1" ]] && { echo "Usage: op-copy 'item name'"; return 1; }
    local pw
    pw=$(op item get "$1" --fields password) || return 1
    
    if command -v wl-copy >/dev/null; then
        printf %s "$pw" | wl-copy
        echo "Password copied to clipboard (Wayland)"
    elif command -v xclip >/dev/null; then
        printf %s "$pw" | xclip -selection clipboard
        echo "Password copied to clipboard (X11)"
    else
        printf %s "$pw"
        echo "  (install wl-clipboard or xclip for clipboard support)"
    fi
}

op-list() {
    # List all items
    op item list --format=json | jq -r '.[].title' | sort
}

op-session-check() {
    # Check if session is active
    if op vault list &>/dev/null; then
        echo "✅ 1Password session is active"
        return 0
    else
        echo "❌ No active session. Run: op-login"
        return 1
    fi
}

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

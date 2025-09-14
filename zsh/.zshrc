# zshrc: interactive-shell setup

# Starship prompt (if installed)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Add user-local scripts to PATH (idempotent)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac

# direnv (optional, if installed)
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Node: prefer Volta for version management across OSes

# Example: project-specific completions (safe-guarded)
#[[ -f /path/to/.completions/something.zsh ]] && . /path/to/.completions/something.zsh

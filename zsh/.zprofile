# zprofile: login-shell setup for macOS

# Homebrew environment (Apple Silicon or Intel)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$($(command -v /opt/homebrew/bin/brew) shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$($(command -v /usr/local/bin/brew) shellenv)"
fi

# nvm (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"


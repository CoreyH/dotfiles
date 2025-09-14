#!/usr/bin/env bash
set -euo pipefail

echo "=== Dotfiles macOS Bootstrap ==="

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Dotfiles: $DOTFILES_DIR"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap script is for macOS (Darwin) only." >&2
  exit 1
fi

# Ensure Homebrew
if ! command -v brew >/dev/null 2>&1; then
  cat <<'EONOTE'
Homebrew not found. Install with:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

After installing, run:
  echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >> ~/.zprofile
  eval "$($(brew --prefix)/bin/brew shellenv)"
EONOTE
else
  echo "✓ Homebrew found: $(command -v brew)"
fi

# Create ~/bin and link user commands
mkdir -p "$HOME/bin"
if [[ -d "$DOTFILES_DIR/bin" ]]; then
  for cmd in "$DOTFILES_DIR"/bin/*; do
    [[ -f "$cmd" ]] || continue
    ln -sf "$cmd" "$HOME/bin/$(basename "$cmd")"
    chmod +x "$HOME/bin/$(basename "$cmd")" || true
  done
  echo "✓ Linked user commands to ~/bin"
fi

# Zsh configs
mkdir -p "$HOME"
if [[ -f "$DOTFILES_DIR/zsh/.zprofile" ]]; then
  ln -sf "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
  echo "✓ Linked .zprofile"
fi
if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  echo "✓ Linked .zshrc"
fi

# Git config
if [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
  ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  echo "✓ Linked .gitconfig"
fi

# Alacritty (optional)
if [[ -d "$DOTFILES_DIR/alacritty" ]]; then
  mkdir -p "$HOME/.config"
  ln -snf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
  echo "✓ Linked Alacritty config"
fi

# Volta suggestion
if ! command -v volta >/dev/null 2>&1; then
  echo "ℹ Consider installing Volta for Node.js management: curl https://get.volta.sh | bash"
fi

echo "\nNext steps:"
echo "  1) Optionally install packages: brew bundle --file '$DOTFILES_DIR/homebrew/Brewfile'"
echo "  2) Restart terminal or run: exec zsh -l"
echo "Done."


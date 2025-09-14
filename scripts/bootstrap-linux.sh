#!/usr/bin/env bash
set -euo pipefail

echo "=== Dotfiles Linux Bootstrap ==="

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Dotfiles: $DOTFILES_DIR"

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "This script targets Linux. For macOS, use scripts/bootstrap-macos.sh" >&2
  exit 1
fi

# Link bash config
if [[ -f "$DOTFILES_DIR/bash/.bashrc" ]]; then
  ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
  echo "✓ Linked .bashrc"
fi
if [[ -f "$DOTFILES_DIR/bash/.bash_aliases" ]]; then
  ln -sf "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"
  echo "✓ Linked .bash_aliases"
fi

# Git config
if [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
  ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  echo "✓ Linked .gitconfig"
fi

# User commands
mkdir -p "$HOME/bin"
if [[ -d "$DOTFILES_DIR/bin" ]]; then
  for cmd in "$DOTFILES_DIR"/bin/*; do
    [[ -f "$cmd" ]] || continue
    ln -sf "$cmd" "$HOME/bin/$(basename "$cmd")"
    chmod +x "$HOME/bin/$(basename "$cmd")" || true
  done
  echo "✓ Linked user commands to ~/bin"
fi

echo "\nRestart shell: source ~/.bashrc"
echo "Done."


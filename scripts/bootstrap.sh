#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd -- "$here/.." && pwd)"
cd "$root"

log() { printf "[bootstrap] %s\n" "$*"; }
run_if_exists() {
  local script="$1"
  if [[ -x "$script" ]]; then
    log "Running $(basename "$script")"
    "$script"
  elif [[ -f "$script" ]]; then
    log "Making executable: $(basename "$script")"
    chmod +x "$script"
    log "Running $(basename "$script")"
    "$script"
  else
    log "Skip: $(basename "$script") not found"
  fi
}

log "Starting bootstrap in $root"

# Volta + Claude Code
run_if_exists "$root/scripts/install-volta.sh"
if [[ -f "$HOME/.bashrc" ]]; then source "$HOME/.bashrc" || true; fi
run_if_exists "$root/scripts/install-claude-code.sh"

# GNOME extensions and clipboard manager
run_if_exists "$root/scripts/setup-extensions.sh"
run_if_exists "$root/scripts/setup-clipboard-manager.sh"

# Edge profiles / PWAs
run_if_exists "$root/scripts/configure-edge-profiles.sh"

log "Bootstrap finished. Recommended next steps:"
cat <<'NEXT'
1) Install Edge (RPM) and 1Password (RPM) if not already installed (see CLAUDE.md > Setup Guide).
2) Authenticate OneDrive: run 'onedrive', then 'onedrive --sync --resync'.
3) Enable OneDrive service: 'systemctl --user enable --now onedrive'.
4) Verify: 'systemctl --user status onedrive --no-pager'.
5) Check GNOME extensions and Windows-style shortcuts if desired.
NEXT


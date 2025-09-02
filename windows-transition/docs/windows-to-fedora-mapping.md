# Windows to Fedora Application Mapping

## Core Development Tools

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| Git | git | `dnf install git` | Direct equivalent |
| Docker Desktop | docker + podman | `dnf install docker podman` | Podman is Fedora's preferred container engine |
| Visual Studio Professional | VS Code / JetBrains IDEs | Flatpak/RPM | VS Code is free, JetBrains for professional features |
| Cursor | VS Code + Continue.dev | RPM | AI coding assistance alternative |
| GitHub CLI | gh | `dnf install gh` | Direct equivalent |
| GitHub Desktop | GitKraken / gh CLI | Flatpak | No official GitHub Desktop for Linux |
| PowerShell | bash/zsh + pwsh | `dnf install powershell` | PowerShell Core available for Linux |
| NVM for Windows | volta / nvm | Script install | Volta recommended (already in your dotfiles) |

## Browsers & Communication

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| Microsoft Edge | Microsoft Edge | RPM (preferred) | Available for Linux |
| Discord | Discord | Flatpak/RPM | Direct equivalent |
| Signal | Signal | Flatpak | Direct equivalent |
| Zoom | Zoom | RPM/Flatpak | Direct equivalent |
| Microsoft Teams | Teams PWA in Edge | Edge web app | Better than native app |

## Productivity & Office

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| Microsoft 365 | LibreOffice + Edge PWAs | `dnf install libreoffice` + Edge | Use Office.com PWAs for best compatibility |
| Notion Calendar | Web app | Edge PWA | No native Linux app |
| Todoist | Web app / Flatpak | Edge PWA or Flatpak | Both options available |
| Obsidian | Obsidian | Flatpak/AppImage | Direct equivalent |
| 1Password | 1Password | RPM | Direct equivalent (needs RPM Edge) |
| Adobe Creative Cloud | GIMP/Inkscape/Kdenlive | `dnf install` | Or run Adobe in Windows VM |
| Adobe Illustrator | Inkscape | `dnf install inkscape` | Good alternative for vector graphics |
| Adobe Acrobat | Okular/Evince | `dnf install okular` | Built-in PDF support |
| Typora | Typora/Mark Text | Download from site | Typora has Linux version |

## File Management & System Tools

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| WizTree | baobab (Disk Usage Analyzer) | Pre-installed | GNOME's disk usage tool |
| Beyond Compare | Meld / Beyond Compare | `dnf install meld` or purchase | Beyond Compare has Linux version |
| 7-Zip | File Roller/p7zip | Pre-installed | Built-in archive manager |
| WinSCP | FileZilla/rclone | `dnf install filezilla` | FileZilla already in your list |
| FileZilla | FileZilla | `dnf install filezilla` | Direct equivalent |
| PNGGauntlet | optipng/pngcrush | `dnf install optipng` | Command-line tools |
| Syncthing | Syncthing | `dnf install syncthing` | Direct equivalent |
| OneDrive | abraunegg/onedrive | `dnf install onedrive` | Already configured in dotfiles |
| Tailscale | Tailscale | `dnf install tailscale` | Direct equivalent |

## Media & Entertainment

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| VLC | VLC | `dnf install vlc` | Direct equivalent |
| yt-dlp | yt-dlp | `pip install yt-dlp` | Direct equivalent |
| ffmpeg | ffmpeg | `dnf install ffmpeg` | Direct equivalent |

## Development Environments

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| Miniconda3 | Miniconda3/Mambaforge | Script install | Direct equivalent |
| PostgreSQL | PostgreSQL | `dnf install postgresql` | Direct equivalent |
| IIS Express | nginx/Apache | `dnf install nginx` | Web server alternatives |
| .NET SDK | .NET SDK | Microsoft repo | Direct equivalent |
| CUDA Toolkit | CUDA Toolkit | NVIDIA repo | Direct equivalent for NVIDIA GPUs |
| ComfyUI | ComfyUI | Git clone | Same installation process |

## Terminal & Shell

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| Warp | Alacritty/Warp | `dnf install alacritty` | Warp has Linux beta |
| Windows Terminal | GNOME Terminal/Alacritty | Pre-installed | Already configured in dotfiles |
| BareTail/SnakeTail | tail -f / multitail | `dnf install multitail` | Built-in commands |

## System Monitoring

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| HWMonitor | lm_sensors/htop | `dnf install lm_sensors htop` | Command-line tools |
| CoreTemp | sensors | Part of lm_sensors | Temperature monitoring |
| FanControl | fancontrol/CoreCtrl | `dnf install fancontrol` | Fan speed control |
| CrystalDiskMark | fio/kdiskmark | `dnf install fio` | Disk benchmarking |
| Geekbench | Geekbench | Download from site | Linux version available |

## Hardware Specific

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| AMD Chipset Software | Built-in kernel | Automatic | Linux has native AMD support |
| NVIDIA Graphics Driver | NVIDIA drivers | RPM Fusion | Via RPM Fusion repository |
| ASRock utilities | OpenRGB | `dnf install openrgb` | For RGB control |
| Glorious Model D Software | Piper | `dnf install piper` | Gaming mouse configuration |

## Network Tools

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| DNS Benchmark | dig/nslookup/dnsbench | Built-in tools | Command-line alternatives |
| NordVPN | NordVPN | Script install | Official Linux client available |
| Postman | Postman/Bruno | Flatpak | Both available on Linux |

## AI/ML Tools

| Windows App | Fedora Alternative | Installation Method | Notes |
|------------|-------------------|-------------------|-------|
| Claude Desktop | Claude.ai (web) | Edge PWA | No official Linux app yet |
| Cursor | VS Code + Continue | RPM | AI coding assistance |
| Wispr Flow | Web alternatives | N/A | No Linux version |

## Additional Linux-Specific Tools to Consider

- **tldr**: Simplified man pages (`dnf install tldr`)
- **bat**: Better cat with syntax highlighting (`dnf install bat`)
- **ripgrep**: Fast grep alternative (`dnf install ripgrep`)
- **fd**: Fast find alternative (`dnf install fd-find`)
- **fzf**: Fuzzy finder (`dnf install fzf`)
- **ncdu**: NCurses disk usage (`dnf install ncdu`)
- **btop**: Better htop (`dnf install btop`)
- **neovim**: Modern vim (`dnf install neovim`)
- **tmux**: Terminal multiplexer (`dnf install tmux`)
- **zoxide**: Smarter cd (`dnf install zoxide`)

## Notes on Migration Strategy

1. **Priority 1 - Direct Equivalents**: Install these first as they work identically
2. **Priority 2 - Web Apps**: Use Edge PWAs for Microsoft services
3. **Priority 3 - Alternatives**: Learn new tools that serve similar purposes
4. **Priority 4 - Windows VM**: Keep a Windows VM for Adobe Creative Suite if needed
5. **Dual Boot Consideration**: Keep Windows for gaming and specialized software

## Apps Requiring Special Attention

- **Visual Studio Professional**: Consider JetBrains IDEs or stick with VS Code
- **Adobe Creative Suite**: May need Windows VM or Wine/Bottles
- **Gaming (if applicable)**: Check ProtonDB for Steam game compatibility
- **Hardware-specific tools**: Test RGB/fan control early in migration
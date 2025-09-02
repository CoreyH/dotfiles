# Windows to Fedora Dual Boot Transition Checklist

## Pre-Installation Preparation

### Data Backup
- [ ] Full system backup or critical files backup
- [ ] Export browser bookmarks and passwords
- [ ] Backup SSH keys and GPG keys
- [ ] Document all license keys for paid software
- [ ] Export VPN configurations
- [ ] Backup any custom scripts or automation
- [ ] Ensure OneDrive sync is complete
- [ ] Backup game saves (if applicable)

### System Documentation
- [ ] Run `export-windows-settings.ps1` script
- [ ] Document partition layout and sizes
- [ ] Note BIOS/UEFI settings
- [ ] Document any special hardware configurations
- [ ] List all peripherals and their models

### Hardware Compatibility Check
- [ ] Check Linux compatibility for:
  - [ ] Graphics card (NVIDIA/AMD)
  - [ ] Wi-Fi adapter
  - [ ] Bluetooth
  - [ ] Webcam
  - [ ] Fingerprint reader (if applicable)
  - [ ] Audio interfaces
  - [ ] External monitors
  - [ ] Printers/scanners
  - [ ] Gaming peripherals

## Dual Boot Setup

### Disk Preparation
- [ ] Shrink Windows partition (leave adequate space)
- [ ] Disable Fast Startup in Windows
- [ ] Disable Secure Boot (if needed)
- [ ] Create Fedora installation media
- [ ] Backup Windows recovery key (BitLocker)

### Installation
- [ ] Boot from Fedora USB
- [ ] Choose manual partitioning
- [ ] Create partitions:
  - [ ] /boot/efi (if not sharing with Windows)
  - [ ] / (root)
  - [ ] /home (separate recommended)
  - [ ] swap (optional with enough RAM)
- [ ] Install Fedora alongside Windows
- [ ] Configure bootloader (GRUB)
- [ ] Test dual boot functionality

## Post-Installation Setup

### System Configuration (Run from dotfiles)
- [ ] Clone dotfiles repository
- [ ] Run `install.sh` from dotfiles
- [ ] Configure prompt (Starship recommended)
- [ ] Setup Alacritty terminal
- [ ] Install and configure Volta
- [ ] Install Claude Code
- [ ] Setup Windows-style keyboard shortcuts
- [ ] Configure clipboard manager

### Essential Software
- [ ] Install Microsoft Edge (RPM for 1Password)
- [ ] Setup 1Password
- [ ] Configure OneDrive sync
- [ ] Install development tools (Git, Docker, etc.)
- [ ] Setup VS Code or preferred IDE
- [ ] Configure shell and terminal

### GNOME Configuration
- [ ] Install Extension Manager
- [ ] Install Dash to Panel
- [ ] Install Auto Move Windows
- [ ] Configure virtual desktops
- [ ] Set up clipboard manager (Super+V)
- [ ] Apply Windows-style shortcuts

### Data Migration
- [ ] Mount Windows partition (read-only initially)
- [ ] Copy necessary project files
- [ ] Import browser bookmarks
- [ ] Setup SSH keys
- [ ] Configure Git credentials
- [ ] Setup cloud storage sync

### Development Environment
- [ ] Install language runtimes (Node.js via Volta, Python, etc.)
- [ ] Setup package managers (npm, pip, cargo, etc.)
- [ ] Configure database clients
- [ ] Install Docker/Podman
- [ ] Setup virtual environments
- [ ] Clone active repositories

### Hardware & Drivers
- [ ] Install NVIDIA/AMD drivers (if needed)
- [ ] Configure multiple monitors
- [ ] Test audio input/output
- [ ] Setup printers
- [ ] Configure gaming peripherals
- [ ] Test webcam and microphone

### Applications Setup
- [ ] Install communication apps (Discord, Signal, Teams)
- [ ] Setup productivity apps (Obsidian, Todoist)
- [ ] Configure media players (VLC)
- [ ] Install file management tools
- [ ] Setup screenshot tools (Flameshot)

## Testing & Validation

### Functionality Tests
- [ ] Test dual boot switching
- [ ] Verify file access between OSes
- [ ] Test all hardware peripherals
- [ ] Verify network connectivity
- [ ] Test VPN connections
- [ ] Check battery life (laptops)
- [ ] Test sleep/hibernate
- [ ] Verify external display setup

### Performance Validation
- [ ] Run disk benchmarks
- [ ] Test compilation times
- [ ] Check resource usage
- [ ] Verify GPU acceleration
- [ ] Test Docker performance

## Ongoing Maintenance

### Regular Tasks
- [ ] Keep both OSes updated
- [ ] Maintain bootloader after kernel updates
- [ ] Sync dotfiles changes
- [ ] Document any new configurations
- [ ] Regular backups of both systems

### Troubleshooting Resources
- [ ] Fedora documentation bookmarked
- [ ] Hardware-specific Linux forums identified
- [ ] Backup boot USB maintained
- [ ] Windows recovery media available

## Notes Section

### Known Issues to Watch For:
- Time sync issues between Windows and Linux (UTC vs local time)
- Shared NTFS partitions may have permission issues
- Some Windows apps may not have perfect Linux alternatives
- Gaming performance may vary (check ProtonDB)
- Secure Boot complications with some hardware

### Helpful Commands:
```bash
# Check UEFI/BIOS mode
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS"

# Update GRUB after changes
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Mount Windows partition
sudo mkdir /mnt/windows
sudo mount -t ntfs-3g /dev/nvme0n1p3 /mnt/windows -o ro

# Check hardware info
inxi -Fxz
lspci
lsusb
```

### Resources:
- [Fedora Documentation](https://docs.fedoraproject.org/)
- [ProtonDB](https://www.protondb.com/) - For gaming compatibility
- [Fedora Dual Boot Guide](https://docs.fedoraproject.org/en-US/fedora/latest/install-guide/install/Booting_the_Installation/)
- Your dotfiles repo: https://github.com/YOUR_USERNAME/dotfiles
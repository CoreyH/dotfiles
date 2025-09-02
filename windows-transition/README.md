# Windows to Fedora Transition Helper

This folder contains tools and documentation to help with your Windows to Fedora dual boot transition.

## Structure

```
windows-transition/
├── apps/                      # Exported application lists
│   ├── chocolatey-packages.txt    # Chocolatey installed packages
│   └── winget-packages.txt        # Winget installed packages
├── configs/                   # Windows configuration exports (created by script)
├── docs/                      # Documentation
│   ├── transition-checklist.md    # Step-by-step dual boot checklist
│   └── windows-to-fedora-mapping.md # App equivalents mapping
├── scripts/                   # Helper scripts
│   └── export-windows-settings.ps1 # PowerShell script to export settings
└── README.md                  # This file
```

## Quick Start

1. **Export your Windows configuration:**
   ```powershell
   # Run in PowerShell as Administrator
   cd windows-transition\scripts
   .\export-windows-settings.ps1
   ```

2. **Review your installed applications:**
   - Check `apps/chocolatey-packages.txt` for Chocolatey packages
   - Check `apps/winget-packages.txt` for Winget packages
   - See `docs/windows-to-fedora-mapping.md` for Linux alternatives

3. **Follow the transition checklist:**
   - Open `docs/transition-checklist.md`
   - Work through each section systematically

## Key Files

### Application Lists
- **chocolatey-packages.txt**: 44 packages including development tools, utilities, and media apps
- **winget-packages.txt**: 100+ packages including IDEs, browsers, productivity apps

### Documentation
- **transition-checklist.md**: Comprehensive checklist for dual boot setup
- **windows-to-fedora-mapping.md**: Maps Windows apps to Fedora equivalents

### Scripts
- **export-windows-settings.ps1**: Exports Windows settings, environment variables, configurations

## Important Considerations

### Priority Applications to Address
Based on your installed apps, these will need special attention:

1. **Development Stack**:
   - Visual Studio Professional → VS Code or JetBrains IDEs
   - Docker Desktop → Docker/Podman (native Linux)
   - Multiple Node versions → Volta (already in dotfiles)

2. **Creative Suite**:
   - Adobe Illustrator → Consider VM or Wine
   - Adobe Creative Cloud → Alternatives or Windows boot

3. **Microsoft Ecosystem**:
   - Microsoft 365 → Edge PWAs + LibreOffice
   - OneDrive → abraunegg client (in dotfiles)
   - Teams → Web app or native client

4. **Hardware Tools**:
   - AMD/NVIDIA drivers → Native Linux versions
   - ASRock utilities → OpenRGB for lighting
   - FanControl → fancontrol or CoreCtrl

## Next Steps

1. Run the export script to capture current Windows settings
2. Review the app mapping to understand what's available on Linux
3. Start with the pre-installation preparation in the checklist
4. Consider which apps absolutely require Windows (for dual boot planning)
5. Test critical workflows in a VM before committing to dual boot

## Tips

- Keep Windows for Adobe Creative Suite and any Windows-only games
- Most development work transitions seamlessly to Linux
- Your existing dotfiles repo will handle most Fedora configuration
- Edge browser with profiles will work identically on Linux
- 1Password requires RPM Edge (not Flatpak) for browser integration

## After Transition

Once on Fedora, your existing dotfiles will handle:
- Terminal setup (Alacritty + Starship)
- Development tools (Volta, Claude Code)
- OneDrive sync
- GNOME customization
- Keyboard shortcuts (Windows-style)

Remember to push any new configurations back to your dotfiles repo!
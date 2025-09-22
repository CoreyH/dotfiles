# WinGet Package Management

This directory contains scripts and configuration for managing Windows packages using WinGet instead of Chocolatey.

## Migration Plan from Chocolatey to WinGet

### Why Migrate?
- **Single package manager**: Avoid conflicts between Chocolatey and WinGet managing the same software
- **First-party support**: WinGet is built into Windows and maintained by Microsoft
- **Better integration**: Works well with vendor auto-updaters and Windows Store apps
- **Less maintenance**: No community package drift or outdated packages

### Migration Steps

Run these PowerShell scripts in order:

1. **`01-freeze-chocolatey.ps1`**
   - **Actually** freezes Chocolatey by pinning all packages
   - Shows what packages would be upgraded (dry run)
   - Prevents accidental updates during migration

2. **`02-uninstall-choco-overlaps.ps1`**
   - Removes packages from Chocolatey that overlap with WinGet
   - Properly uninstalls apps (not just metadata) with `--remove-dependencies`
   - Includes previously missed packages (nodejs, obs-studio, handbrake)
   - Orders uninstalls: meta packages first, then .install versions

3. **`03-install-winget-packages.ps1`**
   - Reads from `packages.json` as single source of truth
   - Supports per-package options: scope, override, silent
   - Handles Visual Studio workloads via override parameter
   - Applies package pins automatically after installation

4. **`04-verify-migration.ps1`**
   - Uses clean `-lo --limit-output` for accurate counting
   - Shows both WinGet repo and MS Store upgradeable packages
   - Lists pinned packages
   - Provides clear next steps

5. **`05-manage-winget.ps1`**
   - Upgrades both WinGet repo AND MS Store packages
   - Uses improved package.json structure for install-all
   - Supports: upgrade, install-all, export, import, pin, unpin, list-pins

## Files

- **`packages.json`**: Master list of WinGet packages with extended configuration
  - Supports optional fields: `scope`, `override`, `silent`, `pin`
  - Includes Visual Studio workloads configuration
  - Separate `pins` section for packages that should be version-locked
- **`package-overlaps.txt`**: Documentation of packages that exist in both Chocolatey and WinGet
- **`winget-export.json`**: (Created by export command) Current system package state

## Key Improvements (Based on Expert Feedback)

1. **Proper Chocolatey Freezing**: Now actually pins packages instead of just enabling a feature
2. **Complete Uninstalls**: Removed `--skip-autouninstaller` which was leaving apps behind
3. **MS Store Support**: Upgrade script now handles both WinGet and MS Store packages
4. **Visual Studio Workloads**: Properly configures VS with workloads via override parameter
5. **Single Source of Truth**: Install script reads from packages.json instead of duplicating lists
6. **Missing Packages Added**: Added nodejs, obs-studio, handbrake that were overlooked
7. **Clean Counting**: Uses `-lo --limit-output` for accurate package counting
8. **Per-Package Options**: Supports scope, silent mode, and override parameters per package
9. **Automatic Pinning**: Critical packages like CUDA, NVM, and Visual Studio are auto-pinned

## Daily Usage

### Update all packages
```powershell
.\05-manage-winget.ps1 upgrade
# or directly:
winget upgrade --all
```

### Install packages on new machine
```powershell
.\05-manage-winget.ps1 install-all
```

### Pin a critical version
```powershell
winget pin add --id OpenJS.NodeJS.LTS
```

### Export current state
```powershell
.\05-manage-winget.ps1 export
```

## Package Categories

### Migrated from Chocolatey
Core tools that were managed by Chocolatey and now use WinGet:
- 7-Zip, Beyond Compare, Git, VLC, WinSCP, WizTree, etc.

### Chocolatey-Only (No WinGet equivalent)
These remain in Chocolatey or need manual installation:
- baretail (use SnakeTail as alternative)
- cinebench (benchmark tool)
- coretemp (temperature monitor)
- dns-benchmark
- wget (use curl or Invoke-WebRequest)

### Dependencies (Can ignore)
System packages managed automatically:
- Visual C++ Redistributables
- Windows KB updates
- Chocolatey itself and extensions

## Tips

1. **Prefer WinGet repo over Store**: Use `--source winget` to avoid Store versions
2. **Silent installs**: Use `--silent` flag to avoid GUI installers
3. **Pin critical tools**: Prevent automatic updates for tools requiring specific versions
4. **Let vendor updaters work**: Chrome, Obsidian, etc. can update themselves
5. **Check both managers during transition**: Some packages might still appear in both

## Troubleshooting

### Package appears in both managers
- This is normal during transition
- Only the WinGet version will be updated going forward
- Chocolatey version can be uninstalled once verified

### WinGet can't find a package
- Check exact ID with: `winget search <name>`
- Some packages have different IDs than expected
- Use `--source winget` to exclude Store packages

### Installation fails
- Try without `--silent` flag to see installer GUI
- Some packages require admin elevation
- Check if package needs specific install scope: `--scope user` or `--scope machine`

## Complete Uninstall of Chocolatey (Optional)

After successful migration and verification:

```powershell
# Only if nothing important remains in Chocolatey
if ((choco list | Select-String -Pattern "^\S+" | Measure-Object).Count -le 10) {
    # Uninstall Chocolatey
    Remove-Item -Recurse -Force "C:\ProgramData\chocolatey"
    [System.Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, "Machine")
    [System.Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, "User")
}
```
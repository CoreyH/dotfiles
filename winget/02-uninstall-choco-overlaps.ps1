# Uninstall Chocolatey packages that overlap with WinGet
# Run this after freezing Chocolatey (01-freeze-chocolatey.ps1)

Write-Host "=== Removing Chocolatey Overlapping Packages ===" -ForegroundColor Yellow
Write-Host "This will uninstall Chocolatey packages that are also available in WinGet"
Write-Host ""

# Ask for confirmation
$confirm = Read-Host "This will uninstall packages managed by Chocolatey. Continue? (Y/N)"
if ($confirm -ne 'Y' -and $confirm -ne 'y') {
    Write-Host "Aborted by user" -ForegroundColor Red
    exit
}

# List of packages to uninstall from Chocolatey
# These are the ones that overlap with WinGet
# Order: meta packages first, then .install versions, to avoid dependency issues
$packagesToRemove = @(
    # Meta packages first
    "7zip",
    "beyondcompare",
    "bruno",
    "git",
    "typora",
    "vlc",
    "winscp",
    "wiztree",
    "snaketail",
    "pnggauntlet",
    "openssl",
    "miniconda3",
    "crystaldiskmark",
    "hwmonitor",
    "filezilla",
    "geekbench6",
    "geekbench",
    # Missing packages from inventory
    "nodejs",
    "obs-studio",
    "handbrake",
    # .install versions after meta packages
    "7zip.install",
    "git.install",
    "vlc.install",
    "winscp.install",
    "snaketail.install",
    "pnggauntlet.install",
    "hwmonitor.install",
    "nodejs.install",
    "handbrake.install"
)

Write-Host "Removing the following packages from Chocolatey:" -ForegroundColor Cyan
$packagesToRemove | ForEach-Object { Write-Host "  - $_" }
Write-Host ""

# Uninstall each package
foreach ($package in $packagesToRemove) {
    Write-Host "Uninstalling $package..." -ForegroundColor White
    # Remove --skip-autouninstaller and add --remove-dependencies for cleaner uninstall
    choco uninstall $package -y --remove-dependencies
}

Write-Host ""
Write-Host "✅ Chocolatey overlapping packages removed" -ForegroundColor Green
Write-Host "Next step: Run 03-install-winget-packages.ps1" -ForegroundColor Yellow
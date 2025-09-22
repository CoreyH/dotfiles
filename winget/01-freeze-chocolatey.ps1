# Freeze Chocolatey to stop it from touching packages
# Run this first to prepare for migration

Write-Host "=== Freezing Chocolatey ===" -ForegroundColor Yellow
Write-Host "This will pin all Chocolatey packages to prevent accidental updates during migration"
Write-Host ""

# Enable package exit codes for better error handling
choco feature enable -n usePackageExitCodes

# Review what would be upgraded (dry run)
Write-Host "Current outdated Chocolatey packages (review only):" -ForegroundColor Cyan
choco upgrade all --noop

Write-Host ""
Write-Host "Pinning all installed packages to prevent updates..." -ForegroundColor Yellow

# Get all installed packages and pin them
$installed = choco list -lo --limit-output | ForEach-Object { ($_ -split '\|')[0] }
$pinCount = 0

foreach ($package in $installed) {
    if ($package -and $package.Trim()) {
        choco pin add -n $package | Out-Null
        $pinCount++
        Write-Host "  Pinned: $package" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "✅ Chocolatey is now frozen. Pinned $pinCount packages." -ForegroundColor Green
Write-Host "Next step: Run 02-uninstall-choco-overlaps.ps1" -ForegroundColor Yellow
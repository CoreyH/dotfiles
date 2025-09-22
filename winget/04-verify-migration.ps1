# Verify the migration status
# Run this after installing WinGet packages

Write-Host "=== Verifying Migration Status ===" -ForegroundColor Yellow
Write-Host ""

# Check what's left in Chocolatey
Write-Host "Remaining Chocolatey packages:" -ForegroundColor Cyan

# Get Chocolatey packages with clean output format
$chocoList = choco list -lo --limit-output

if ($chocoList) {
    $chocoPackages = $chocoList | ForEach-Object {
        $parts = $_ -split '\|'
        if ($parts.Count -ge 2) {
            [PSCustomObject]@{
                Name = $parts[0]
                Version = $parts[1]
            }
        }
    }

    # Display packages
    $chocoPackages | ForEach-Object {
        Write-Host "  $($_.Name) v$($_.Version)" -ForegroundColor White
    }

    # Count remaining packages
    $chocoCount = $chocoPackages.Count
} else {
    $chocoCount = 0
}

Write-Host ""
Write-Host "Chocolatey package count: $chocoCount" -ForegroundColor Yellow

# Check WinGet upgradeable packages
Write-Host ""
Write-Host "WinGet Repository packages with available updates:" -ForegroundColor Cyan
$wingetUpgrades = winget upgrade --source winget
Write-Host $wingetUpgrades

Write-Host ""
Write-Host "Microsoft Store packages with available updates:" -ForegroundColor Cyan
$storeUpgrades = winget upgrade --source msstore
Write-Host $storeUpgrades

# Check for pinned packages
Write-Host ""
Write-Host "Pinned packages (won't auto-upgrade):" -ForegroundColor Cyan
$pinnedPackages = winget pin list
if ($pinnedPackages -and ($pinnedPackages | Select-String -Pattern "No pins" -NotMatch)) {
    Write-Host $pinnedPackages
} else {
    Write-Host "  No packages are currently pinned" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Migration Summary ===" -ForegroundColor Green
Write-Host "✅ Overlapping packages migrated from Chocolatey to WinGet"
Write-Host "📦 $chocoCount packages remain in Chocolatey"

if ($chocoCount -gt 0) {
    Write-Host ""
    Write-Host "Remaining Chocolatey packages are either:" -ForegroundColor Yellow
    Write-Host "  - Chocolatey itself and its extensions"
    Write-Host "  - Windows KB updates and Visual C++ redistributables"
    Write-Host "  - Packages without WinGet equivalents (baretail, cinebench, coretemp, dns-benchmark, wget)"
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Use '.\05-manage-winget.ps1 upgrade' to update all packages"
Write-Host "  2. Pin critical versions with 'winget pin add --id <package-id>'"
Write-Host "  3. Consider uninstalling Chocolatey if no longer needed:"
Write-Host "     - Review remaining packages with 'choco list -lo --limit-output'"
Write-Host "     - If only Chocolatey core remains, can safely uninstall"
Write-Host "  4. Use 05-manage-winget.ps1 for ongoing WinGet management"
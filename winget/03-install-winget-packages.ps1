# Install packages via WinGet from packages.json
# Run this after removing Chocolatey overlaps (02-uninstall-choco-overlaps.ps1)

Write-Host "=== Installing Packages via WinGet ===" -ForegroundColor Yellow
Write-Host "Reading package list from packages.json..." -ForegroundColor Cyan
Write-Host ""

# Load packages from JSON file
$packagesFile = Join-Path $PSScriptRoot "packages.json"

if (-not (Test-Path $packagesFile)) {
    Write-Host "Error: packages.json not found!" -ForegroundColor Red
    Write-Host "Expected location: $packagesFile" -ForegroundColor Red
    exit 1
}

# Parse JSON
$packagesData = Get-Content $packagesFile | ConvertFrom-Json
$packages = $packagesData.packages

Write-Host "Found $($packages.Count) packages to process" -ForegroundColor Cyan
Write-Host ""

# Track results
$installed = 0
$skipped = 0
$failed = @()

# Install each package
foreach ($package in $packages) {
    Write-Host "Installing $($package.name)..." -ForegroundColor White

    # Build winget command arguments
    $args = @('install', '--id', $package.id, '-e', '--accept-package-agreements', '--accept-source-agreements')

    # Handle source-specific options
    if ($package.source -eq 'msstore') {
        $args += @('--source', 'msstore')
    } else {
        # Only add --silent for non-msstore packages unless explicitly set to false
        if ($package.silent -ne $false) {
            $args += '--silent'
        }
    }

    # Add optional scope
    if ($package.scope) {
        $args += @('--scope', $package.scope)
    }

    # Add override parameters (e.g., for Visual Studio workloads)
    if ($package.override) {
        $args += @('--override', $package.override)
    }

    # Execute winget command
    try {
        $result = winget @args

        # Check if already installed (winget returns specific text)
        if ($result -match "already installed" -or $result -match "No available upgrade") {
            Write-Host "  ✓ Already installed" -ForegroundColor Gray
            $skipped++
        } else {
            Write-Host "  ✓ Installed successfully" -ForegroundColor Green
            $installed++
        }
    } catch {
        Write-Host "  ✗ Failed to install: $_" -ForegroundColor Red
        $failed += $package.name
    }
}

Write-Host ""
Write-Host "=== Installation Summary ===" -ForegroundColor Green
Write-Host "✅ Installed: $installed packages" -ForegroundColor Green
Write-Host "⏭️  Skipped (already installed): $skipped packages" -ForegroundColor Yellow
if ($failed.Count -gt 0) {
    Write-Host "❌ Failed: $($failed.Count) packages" -ForegroundColor Red
    Write-Host "Failed packages:" -ForegroundColor Red
    $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

# Handle pins if specified
$pinsToApply = $packagesData.pins
if ($pinsToApply -and $pinsToApply.Count -gt 0) {
    Write-Host ""
    Write-Host "=== Applying Package Pins ===" -ForegroundColor Yellow

    foreach ($pin in $pinsToApply) {
        Write-Host "Pinning $($pin.id): $($pin.reason)" -ForegroundColor White
        winget pin add --id $pin.id | Out-Null
    }

    Write-Host "✅ Applied $($pinsToApply.Count) package pins" -ForegroundColor Green
}

Write-Host ""
Write-Host "Next step: Run 04-verify-migration.ps1 to check the migration status" -ForegroundColor Yellow
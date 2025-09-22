# WinGet management helper script
# Use this for ongoing package management after migration

param(
    [Parameter(Position=0)]
    [ValidateSet("upgrade", "install-all", "export", "import", "pin", "unpin", "list-pins")]
    [string]$Action = "upgrade"
)

function Show-Help {
    Write-Host "WinGet Management Script" -ForegroundColor Cyan
    Write-Host "Usage: .\05-manage-winget.ps1 [action]" -ForegroundColor White
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Yellow
    Write-Host "  upgrade      - Upgrade all packages (default)"
    Write-Host "  install-all  - Install all packages from packages.json"
    Write-Host "  export       - Export current packages to winget-export.json"
    Write-Host "  import       - Import packages from winget-export.json"
    Write-Host "  pin          - Interactive tool to pin package versions"
    Write-Host "  unpin        - Interactive tool to unpin packages"
    Write-Host "  list-pins    - List all pinned packages"
}

switch ($Action) {
    "upgrade" {
        Write-Host "=== Updating WinGet Sources ===" -ForegroundColor Yellow
        winget source update

        Write-Host ""
        Write-Host "=== Upgrading WinGet Repository Packages ===" -ForegroundColor Yellow
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements --source winget

        Write-Host ""
        Write-Host "=== Upgrading Microsoft Store Packages ===" -ForegroundColor Yellow
        winget upgrade --all --accept-package-agreements --accept-source-agreements --source msstore

        Write-Host ""
        Write-Host "✅ All packages upgraded" -ForegroundColor Green
    }

    "install-all" {
        Write-Host "=== Installing All Packages from packages.json ===" -ForegroundColor Yellow
        $packagesFile = Join-Path $PSScriptRoot "packages.json"

        if (-not (Test-Path $packagesFile)) {
            Write-Host "Error: packages.json not found!" -ForegroundColor Red
            exit 1
        }

        $packagesData = Get-Content $packagesFile | ConvertFrom-Json
        $packages = $packagesData.packages

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

            # Add override parameters
            if ($package.override) {
                $args += @('--override', $package.override)
            }

            winget @args
        }

        # Apply pins if specified
        if ($packagesData.pins -and $packagesData.pins.Count -gt 0) {
            Write-Host ""
            Write-Host "Applying package pins..." -ForegroundColor Yellow
            foreach ($pin in $packagesData.pins) {
                winget pin add --id $pin.id | Out-Null
            }
            Write-Host "✅ Applied $($packagesData.pins.Count) package pins" -ForegroundColor Green
        }
    }

    "export" {
        Write-Host "=== Exporting Current Packages ===" -ForegroundColor Yellow
        $exportFile = Join-Path $PSScriptRoot "winget-export.json"
        winget export -o $exportFile --accept-source-agreements
        Write-Host "✅ Exported to $exportFile" -ForegroundColor Green
    }

    "import" {
        Write-Host "=== Importing Packages ===" -ForegroundColor Yellow
        $importFile = Join-Path $PSScriptRoot "winget-export.json"

        if (-not (Test-Path $importFile)) {
            Write-Host "Error: winget-export.json not found!" -ForegroundColor Red
            exit 1
        }

        winget import -i $importFile --accept-package-agreements --accept-source-agreements
    }

    "pin" {
        Write-Host "=== Pin Package Versions ===" -ForegroundColor Yellow
        Write-Host "Enter package ID to pin (or 'exit' to quit):" -ForegroundColor Cyan

        while ($true) {
            $packageId = Read-Host "Package ID"
            if ($packageId -eq "exit") { break }

            winget pin add --id $packageId
        }
    }

    "unpin" {
        Write-Host "=== Unpin Package Versions ===" -ForegroundColor Yellow
        winget pin list
        Write-Host ""
        Write-Host "Enter package ID to unpin (or 'exit' to quit):" -ForegroundColor Cyan

        while ($true) {
            $packageId = Read-Host "Package ID"
            if ($packageId -eq "exit") { break }

            winget pin remove --id $packageId
        }
    }

    "list-pins" {
        Write-Host "=== Pinned Packages ===" -ForegroundColor Yellow
        winget pin list
    }

    default {
        Show-Help
    }
}

Write-Host ""
Write-Host "✅ Operation completed" -ForegroundColor Green
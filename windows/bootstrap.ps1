Param(
  [switch]$Force
)

Write-Host '=== Dotfiles Windows Bootstrap ==='

$Dotfiles = (Resolve-Path "$PSScriptRoot\..\").Path
Write-Host "Dotfiles: $Dotfiles"

# Ensure PowerShell profile path exists
if (-not (Test-Path -Path (Split-Path -Parent $PROFILE))) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $PROFILE) | Out-Null
}

# Link or copy profile
$RepoProfile = Join-Path $Dotfiles 'windows/profile.ps1'
if (Test-Path $RepoProfile) {
  if (Test-Path $PROFILE -and -not $Force) {
    Write-Host "Profile exists: $PROFILE (use -Force to overwrite)"
  } else {
    Copy-Item -Force $RepoProfile $PROFILE
    Write-Host "✓ Installed PowerShell profile"
  }
}

# Ensure ~/bin exists
$UserBin = Join-Path $HOME 'bin'
if (-not (Test-Path $UserBin)) { New-Item -ItemType Directory -Force -Path $UserBin | Out-Null }

# Link repo bin commands
$RepoBin = Join-Path $Dotfiles 'bin'
if (Test-Path $RepoBin) {
  Get-ChildItem -File $RepoBin | ForEach-Object {
    $target = $_.FullName
    $dest = Join-Path $UserBin $_.Name
    Copy-Item -Force $target $dest
  }
  Write-Host "✓ Copied user commands to $UserBin"
}

Write-Host "Next steps: Restart PowerShell or run '. $PROFILE'"
Write-Host 'Done.'


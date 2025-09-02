# PowerShell script to export Windows settings and configurations
# Run as Administrator for best results

$exportPath = "$PSScriptRoot\..\configs"
New-Item -ItemType Directory -Force -Path $exportPath | Out-Null

Write-Host "Exporting Windows settings..." -ForegroundColor Green

# Export environment variables
Write-Host "Exporting environment variables..."
Get-ChildItem env: | Out-File "$exportPath\environment-variables.txt"

# Export PATH variable separately for clarity
Write-Host "Exporting PATH..."
$env:Path -split ';' | Out-File "$exportPath\path-variable.txt"

# Export installed fonts list
Write-Host "Exporting installed fonts..."
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" | Out-File "$exportPath\installed-fonts.txt"

# Export Windows Terminal settings if it exists
$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettingsPath) {
    Write-Host "Exporting Windows Terminal settings..."
    Copy-Item $wtSettingsPath "$exportPath\windows-terminal-settings.json"
}

# Export VS Code settings if it exists
$vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
if (Test-Path $vscodeSettingsPath) {
    Write-Host "Exporting VS Code settings..."
    Copy-Item $vscodeSettingsPath "$exportPath\vscode-settings.json"
    
    # Also export extensions list
    Write-Host "Exporting VS Code extensions..."
    & code --list-extensions | Out-File "$exportPath\vscode-extensions.txt"
}

# Export Git config
Write-Host "Exporting Git configuration..."
& git config --global --list | Out-File "$exportPath\git-config.txt"

# Export SSH keys list (not the keys themselves for security)
if (Test-Path "$env:USERPROFILE\.ssh") {
    Write-Host "Listing SSH keys (not exporting actual keys)..."
    Get-ChildItem "$env:USERPROFILE\.ssh" | Select-Object Name, LastWriteTime | Out-File "$exportPath\ssh-keys-list.txt"
}

# Export network drives
Write-Host "Exporting mapped network drives..."
Get-PSDrive -PSProvider FileSystem | Where-Object {$_.DisplayRoot -ne $null} | Out-File "$exportPath\network-drives.txt"

# Export Windows features
Write-Host "Exporting Windows features..."
Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Enabled"} | Select-Object FeatureName | Out-File "$exportPath\windows-features.txt"

# Export startup programs
Write-Host "Exporting startup programs..."
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location | Out-File "$exportPath\startup-programs.txt"

# Export firewall rules
Write-Host "Exporting firewall rules..."
Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'True'} | Select-Object DisplayName, Direction, Action | Out-File "$exportPath\firewall-rules.txt"

# Export WSL distributions if WSL is installed
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    Write-Host "Exporting WSL distributions..."
    & wsl --list --verbose | Out-File "$exportPath\wsl-distributions.txt"
}

# Export display configuration
Write-Host "Exporting display configuration..."
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | Out-File "$exportPath\display-config.txt"

# Export power plan
Write-Host "Exporting power plan..."
powercfg /list | Out-File "$exportPath\power-plans.txt"
powercfg /query SCHEME_CURRENT | Out-File "$exportPath\current-power-plan.txt"

Write-Host "`nExport complete! Check the 'configs' folder for exported settings." -ForegroundColor Green
Write-Host "Remember to manually backup:" -ForegroundColor Yellow
Write-Host "  - Browser bookmarks and passwords" -ForegroundColor Yellow
Write-Host "  - SSH private keys (if needed)" -ForegroundColor Yellow
Write-Host "  - VPN configurations" -ForegroundColor Yellow
Write-Host "  - License keys for paid software" -ForegroundColor Yellow
Write-Host "  - Any custom scripts or automation" -ForegroundColor Yellow
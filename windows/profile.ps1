# PowerShell Profile for Windows

# Starship prompt (if installed)
if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}

# Add user bin to PATH (idempotent)
$userBin = "$HOME/bin"
if (-not (Test-Path $userBin)) { New-Item -ItemType Directory -Force -Path $userBin | Out-Null }
if (-not ($Env:PATH -split ';' | Where-Object { $_ -eq $userBin })) {
  $Env:PATH = "$userBin;" + $Env:PATH
}

# Volta (if installed)
if (-not $Env:VOLTA_HOME) { $Env:VOLTA_HOME = "$HOME/.volta" }
$voltaBin = Join-Path $Env:VOLTA_HOME 'bin'
if (Test-Path $voltaBin) {
  if (-not ($Env:PATH -split ';' | Where-Object { $_ -eq $voltaBin })) {
    $Env:PATH = "$voltaBin;" + $Env:PATH
  }
}

# direnv (optional)
if (Get-Command direnv -ErrorAction SilentlyContinue) {
  Invoke-Expression (direnv hook powershell)
}

# PSReadLine quality of life
if (Get-Module -ListAvailable -Name PSReadLine) {
  Set-PSReadLineOption -EditMode Windows -BellStyle None
}


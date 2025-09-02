@echo off
echo Starting Windows configuration export...
echo.

REM Update package lists
echo Updating Chocolatey package list...
choco list > apps\chocolatey-packages.txt 2>nul

echo Updating Winget package list...
winget list > apps\winget-packages.txt 2>nul

REM Run PowerShell export script
echo.
echo Running PowerShell settings export (requires admin for best results)...
powershell -ExecutionPolicy Bypass -File scripts\export-windows-settings.ps1

echo.
echo ========================================
echo Export complete! Check the following:
echo - apps\chocolatey-packages.txt
echo - apps\winget-packages.txt  
echo - configs\ folder for settings
echo ========================================
echo.
echo Next steps:
echo 1. Review docs\transition-checklist.md
echo 2. Check docs\windows-to-fedora-mapping.md for app alternatives
echo 3. Commit these changes to git
echo.
pause
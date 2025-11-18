@echo off
:: Batch file to run Chocolatey bulk install script as admin
:: Run as ADMIN and have both this bat file and the choco-prog-install.ps1 both on the desktop in order to function!

:: Path to your PowerShell script
set SCRIPT_PATH="C:\Users\Admin\Desktop\choco-prog-install.ps1"

:: Run PowerShell as administrator
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %SCRIPT_PATH%' -Verb RunAs"

pause

# ===============================================
# Smart Chocolatey Bulk Install Script
# ===============================================
# Run this script as Administrator.
# It installs all packages listed below using Chocolatey.

# In POWERSHELL Run: 
# Set-ExecutionPolicy Bypass -Scope Process -Force
# & "C:\User\Admin\Desktop\chocolatey-prog-install.ps1"

# ===============================================

# Ensure Chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not found. Installing..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# List of packages to install (duplicates removed)
$packages = @(
    "7zip",
    "filezilla",
    "audacity",
    "skype",
    "cpu-z",
    "vmwareworkstation",
    "firefox",
    "brave",
    "minecraft-launcher",
    "googlechrome",
    "vscode",
    "notepadplusplus",
    "vlc",
    "putty",
    "git",
    "docker-desktop",
    "docker-cli",
    "docker-engine",
    "office-tool",
    "thunderbird",
    "bitwarden",
    "gpg4win",
    "signal",
    "geforce-experience",
    "steam",
    "ubisoft-connect",
    "epicgameslauncher",
    "ea-app",
    "amazongames",
    "goggalaxy",
    "plexmediaplayer",
    "plexmediaserver",
    "discord",
    "filebot",
    "geekuninstaller",
    "exif-purge",
    "exiftool",
    "itunes",
    "zoom",
    "legacy-games-launcher",
    "rockstar-launcher",
    "anydesk",
    "coretemp",
    "hwinfo",
    "humble-app",
    "qbittorrent",
    "winscp",
    "icloud",
    "cryptomator",
    "github-desktop",
    "sublimetext3",
    "sublimetext4",
    "putty.install",
    "vim",
    "nano",
    "rainmeter",
    "obs",
    "handbrake",
    "calibre",
    "chirp",
    "hexchat",
    "ledger-live",
    "renamemytvseries2",
    "rpi-imager",
    "vnc-viewer",
    "vnc-connect",
    "windirstat",
    "crystaldiskinfo",
    "wamp-server",
    "exifdataview"
)

# Function to check if a package is already installed
function Is-PackageInstalled($name) {
    return (choco list --local-only | Select-String -Pattern "^\s*$name\s")
}

# Install missing packages
foreach ($pkg in $packages) {
    if (Is-PackageInstalled $pkg) {
        Write-Host "$pkg is already installed — skipping." -ForegroundColor Yellow
    } else {
        Write-Host "Installing $pkg..." -ForegroundColor Cyan
        choco install $pkg -y --no-progress
    }
}

# Optionally upgrade everything at the end
Write-Host "`nUpgrading all installed packages..." -ForegroundColor Green
choco upgrade all -y --no-progress

Write-Host "`n✅ All done! Your system is now fully set up." -ForegroundColor Green

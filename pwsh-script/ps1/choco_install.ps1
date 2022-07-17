# Release note Windows Terminal: https://github.com/microsoft/terminal/tags

# Download choco
Set-ExecutionPolicy Bypass -Scope Process -Force `
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 `
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Powershell v7: Import-Module Appx -UseWindowsPowershell
# Powershell v6:
Add-AppxPackage -Path .\Microsoft.WindowsTerminal_1.10.2383.0_8wekyb3d8bbwe.msixbundle

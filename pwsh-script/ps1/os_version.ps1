[System.Environment]::OSVersion.Version
[Environment]::OSVersion.Version -ge (New-Object 'Version' 6,1)
(Get-WmiObject -Class Win32_OperatingSystem).Caption

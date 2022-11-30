Get-Process | Where-Object { $_.WorkingSet -gt 10e3 } | Select-String -Pattern ".*tab.*"

Get-Process | Format-Table -View priority

Get-Process | ForEach-Object { Write-Host $_ }

# Retrieve all fields of an object in pwsh:
Get-Process | Select-Object -First 1 | Format-List | Out-String

Get-Process | Select-Object { $_.Name } | Select-String -Pattern ".*tab.*"
# Result:
# @{ $_.Name = TabNine}
# @{ $_.Name = WD-TabNine}

Get-Process | Select-Object { $_ } | findstr /i /c:"tab"
# Result:
# System.Diagnostics.Process (TabNine)
# System.Diagnostics.Process (WD-TabNine)

Get-Process | Select-Object { $_.Name } | findstr /i /c:"tab"

Get-Process code | Format-Table `
@{ Label = "NPM(K)"; Expression = { [int] ($_.NPM / 1024) } },
@{ Label = "PM(K)"; Expression = { [int] ($_.PM / 1024) } },
@{ Label = "WS(K)"; Expression = { [int] ($_.WS / 1024) } },
@{ Label = "VM(M)"; Expression = { [int] ($_.VM / 1MB) } },
@{ Label = "CPU(s)"; Expression = { if ($_.CPU) { $_.CPU.ToString("N") } } },
Id, MachineName, ProcessName -AutoSize
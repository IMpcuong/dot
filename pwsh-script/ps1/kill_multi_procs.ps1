# Resource: https://stackoverflow.com/questions/47335781/extract-columns-from-text-based-table-output

# NOTE: must run this script with administrator permissions in `Windows Powershell`.

# Solution1: Using `PSCustomObject` to extract only fileds/columns as you wished:
$procs = $(tasklist /fi "STATUS eq running" | findstr /i $args[0])

$procObjs = $($procs | ForEach-Object {
    [PSCustomObject] @{
      "Image" = $_.Substring(0, 25).Trim()
      "PID"   = $_.Substring(25, 9).Trim() -as [Int]
    }
  })

taskkill /f /im ($procObjs | Select-Object -First 1).Image

# FIXME: the condition statement is always return true, beacause of the `$procs || $procObjs` always have length greater than `0`.
if (0 -ne $procs.Length) {
  foreach ($proc in $procObjs) {
    <# $proc is current $procObjs item #>
    taskkill /f /pid $proc.PID
  }
}

# Solution2: Using `foreach` and string split to acquire the process/application's name: (`$args[0] ~= "vm"`)
# Pattern: `vmware.exe  97238  Console   1  68,123 K`
tasklist /fi "status eq running" | `
  findstr /i /c:"(${args[0]})" | `
  ForEach-Object { taskkill /f /im ($_ -split '\s+', 4)[0] } # --> The first positional argument `[0]` reproduce/imitate for process/application's name.

# Or:
tasklist /fi "status eq running" | `
  findstr /i /c:"(${args[0]})" | `
  ForEach-Object { taskkill /f /pid ($_ -split '\s+', 4)[2] }

Get-Process | Where { $_.Name -match ".*java.*" } | `
  ForEach-Object { taskkill /PID (Select-String -InputObject $_.ID -Pattern "\d+") /F }

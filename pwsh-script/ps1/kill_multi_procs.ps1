# Resource: https://stackoverflow.com/questions/47335781/extract-columns-from-text-based-table-output

# NOTE: must run this script with administrator permissions in `Windows Powershell`.

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
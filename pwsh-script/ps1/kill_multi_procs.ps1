# Resource: https://stackoverflow.com/questions/47335781/extract-columns-from-text-based-table-output

$procs = $(tasklist /fi "STATUS eq running" | findstr /i $args[0])

$procIDs = $($procs | ForEach-Object {
  [PSCustomObject] @{
    "PID" = $_.Substring(25, 9).Trim() -as [Int]
  }
})

foreach ($proc in $procIDs) {
  <# $id is current $pidList item #>
  taskkill /pid $proc.PID /f
}
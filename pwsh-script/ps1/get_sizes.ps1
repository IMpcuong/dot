Get-ChildItem -Path . -ErrorAction silentlycontinue -Recurse | `
  Sort-Object -Property length -Descending | `
  Format-Table -autosize -wrap -property `
@{ Label = "Last access"; Expression = { ($_.LastWriteTime).ToshortDateString() } },
@{ Label = "Size in MB"; Expression = { "{0:N2}" -f ($_.Length / 1MB) } },
fullname
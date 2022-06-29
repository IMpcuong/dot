$dockerProc = Get-Process "*docker desktop*"
if ($dockerProc.Count -gt 0) {
  $dockerProc[0].Kill()
}

Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
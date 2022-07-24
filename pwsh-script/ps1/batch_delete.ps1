# Convert String to Date time format.
# $dateRemove = [DateTime]::ParseExact($dateInput, $DATE_FORMAT, $null).ToString('M/dd/yyyy')

$CURRENT_PATH = '.'
$DATE_FORMAT = "M-d-yyyy"

# Run this whole script with administrator principal.
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$currentUserPrincipal = new-object System.Security.Principal.WindowsPrincipal($currentUser)
if (! $currentUserPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = $myInvocation.MyCommand.Definition;
  $newProcess.Verb = "runas";
  [System.Diagnostics.Process]::Start($newProcess);
  exit;
}

# Show menu of all available options.
function ShowMenu {
  param (
    [string]$Title = 'Available batch delete options'
  )
  Clear-Host
  Write-Host "===== $Title ====="
  Write-Host "Opt 1: Press '1' for input range of date."
  Write-Host "Opt 2: Press '2' for input specified date."
  Write-Host "Opt Q: Press 'Q' to quit."
  Write-Host "===== $Title ====="
}

# Delete all the old backup folders in specified date time range. All the files will be deleted forever
# and will not be moved in Recycle Bin so that means its not possible to restore.
function DeleteBatch {
  param (
    [string]$path,
    [dateTime]$startDate,
    [datetime]$endDate
  )
  Get-ChildItem $path -Recurse | `
    Where-Object { $_.LastWriteTime -ge $startDate -and $_.lastWriteTime -le $endDate } | `
    Remove-Item  -Recurse -Force
}

do {
  ShowMenu
  $selection = Read-Host "Choose a selection"
  switch ($selection) {
    '1' {
      $startDate = Read-Host "Enter start date (${DATE_FORMAT})"
      $dateStartRemove = Get-Date $startDate
      $endDate = Read-Host "Enter stop date (${DATE_FORMAT})"
      $dateStopRemove = Get-Date $endDate

      $startBatch = [System.DateTime]::Now
      Write-Output "Start at $startBatch"

      DeleteBatch $CURRENT_PATH $dateStartRemove $dateStopRemove

      $endBatch = [System.DateTime]::Now
      Write-Output "End at $endBatch"
    }
    '2' {
      $startDate = Read-Host "Enter specific date (${DATE_FORMAT})"
      $dateStartRemove = Get-Date $startDate
      $dateStopRemove = $dateStartRemove.AddDays(1)

      $startBatch = [System.DateTime]::Now
      Write-Output "Start at $startBatch"

      DeleteBatch $CURRENT_PATH $dateStartRemove $dateStopRemove

      $endBatch = [System.DateTime]::Now
      Write-Output "End at $endBatch"
    }
  }
}
until ($selection -eq 'q')

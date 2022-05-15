Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Restarting Docker"

foreach ($svc in (Get-Service | Where-Object { $_.Name -ilike "*docker*" -and $_.Status -ieq "Running" })) {
    $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
    $svc.WaitForStatus('Stopped', '00:00:20')
}

Get-Process | Where-Object { $_.Name -ilike "*docker*" } | Stop-Process -ErrorAction Continue -Confirm:$false -Force

foreach ($svc in (Get-Service | Where-Object { $_.Name -ilike "*docker*" -and $_.Status -ieq "Stopped" })) {
    $svc | Start-Service
    $svc.WaitForStatus('Running', '00:00:20')
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Starting Docker Desktop"
& "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$startTimeout - [DateTime]::Now.AddSeconds(90)
$hitTimeout = $true
while ((Get-Date) -le $startTimeout) {
    Start-Sleep -Seconds 10
    $ErrorActionPreference = 'Continue'

    try {
        $info = (docker info)
        Write-Verbose "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info executed. Is Error? : $($info -ilike "*error*"). Result was: $info"

        if ($info -ilike "*error*") {
            Write-Verbose "$((Get-Date).ToString("HH:mm:ss")) - `tDocker info had an error. throwing..."
            throw "Error running info command $info"
        }
        $hitTimeout = $false
        break
    }
    catch {
        if (($_ -ilike "*error during connect*") -or ($_ -ilike "*errors pretty printing info*") -or ($_ -ilike "*Error running info command*")) {
            Write-Output "$((Get-Date).ToString("HH:mm:ss")) -`t Docker Desktop startup not yet completed, waiting and checking again"
        }
        else {
            Write-Output "Unexpected Error: `n $_"
            return
        }
        $ErrorActionPreference = 'Stop'
    }
}
if ($hitTimeout -eq $true) {
    throw "Timeout hit waiting for Docker to startup"
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker restarted"

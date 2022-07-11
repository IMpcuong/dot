# --------- Util functions ---------

# Touch folder and go to this folder
# NOTE: mkdir === md
Function mdg {
  mkdir $args[0]
  Set-Location $args[0]
}

# New multiple folders
Function mdirs {
  for ( $i = 0; $i -lt $args.count; $i++ ) {
    mkdir $args[$i]
  }
}

# New multiple files
Function mfs {
  for ( $i = 0; $i -lt $args.count; $i++ ) {
    touch $args[$i]
  }
}

# Remove node_modules/*
Function rmnode {
  Remove-Item .\node_modules\ -Recurse -Force
}

# Copy all
Function cpa {
  Copy-Item -Path $args[0] -Destination $args[1] -Recurse
}

# Measure total items in the current directory
Function count {
  $curDir = Get-Location
  Write-Host "Total items in ${curDir} is" (Get-ChildItem $args[0] | Measure-Object).Count -ForegroundColor Green
}

# Reload profile in PowerShell enviroment
Function reload {
  # @() := create an array
  # %   := alias ForEach-Object
  @(
    $PROFILE.AllUsersAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.CurrentUserCurrentHost
  ) | ForEach-Object {
    # $_ := refers to the current item in the pipeline.
    if (Test-Path $_) {
      Write-Verbose "Running $_"
      . $_
    }
  }
}

# Get total disk usage of the current directory in human-readable mode
Function size {
  param(
    [string]$path
  )
  Write-Host -NoNewline "The size of the given path $path is: "
  $defaultSize = (Get-Item -Path $path | Get-ChildItem | Measure-Object -Sum Length).Sum
  switch -Regex ([math]::truncate([math]::log($defaultSize, 1024))) {
    '^0' { "$defaultSize Bytes" }
    '^1' { "{0:n2} KB" -f ($defaultSize / 1KB) }
    '^2' { "{0:n2} MB" -f ($defaultSize / 1MB) }
    '^3' { "{0:n2} GB" -f ($defaultSize / 1GB) }
    '^4' { "{0:n2} TB" -f ($defaultSize / 1TB) }
    Default { "{0:n2} PB" -f ($defaultSize / 1PB) }
  }
}

# Remove multiple items from the current directory
Function rms {
  for ( $i = 0; $i -lt $args.count; $i++ ) {
    Remove-Item $args[$i]
  }
}

# Invocate absolute path for the given application or command.
Function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Get the created date of an external repository on GitHub
# require: scoop, curl, rip-grep
Function crepo {
  param(
    [string]$username,
    [string]$repo
  )
  Write-Host -NoNewline "Created date of this repository on GitHub is: "

  # NOTE: `curl` == `Invoke-WebRequest`
  Invoke-WebRequest -s "https://api.github.com/repos/${username}/${repo}" | rg 'created_at' |
  ForEach-Object { $_.split(": ")[1] -replace '([",])', '' }

  if (-not $?) {
    <# Action to perform if the condition is true #>
    (Invoke-WebRequest -useb "https://api.github.com/repos/${username}/${repo}" |
    Select-Object -ExpandProperty Content | ConvertFrom-Json).created_at
  }
}

# Get the list details of the given command or function.
Function details {
  param(
    [string]$cmd
  )
  Get-Command $cmd -ErrorAction SilentlyContinue | Format-List *
}

# Synchronize multiple remote forked repositories on GitHub.
Function syncFork {
  param(
    [string]$username
  )
  $forkedRepo = $(gh repo list | findstr "fork" | ForEach-Object {
      $_ -split "\s{1}"
    } | Select-String -Pattern "${username}/.+"
  )
  foreach ($repo in $forkedRepo) {
    gh repo sync $repo
  }
}

# Check the current version of the PowerShell interpreter.
# Global variable: $Host === Get-Host
Function version {
  $core = $PSEdition
  if (-not ($core -eq 'core')) {
    Write-Host -NoNewLine "This PowerShell version is not the core version!" -ForegroundColor Green
  }

  Write-Host -NoNewLine "PowerShell version: " (Get-Host).version
  if (-not $?) {
    Write-Host -NoNewLine "PowerShell version: " $PSVersionTable.PSversion
  }
}

# Print help information of the given command input.
Function man {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $cmd
  )
  Get-Help -Name $cmd -Examples
}

# Counting the position of the given commit's hash.
Function commitRebase {
  param (
    [string]$fullHash
  )
  $posRebase = 1
  $commits = @(git rev-list HEAD)
  # Exp looping through array with `$PSItem` builtin variable: `$listCommits | ForEach-Object {"Item: [$PSItem]"}`
  for ($i = 0; $i -lt $commits.Count; $i++) {
    <# Action that will repeat until the condition is met #>
    if ($fullHash -eq $commits[$i]) {
      $posRebase += $i
    }
  }
  git rebase -i HEAD~$posRebase
}

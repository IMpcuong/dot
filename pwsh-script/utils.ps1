# --------- Util functions ---------
# touch folder and go to this folder
# NOTE: mkdir === md
Function mdg {
  mkdir $args[0]
  cd $args[0]
}

# new multiple folders
Function mdirs {
  for ( $i = 0; $i -lt $args.count; $i++ ) {
    mkdir $args[$i]
  }
}

# new multiple files
Function mfs {
  for ( $i = 0; $i -lt $args.count; $i++ ) {
    touch $args[$i]
  }
}

# remove node_modules
Function rmnode {
  Remove-Item .\node_modules\ -Recurse -Force
}

# copy all
Function cpa {
  Copy-Item -Path $args[0] -Destination $args[1] -Recurse
}

# measure total items in the current directory
Function count {
  $curDir = Get-Location
  Write-Host "Total items in ${curDir} is" (Get-ChildItem $args[0] | Measure-Object).Count
}

# reload profile in PowerShell enviroment
Function reload {
  # @() := create an array
  # %   := alias ForEach-Object
  @(
    $PROFILE.AllUsersAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.CurrentUserCurrentHost
  ) | % {
    # $_ := refers to the current item in the pipeline.
    if(Test-Path $_) {
      Write-Verbose "Running $_"
      . $_
    }
  }
}

# get total disk usage of the current directory
Function size {
    param(
        [string]$path
    )
    Get-Item -Path $path | Get-ChildItem | Measure-Object -Sum Length
}

# remove multiple items from the current directory
Function rms {
  for ( $i = 0; $i -lt $args.count; $i++ ) {
    Remove-Item $args[$i]
  }
}

# invocate absolut path for the given application or command.
Function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# get the created date of an eternal repository on GitHub
# require: scoop, curl, rip-grep
Function crepo {
  param(
    [string]$username,
    [string]$repo
  )
  Write-Host -NoNewline "Created date of this repository on GitHub is: "
  curl -s "https://api.github.com/repos/${username}/${repo}" | rg 'created_at' |
  ForEach-Object { $_.split(": ")[1] -replace '([",])', '' }
}

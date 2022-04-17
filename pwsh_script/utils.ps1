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

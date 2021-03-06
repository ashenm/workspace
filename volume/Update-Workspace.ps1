<#

  Update Workspace Facilitator Scripts
  https://github.com/ashenm/workspace

  Ashen Gunaratne
  mail@ashenm.ml

#>

# exit on first error
$ErrorActionPreference = "Stop"

# use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12

# POSIX time
# ignore cached versions of updater script
$STAMP = Get-Date -UFormat %s

# fetch latest updater script
Invoke-WebRequest -UseBasicParsing -OutFile $env:TEMP\Update-Workspace-$STAMP.ps1 -Uri https://raw.githubusercontent.com/ashenm/workspace/master/workspace/Update-Workspace

# update system
Start-Process -WindowStyle Normal -WorkingDirectory $PSScriptRoot -FilePath PowerShell -ArgumentList "-File", "$env:TEMP\Update-Workspace-$STAMP.ps1", "-ExecutionPolicy", "Unrestricted"

# vim: set expandtab shiftwidth=2 syntax=powershell:

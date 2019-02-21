<#

  Update Workspace Facilitator Scripts
  https://github.com/ashenm/workspace

  Ashen Gunaratne
  mail@ashenm.ml

#>

Invoke-WebRequest -UseBasicParsing -OutFile workspace.cmd `
  -Uri https://raw.githubusercontent.com/ashenm/workspace/master/workspace/workspace.cmd
Invoke-WebRequest -UseBasicParsing -OutFile backup.sh `
  -Uri https://raw.githubusercontent.com/ashenm/workspace/master/workspace/backup.sh
Invoke-WebRequest -UseBasicParsing -OutFile push.sh `
  -Uri https://raw.githubusercontent.com/ashenm/workspace/master/workspace/push.sh

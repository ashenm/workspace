@ECHO OFF
@REM Workspace
@REM Workspace Docker Volume Facilitator

:: create workspace
:: create docker volume
IF /I "%1"=="create" (
  START /B /WAIT docker volume create --driver local workspace
  EXIT /B %ERRORLEVEL%
)

:: backup workspace
:: create archive file
IF /I "%1"=="backup" (
  START /B /WAIT docker run --rm --interactive --tty ^
    --volume workspace:/mnt/workspace:ro --volume %~dp0:/opt/workspace:ro ^
    --volume %CD%:/mnt/backup --workdir /mnt/backup ubuntu bash /opt/workspace/backup.sh
  EXIT /B %ERRORLEVEL%
)

:: update workspace
:: copy current folder
IF /I "%1"=="push" (
  START /B /WAIT docker run --rm --interactive --tty ^
    --volume %CD%:/mnt/push --volume workspace:/mnt/workspace ^
    --volume %~dp0:/opt/workspace:ro --env WORKSPACE=%CD% ^
    --workdir /mnt/push ubuntu bash /opt/workspace/push.sh
  EXIT /B %ERRORLEVEL%
)

:: delete workspace
:: delete docker volume
IF /I "%1"=="delete" (
  START /B /WAIT docker volume rm --force workspace
  EXIT /B %ERRORLEVEL%
)

:: update scripts
:: retrieve latest script files
IF /I "%1"=="update" (
  START /MIN /D %~dp0 PowerShell -ExecutionPolicy Unrestricted -File "%~dp0Update-Workspace.ps1"
  EXIT /B %ERRORLEVEL%
)

ECHO:
ECHO Usage: %0 COMMAND
ECHO Administer Workspace Docker Volume
ECHO:
ECHO Command:
ECHO   create                    Create a local docker volume
ECHO   backup                    Archive docker volume to a tarball
ECHO   delete                    Delete docker volume
ECHO   push                      Copy current folder to docker volume
ECHO   update                    Update Facilitator Scripts

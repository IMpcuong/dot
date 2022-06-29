@echo off
setlocal
setlocal EnableExtensions
setlocal EnableDelayedExpansion

set me=%~n0
set parent=%~dp0

call :InitMacro %$set% ipOutput="ipconfig"

echo First line is %ipOutput[0]%
@REM call :ShowVariable ipOutput

@REM echo(
@REM   :InitMacro
@REM   %$set% driveNames="wmic logicaldisk get name /value | findstr "Name""
@REM   call :ShowVariable driveNames

@REM   :ShowVariable
@REM   for /L %%n in (0 1 !%~1.max!) do (
@REM       echo %%n: !%~1[%%n]!
@REM   )
@REM )

@REM endlocal
@REM exit /b
@REM goto :eof
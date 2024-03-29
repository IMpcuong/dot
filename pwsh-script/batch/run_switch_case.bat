@echo off

@REM First switch-case method:

@REM java -jar sync-bundle.jar -c config.properties -json param.json
@REM java -jar sync-1.0.jar -c config.properties -json param.json
@REM java -jar sync-1.0.jar -c config.properties -param param.json

echo Input number 1 or 2 to run specific command.

set /P N=Enter number to choose option:

:switch-command

  @REM if "%N%"=="" (
  @REM   java -jar sync-bundle.jar -env dev -json param.json
  @REM )

  :: Call and mask out invalid call/input targets.
  goto :case-%N% 2>nul || (
    :: Default case.
    java -jar sync-bundle.jar -env dev -fromDate 20211001 -toDate 20211101
  )
  goto :end-switch

  :case-1
    :: Datetime pattern/formatter = `yyyyMMdd`.
    java -jar sync-bundle.jar -env dev -fromDate 20211001 -toDate 20211101
    goto :end-switch

  :case-2
    java -jar sync-bundle.jar -env dev -json param.json
    goto :end-switch

  :case-3
    echo Test.
    goto :end-switch

:end-switch

echo End this prompt.

@REM Second switch-case method:

@REM https://stackoverflow.com/questions/18423443/switch-statement-equivalent-in-windows-batch-file

SET /p ENV="Enter which cloud environment you want to deploy (uat, prod): "

2>NUL CALL :CASE_%ENV%
IF ERRORLEVEL 1 CALL :DEFAULT_CASE

ECHO Done.
EXIT /B

:CASE_uat
  sam build -t .\template.yaml && sam deploy --config-file .\config-uat.toml --config-env uat --debug
  GOTO END_CASE
:CASE_prod
  sam build -t .\template.yaml && sam deploy --config-file .\config-prod.toml --config-env prod --debug
  GOTO END_CASE
:DEFAULT_CASE
  ECHO Unknown environment "%ENV%"
  GOTO END_CASE
:END_CASE
  VER > NUL
  GOTO :EOF
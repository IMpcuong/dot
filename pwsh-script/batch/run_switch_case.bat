@echo off

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
@echo off

if "%OS%"=="Windows_NT" or "%OS%"=="" setlocal

REM all variables defined local
REM set DBG=echo to debug this script

set DBG=REM
set nextarg=
set rslvarg=
set javaprops=
set args=
set jreclasspath="E:\App\Java\jdk\jre\lib\rt.jar;E:\App\Java\jdbc\lib\ojdbc.jar"

:LOOP
%DBG% LOOP-%CNT% (loop for args parsing)
  set /a CNT+=1
  set nextarg=%1
  set nextarg=%nextarg:"=%
  if {%1} == {} goto MARK6
  if {%1} == {-classpath} goto MARK1
  if {%1} == {-addclasspath} goto MARK2
  if "%nextarg%" == "-resolver" goto MARK4
  if "%nextarg%" == "-R" goto MARK4
  if "%nextarg%" == "-u" goto MARK11
  if "%nextarg%" == "-user" goto MARK11
  if "%nextarg:~0,2%" == "-P" goto MARK10
  if "%nextarg%" == "-password" goto MARK10
  if "%nextarg:~0,2%" == "-D" goto MARK5
  if "%nextarg%" == "-debug" goto MARK12
    set args=%args% %1
    %DBG% %args%
    shift
    goto LOOP

:MARK1
%DBG% MARK1 hit (-classpath)
  set CLASSPATH=%2
  set CLASSPATH=%CLASSPATH:"=%
  shift
  shift
  goto LOOP

:MARK2
%DBG% MARK2 hit (first -addclasspath)
  if not "%addclasspath%"=="" goto MARK3
    set addclasspath=%2
    set addclasspath=%addclasspath:"=%
    shift
    shift
    goto LOOP

:MARK3
%DBG% MARK3 hit (additional -addclasspath)
  set nextarg=%2
  set addclasspath=%addclasspath%;%nextarg:"=%
  shift
  shift
  goto LOOP

:MARK4
%DBG% MARK4 hit (-resolver)
  set RESOLVER=%1
  set rslvarg=%2
  set rslvarg=%rslvarg:"=%
  set RESOLVER=%RESOLVER% %rslvarg%
  shift
  shift
  goto LOOP

:MARK5
%DBG% MARK5 hit (-Djavaprop=prop)
  set javaprops=%javaprops% %1=%2
  set javaprops=%javaprops:"=%
  shift
  shift
  goto LOOP

:MARK10
%DBG% MARK10 hit (-P or -password)
  set LJPASS=%1
  set LJPASS=%LJPASS:"=%
  set LJPASS=%LJPASS% %2
  shift
  shift
  goto LOOP

:MARK11
%DBG% MARK11 hit (-u)
  set LJUSER=%1 %2
  set LJUSER=%LJUSER:\=%
  shift
  shift
  goto LOOP

:MARK12
%DBG% MARK12 hit (-debug)
REM debug requires the use of the jdbc debug jar
  set jreclasspath="E:\App\Java\jdk\jre\lib\rt.jar;E:\App\Java\jdbc\lib\ojdbc.jar"
  set args=%args% %1
  shift
  goto LOOP

:MARK6
%DBG% MARK6 hit (append classpath)
  if "%CLASSPATH%"=="" goto MARK7
    set jreclasspath="%jreclasspath%;%CLASSPATH%"
    set jreclasspath="%jreclasspath:"=%"

:MARK7
%DBG% MARK7 hit (append addclasspath)
  if "%addclasspath%"=="" goto MARK8
    set jreclasspath="%jreclasspath%;%addclasspath%"
    set jreclasspath="%jreclasspath:"=%"

:MARK8
%DBG% MARK8 hit (invoke loadjava)
%DBG% *** CLASSPATH = %CLASSPATH% ***
%DBG% *** addclasspath = %addclasspath% ***
%DBG% *** jreclasspath = %jreclasspath% ***
%DBG% *** javaprops = %javaprops% ***
%DBG% *** rslvarg = %rslvarg% ***
%DBG% *** args = %args% ***
%DBG% *** LJPASS = %LJPASS% ***
%DBG% *** LJUSER = %LJUSER% ***
%DBG% *** RESOLVER = %RESOLVER% ***

"E:\App\Java\jdk\jre\bin\java" %javaprops% -classpath %jreclasspath% oracle.aurora.server.tools.loadjava.LoadJavaMain %args%
if "%OS%" == "Windows_NT" endlocals
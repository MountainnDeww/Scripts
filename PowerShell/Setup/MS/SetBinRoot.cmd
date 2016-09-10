@echo off
@powershell -executionpolicy unrestricted -file %~dpn0.ps1 %*
set LASTERROR=%ERRORLEVEL%
for /f "skip=2 tokens=3" %%v in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v TESTBINROOT') do set TESTBINROOT=%%v
if not "%TESTBINROOT%" == "" echo Environment variable TESTBINROOT set in current environment.
if %ERRORLEVEL% == 0 set ERRORLEVEL=%LASTERROR%
set LASTERROR=%ERRORLEVEL%
for /f "skip=2 tokens=3" %%v in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v OSBINROOT') do set OSBINROOT=%%v
if not "%OSBINROOT%" == "" echo Environment variable OSBINROOT set in current environment.
if %ERRORLEVEL% == 0 set ERRORLEVEL=%LASTERROR%
set LASTERROR=
@echo.
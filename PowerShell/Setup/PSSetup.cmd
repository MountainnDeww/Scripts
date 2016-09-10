@ECHO OFF

::TEST
:: @PowerShell.exe Set-ExecutionPolicy RemoteSigned
:: @PowerShell.exe Set-ExecutionPolicy Restricted
:: @PowerShell.exe Get-ExecutionPolicy

:: Set Powershell Execution Policy to RemoteSigned in order to have access to run scripts
@PowerShell.exe Set-ExecutionPolicy RemoteSigned -Force

IF /I "%1"=="-Clean" (
    @PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -Clean
) ELSE (
    @PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -Reset
)
IF ERRORLEVEL 1 GOTO :EXIT
IF ERRORLEVEL 0 @Start PowerShell.exe
GOTO :EOF

:EXIT
ECHO ERRORLEVEL %ERRORLEVEL%

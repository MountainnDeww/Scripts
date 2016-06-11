@ECHO OFF
CALL KillApps.cmd -Apps "winword.exe","excel.exe"
::@PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dp0\KillApps.ps1 -Debug -Apps "winword.exe","excel.exe"
::@PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -Debug
@ECHO.
IF NOT ERRORLEVEL 0 @PAUSE

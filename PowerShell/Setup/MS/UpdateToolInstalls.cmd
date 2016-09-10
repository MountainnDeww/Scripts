@ECHO OFF
IF /I "%1"=="-AccChecker" (
  @PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -AccChecker
) ELSE (
  @PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1
)
IF ERRORLEVEL 1 PAUSE
IF ERRORLEVEL 0 @Start PowerShell.exe
EXIT

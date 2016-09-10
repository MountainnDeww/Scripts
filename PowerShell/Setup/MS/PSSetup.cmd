@ECHO OFF
IF /I "%1"=="-Clean" (
  @PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -Clean
) ELSE (
  @PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -Reset
)
IF ERRORLEVEL 1 PAUSE
IF ERRORLEVEL 0 @Start PowerShell.exe
::EXIT
::PAUSE
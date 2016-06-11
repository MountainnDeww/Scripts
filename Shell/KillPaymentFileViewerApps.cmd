@ECHO OFF
CALL KillApps.cmd -Apps "PaymentFileViewer.exe"
@ECHO.
IF NOT ERRORLEVEL 0 @PAUSE

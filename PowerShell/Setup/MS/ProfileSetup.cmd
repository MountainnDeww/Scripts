@echo off
@PowerShell.exe -ExecutionPolicy RemoteSigned -File %~dpn0.ps1 -Reset
@Start PowerShell.exe
exit

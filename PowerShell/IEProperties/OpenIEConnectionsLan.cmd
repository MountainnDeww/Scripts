@echo off
@powershell -executionpolicy remotesigned -file %~dpn0.ps1
::@Pause
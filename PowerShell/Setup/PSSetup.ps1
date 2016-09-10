<#
	.SYNOPSIS
		Setup Powershell and Command shell

	.DESCRIPTION
		This script setups the shell environments for the local machine

	.PARAMETER -Clean
		True/False switch. 
		Used to remove the profiles and registry entries

	.PARAMETER -Reset
		True/False switch. 
		Used to reset the profiles and registry entries

	.PARAMETER -Debug
		True/False switch. 
		Used to print out debug statements during the script

	.PARAMETER -NoBin
		True/False switch. 
		Used to 

	.PARAMETER -Desktoplinks
		True/False switch. 
		Used to 

	.PARAMETER -ETW
		True/False switch. 
		Used to 

	.PARAMETER -TE
		True/False switch. 
		Used to 

	.PARAMETER -BuildType
		String. Used to supply the desired build type. 
		i.e. 'fre' or 'chk'. 
		Default is 'fre'.

	.INPUTS
		None.

	.OUTPUTS
		None.

	.EXAMPLE
		ShellSetup.ps1 -Reset

	.NOTES
		Script          : PSSetup.ps1
		Version         : 1.0
		Author          : Norm Hall
		Email           : normh@microsoft.com, halln77@hotmail.com
		Creation Date   : January 18, 2013
		Purpose/Change  : Initial release
		Comment         :        
	#>

#[CmdletBinding()]

Param (
	[Switch] $DesktopLinks,
	[Switch] $Debug,
	[Switch] $Clean,
	[Switch] $Reset
)

#Function DeleteFiles
#{
#    $FileArray = Get-ChildItem -Path ".\*Deploy*.cmd"
#    DeleteFile $FileArray
#}

#Function DeleteFile ($FileArray)
#{
#    If ($FileArray.Length -gt 0)
#    {
#        ForEach ($File In $FileArray)
#        {
#            If (Test-Path $File) { Remove-Item -Path $File -Force }
#        }
#    }
#}

# Set the machines execution policy
# https://msdn.microsoft.com/en-us/library/microsoft.powershell.executionpolicy(v=vs.85).aspx
If ((Get-ExecutionPolicy) -ne "RemoteSigned")
{
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
}
#Get-ExecutionPolicy

# Set the current location to this scripts folder
Set-Location (Split-Path $PSCommandPath)

# Create the PS Profiles
If ($Clean) 
{
	& .\CleanPowerShell.ps1
	& .\ProfileSetup.ps1 -Clean
	Import-Module Common -DisableNameChecking
}
ElseIf ($Reset)
{
	& .\ProfileSetup.ps1 -Reset
}

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

# Setup the CMD Shell
#& reg add "hkcu\Console" /v InsertMode /t REG_DWORD /d 0x00000001 /f | Out-Null
#& reg add "hkcu\Console" /v QuickEdit /t REG_DWORD /d 0x00000001 /f | Out-Null
#& reg add "hkcu\Console" /v ScreenBufferSize /t REG_DWORD /d 0x270f0078 /f | Out-Null
#& reg add "hkcu\Console" /v WindowSize /t REG_DWORD /d 0x280078 /f | Out-Null

# Setup cmd shortcuts
#& .\CopyCmdShortcuts.ps1

# Update Command Prompt Defaults
#& .\ChangeCommandPromptDefaults.ps1

# Cleanup
#DeleteFiles

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

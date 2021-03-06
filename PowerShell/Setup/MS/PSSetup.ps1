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
#    [String] $BuildType,
    [Switch] $DesktopLinks,
    [Switch] $Debug,
#    [Switch] $NoBin,
#    [Switch] $ETW,
#    [Switch] $TE,
    [Switch] $Clean,
    [Switch] $Reset
)

#Function TE_Service
#{
#    If (Test-Path "%OSBINROOT%\wextest\CuE\TestExecution\TEServiceInstall.cmd")
#    {
#        & $OsBinRoot\wextest\CuE\TestExecution\TEServiceInstall.cmd
#    }
#}

#Function TE_ETW_Service_Setup
#{
#    If ( Test-Path "\\ae-share\public\EFE\Test\TestScripts\TE-ETW_ServiceSetup.cmd" )
#    {
#        & \\ae-share\public\EFE\Test\TestScripts\TE-ETW_ServiceSetup.cmd
#    }
#}

Function DeleteFiles
{
    $FileArray = Get-ChildItem -Path ".\*Deploy*.cmd"
    DeleteFile $FileArray
}

Function DeleteFile ($FileArray)
{
    If ($FileArray.Length -gt 0)
    {
        ForEach ($File In $FileArray)
        {
            If (Test-Path $File) { Remove-Item -Path $File -Force }
        }
    }
}

# Set the machines execution policy
If ((Get-ExecutionPolicy) -ne "RemoteSigned")
{
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
}

# Set the current location to this scripts folder
Set-Location (Split-Path $PSCommandPath)

# Default BuildType
#If (($BuildType -ne "fre") -and ($BuildType -ne "chk")) { $BuildType = "fre" }

# Get latest SB_WCC_DEV build number
#ForEach($Line In (Get-Content -Path "\\winbuilds\release\wws\SB_WCC_DEV\drop\build.latest"))
#{
#	$Temp = $Line -split ": "
#	If ($Temp[0] -eq "Build Number")
#	{
#		$BuildNumber = $Temp[1]
#	}
#}

# Set the Bin and Test roots
#& .\SetBinRoot.ps1 -TestBinRoot "\\winbuilds\release\wws\SB_WCC_DEV\drop\$BuildNumber\debug\amd64\acdc\"

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
& reg add "hkcu\Console" /v InsertMode /t REG_DWORD /d 0x00000001 /f | Out-Null
& reg add "hkcu\Console" /v QuickEdit /t REG_DWORD /d 0x00000001 /f | Out-Null
& reg add "hkcu\Console" /v ScreenBufferSize /t REG_DWORD /d 0x270f0078 /f | Out-Null
& reg add "hkcu\Console" /v WindowSize /t REG_DWORD /d 0x280078 /f | Out-Null

# Copy Command Tools
#If ( $OsBinRoot ) { & .\UpdateTools.ps1 }

# Setup cmd shortcuts
#& .\CopyCmdShortcuts.ps1

# Copy Links to Desktop 
#& .\CopyLinksToDesktop.ps1

# Update Command Prompt Defaults
#& .\ChangeCommandPromptDefaults.ps1

# Setup TE and ETW Services
#IF ($ETW) { TE_ETW_Service_Setup }
#IF ($TE) { TE_ETW_Service_Setup }

# Cleanup
DeleteFiles

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

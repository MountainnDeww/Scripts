<# TestTestTest
    .SYNOPSIS
        To import modules and create profiles.

    .DESCRIPTION
        ProfileSetup.ps1 is used to import modules and to create all of the 
        powershell profiles so that desired modules will be imported each time 
        a powershell window is launched.

    .PARAMETER Clean
        Used to delete all user and system profiles.

    .PARAMETER Reset
        Used to delete and re-create all user and system profiles .

    .EXAMPLE
        ProfileSetup.ps1

    .EXAMPLE
        ProfileSetup.ps1 -Clean

    .EXAMPLE
        ProfileSetup.ps1 -Reset

    .NOTES
        Script:         ProfileSetup.ps1
        Version: 		    1.0
        Author:         Norm Hall
        Email:          halln77@hotmail.com
        Creation Date:  January 18, 2013
        Purpose/Change: Initial release
        Change Date:    May 15, 2013
        Purpose/Change: Update Profile Text
        Comment:        
#>

#[CmdletBinding()]

Param (
    [Switch] $Clean,
    [Switch] $Reset
)


# Clean the profile
# Deletes all existing profiles
Function CleanProfile ([String[]] $ProfileArray = $Script:ProfileArray)
{
    If (Test-Path $Profile.AllUsersAllHosts) 
    {
        Write-Host; Write-Host "Removing Profile(s) ..."
        foreach ($Item In $ProfileArray)
        {
            If ((Test-Path $Item))
            {
                Remove-Item $Item
                If (!(Test-Path $Item)) { Write-Host "Removed" $Item }
            }
        }
    }
 }

# Reset the profile.
# Deletes all existing profiles and re-creates them
Function ResetProfile ([String[]] $ProfileArray = $Script:ProfileArray)
{
    CleanProfile $ProfileArray

    CreateNewProfile $ProfileArray
}

# Open all profiles for viewing
Function OpenProfile([String[]] $ProfileArray = $Script:ProfileArray)
{
    foreach ($Item In $ProfileArray)
    {
        If ((Test-Path $Item))
        {
            notepad.exe $Item
        }
        else
        {
            Write-Host "Item Does not exist" $Item 
        }
    }
}

# Create a new profile using the following Aliases, Functions, and Variables
Function CreateNewProfile([String[]] $ProfileArray = $Script:ProfileArray)
{
    Write-Host; Write-Host "Creating New Profile(s) ..."

    If (!(Test-Path $Profile.AllUsersAllHosts)) { New-Item -Type File -Path $Profile.AllUsersAllHosts -Force | Out-Null }

$AUAH = $Profile.AllUsersAllHosts

$ProfileText = @"
# This Profile: $AUAH

# `$Profile.AllUsersAllHosts
#  x64 - $Env:windir\system32\WindowsPowerShell\v1.0\profile.ps1
#  x86 - $Env:windir\sysWOW64\WindowsPowerShell\v1.0\profile.ps1

# `$Profile.AllUsersCurrentHost
# x64 Console - $Env:windir\system32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
# x86 Console - $Env:windir\sysWOW64\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
# x64 ISE     - $Env:windir\system32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1
# x86 ISE     - $Env:windir\sysWOW64\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1
# x64 VSCode  - $Env:windir\system32\WindowsPowerShell\v1.0\Microsoft.VSCode_profile.ps1

# `$Profile.CurrentUserAllHosts
# $Env:UserProfile\Documents\WindowsPowerShell\profile.ps1

# `$Profile.CurrentUserCurrentHost
# Console - $Env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# ISE     - $Env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1
# VSCode  - $Env:UserProfile\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1

#Write-Host "This Profile: $AUAH"

`$Global:PSOriginalUserModules = `"$PSModules`"
`$Global:PSSetupScripts = `"$PSSetupScripts`"


################
# Set Security #
################

If ((Get-ExecutionPolicy) -ne "RemoteSigned") { Set-ExecutionPolicy RemoteSigned }
If ((Get-ExecutionPolicy -Scope CurrentUser) -ne "RemoteSigned") { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser }

################
# Load Modules #
################

#Write-Host "Installing Locations Module"
Import-Module Locations -Force -Global -DisableNameChecking
#Write-Host "Installing Shares Module"
Import-Module Shares -Force -Global -DisableNameChecking
#Write-Host "Installing URLs Module"
Import-Module URLs -Force -Global -DisableNameChecking
#Write-Host "Installing Common Module"
Import-Module Common -Force -Global -DisableNameChecking
#Write-Host "Installing Environment Module"
Import-Module Environment -Force -Global -DisableNameChecking
#Write-Host "Installing Normh Module"
Import-Module Normh -Force -Global -DisableNameChecking

#Write-Host "Setting Load Path: PSUserModulePath"
Set-LoadPSModulePath(`$PSUserModulePath)
#Write-Host "Setting Load Path: PSWindowsModulePath"
Set-LoadPSModulePath(`$PSWindowsModulePath)
#Write-Host "Setting Load Path: PSScriptsModulePath"
Set-LoadPSModulePath(`$PSScriptsModulePath)

##################
# Export Aliases #
##################

Export-Alias -Path `$PSDir\AliasScript.ps1 -As Script
Export-Alias -Path `$PSDir\AliasCSV.ps1 -As CSV

##################
# Launch GitHub  #
##################

C:\Users\Norman\AppData\Local\GitHub\GitHub.appref-ms
Write-Host "GitHub Enabled"

If (`$PWD -ne `$PSScripts) { Set-Location `$PSScripts }

Write-Host 
"@
  
    Write-ToProfile $Profile.AllUsersAllHosts $ProfileText
    
    Write-Host "Created" $Profile.AllUsersAllHosts

    ForEach ($Item In $ProfileArray)
    {
        If (!(Test-Path $Item))
        {
            New-Item -Type File -Path $Item -Force | Out-Null
            Copy-Item -Path $Profile -Destination $Item
            If (Test-Path $Item) { Write-Host "Created" $Item }
        }
    }
}

# Copy Modules
Function Copy-Modules
{
    Write-Host "Copying Modules"; Write-Host

    If (!(Test-Path $PSUserModulePath)) { New-Item -Type Directory -Path $PSUserModulePath  | Out-Null }

    Foreach ( $Item In Get-ChildItem $PSModules )
    {
        If ( $Item.GetType().ToString() -eq "System.IO.DirectoryInfo" )
        {
            $NewPath = Join-Path $PSUserModulePath $Item.Name

            If (!(Test-Path $NewPath)) { New-Item -Type Directory -Path $NewPath  | Out-Null }

            Foreach ( $SubItem In Get-ChildItem $Item.FullName )
            {
                If ( $SubItem.GetType().ToString() -eq "System.IO.FileInfo" )
                {
                    Copy-Item -LiteralPath $SubItem.FullName -Destination $NewPath -Force
                    Foreach ( $NewItem In Get-ChildItem $NewPath )
                    {
                        Write-Host $NewItem.FullName
                    }
                }
            }
        }
    }

    Write-Host
}

# Load Modules
Function Load-Modules
{
   ##############################
   #.SYNOPSIS
   #Short description
   #
   #.DESCRIPTION
   #Long description
   #
   #.EXAMPLE
   #An example
   #
   #.NOTES
   #General notes
   ##############################Write-Host "Loading Modules"; Write-Host

    Import-Module Common -Force -Global -DisableNameChecking
    #Import-Module PSEnv -Force -Global -DisableNameChecking
    Import-Module Locations -Force -Global -DisableNameChecking
    #Import-Module SHEnv -Force -Global -DisableNameChecking
    Import-Module Environment -Force -Global -DisableNameChecking
    Import-Module Normh -Force -Global -DisableNameChecking
    Import-Module Shares -Force -Global -DisableNameChecking
    Import-Module URLs -Force -Global -DisableNameChecking
}

# Unload Modules
Function Unload-Modules
{
    #Write-Host "Unloading Modules"; Write-Host

    Remove-Module URLs -Force
    Remove-Module Shares -Force
    Remove-Module Normh -Force
    #Remove-Module SHEnv -Force
    Remove-Module Environment -Force
    #Remove-Module PSEnv -Force
    Remove-Module Locations -Force
    Remove-Module Common -Force
}

#Clear-Host

# Set the machines execution policy
If ((Get-ExecutionPolicy) -ne "RemoteSigned")
{
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
}

# Setup PowerShell Modules Locations
$PSModules = ((Split-Path $PSCommandPath) + "\Modules")
If (!(Test-Path($PSModules)))
{
	$PSModules = ((Split-Path $PSCommandPath) + "\..\Modules")
	If (!(Test-Path($PSModules)))
	{
		Write-Warning "Modules path does not exist!"
		Exit
	}
}


# PS Setup Location
$Global:PSSetupScripts = (Split-Path $PSCommandPath)

# Defalut PS Scripts and Modules
$Global:PSUserHome = ($Home + "\Documents\WindowsPowerShell")
$Global:PSUserModulePath = ($PSUserHome + "\Modules")
$Global:PSWindowsModulePath = ($PSHome + "\Modules")

# Setup PSModulePath
If (!$Env:PSModulePath.Contains($PSModules)) { $Env:PSModulePath = $Env:PSModulePath + ";" + $PSModules}
If (!$Env:PSModulePath.Contains($PSUserModulePath)) { $Env:PSModulePath = $Env:PSModulePath + ";" + $PSUserModulePath}
If (!$Env:PSModulePath.Contains($PSWindowsModulePath)) { $Env:PSModulePath = $Env:PSModulePath + ";" + $PSWindowsModulePath}
$Env:PSModulePath = $Env:PSModulePath.Replace(";;", ";")

# Copy Modules
Copy-Modules

# Load Modules
Load-Modules

# $PSHome is part of Path by default
#If (!($Env:Path).Contains($PSHome)) { PS-SetX $Path, $PSHome, $True }

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

# Default current host profiles
$CurrentUserCurrentHost = ($Env:UserProfile + "\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1")
$AllUsersCurrentHost = ($Env:windir + "\system32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1")

# ISE current host profiles
$CurrentUserCurrentHostISE = ($Env:UserProfile + "\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1")
$AllUsersCurrentHostISE = ($Env:windir + "\system32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1")

# VSCode current host profiles
$CurrentUserCurrentHostVSCode = ($Env:UserProfile + "\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1")
$AllUsersCurrentHostVSCode = ($Env:windir + "\system32\WindowsPowerShell\v1.0\Microsoft.VSCode_profile.ps1")

# Create an array of all profiles
# Lets just try this one for everything until we need something specific for the other individual profiles.
$ProfileArray = @(
    $Profile.AllUsersAllHosts
)
# $ProfileArray = @(
#     $Profile.AllUsersAllHosts,
#     $Profile.AllUsersCurrentHost,
#     $Profile.CurrentUserAllHosts,
#     $Profile.CurrentUserCurrentHost
# )

# If($psISE)
# {
#     # Script is running in the ISE, add the default and VSCode Current User Profiles
#     $ProfileArray = $ProfileArray += ($AllUsersCurrentHost, $CurrentUserCurrentHost)
#     $ProfileArray = $ProfileArray += ($AllUsersCurrentHostVSCode, $CurrentUserCurrentHostVSCode)
# }
# ElseIf($psEditor)
# {
#     # Script is running in VSCode, add the default and ISE Current User Profiles
#     $ProfileArray = $ProfileArray += ($AllUsersCurrentHost, $CurrentUserCurrentHost)
#     $ProfileArray = $ProfileArray += ($AllUsersCurrentHostISE, $CurrentUserCurrentHostISE)
# }
# Else
# {
#     # Script is not running in the ISE or VSCode, add the ISE and VSCode Current User Profiles
#     $ProfileArray = $ProfileArray += ($AllUsersCurrentHostISE, $CurrentUserCurrentHostISE)
#     $ProfileArray = $ProfileArray += ($AllUsersCurrentHostVSCode, $CurrentUserCurrentHostVSCode)
# }

#Write-Host "Profiles"
#$ProfileArray

# Create or View the profiles
If ($Reset)
{
    ResetProfile
}
ElseIf ($Clean)
{
    CleanProfile
    Unload-Modules
}
ElseIf (!(Test-Path $Profile))
{
    ResetProfile
}
Else
{
    OpenProfile
}

#If (Test-Path $Profile) { . $Profile }

Set-Location (Split-Path $PSCommandPath)

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

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
    If (Test-Path $Profile) 
    {
        Write-Host; Write-Host "Removing Profiles ..."
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
    Write-Host; Write-Host "Creating New Profiles ..."

    If (!(Test-Path $Profile)) { New-Item -Type File -Path $Profile -Force | Out-Null }

$ProfileText = @"
# `$Profile.AllUsersAllHosts
# $Env:windir\system32\WindowsPowerShell\v1.0\profile.ps1

# `$Profile.AllUsersCurrentHost
# $Env:windir\system32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
# $Env:windir\system32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1

# `$Profile.CurrentUserAllHosts
# $Env:UserProfile\My Documents\WindowsPowerShell\profile.ps1

# `$Profile.CurrentUserCurrentHost
# $Env:UserProfile\My Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# $Env:UserProfile\My Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1

################
# Set Security #
################

If ((Get-ExecutionPolicy) -ne "RemoteSigned") { Set-ExecutionPolicy RemoteSigned }
If ((Get-ExecutionPolicy -Scope CurrentUser) -ne "RemoteSigned") { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser }

################
# Load Modules #
################

Import-Module Locations -Force -Global -DisableNameChecking
Import-Module Shares -Force -Global -DisableNameChecking
Import-Module URLs -Force -Global -DisableNameChecking
Import-Module Common -Force -Global -DisableNameChecking
Import-Module Environment -Force -Global -DisableNameChecking
Import-Module Normh -Force -Global -DisableNameChecking

Set-LoadPSModulePath(`$PSUserModulePath)
Set-LoadPSModulePath(`$PSWindowsModulePath)
Set-LoadPSModulePath(`$PSScriptsModulePath)

##################
# Export Aliases #
##################

Export-Alias -Path `$PSDir\AliasScript.ps1 -As Script
Export-Alias -Path `$PSDir\AliasCSV.ps1 -As CSV

If (`$PWD -ne `$PSScripts) { Set-Location `$PSScripts }
"@
  
    Write-ToProfile $ProfileText
    
    Write-Host "Created $Profile"

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
    Import-Module Locations -Force -Global -DisableNameChecking
    Import-Module Shares -Force -Global -DisableNameChecking
    Import-Module URLs -Force -Global -DisableNameChecking
    Import-Module Common -Force -Global -DisableNameChecking
    Import-Module Environment -Force -Global -DisableNameChecking
    Import-Module Normh -Force -Global -DisableNameChecking
}

# Unload Modules
Function Unload-Modules
{
    Remove-Module Common -Force
    Remove-Module Environment -Force
    Remove-Module Shares -Force
    Remove-Module Normh -Force
    #Remove-Module Locations -Force
    #Remove-Module URLs -Force
}

Clear-Host

# Set the machines execution policy
If ((Get-ExecutionPolicy) -ne "RemoteSigned")
{
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
}

# Setup OneDrive PowerShell modules locations
If (Test-Path ((Split-Path $PWD) + "\Modules"))
{
    $PSModules = ((Split-Path $PWD) + "\Modules")
}
Else
{
    $PSModules = ($Env:UserProfile + "\OneDrive\Scripts\PowerShell\Modules")
    If (!(Test-Path($PSModules)))
    {
        $PSModules = ($Env:UserProfile + "\SkyDrive\Scripts\PowerShell\Modules")
        If (!(Test-Path($PSModules)))
        {
            Write-Warning "Local OneDrive (or SkyDrive) does not exist"
        }
    }
}

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

# Create an array of all profiles
$ProfileArray = @(
    $Profile.AllUsersAllHosts,
    $Profile.AllUsersCurrentHost,
    $Profile.CurrentUserAllHosts,
    $Profile.CurrentUserCurrentHost
)

If($psISE)
{
    # Script is running in the ISE, add the default Current User Profiles
    $ProfileArray = $ProfileArray += ($AllUsersCurrentHost, $CurrentUserCurrentHost)
}
Else
{
    # Script is not running in the ISE, add the ISE Current User Profiles
    $ProfileArray = $ProfileArray += ($AllUsersCurrentHostISE, $CurrentUserCurrentHostISE)
}

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

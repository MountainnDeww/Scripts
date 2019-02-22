#############
# Variables #
#############

# WScript Shell
$Global:wshShell = New-Object -ComObject Wscript.Shell

# ComputerName
$Global:ComputerName = "$Env:ComputerName"

# Desktop
$Global:Desktop = "$Home\Desktop"

# Documents
$Global:Documents = "$Home\Documents"


#############
# Functions #
#############

Function Global:Up  { Push-Location ..\$args }
Function Global:Up1 { Push-Location ..\$args }
Function Global:Up2 { Push-Location ..\..\$args }
Function Global:Up3 { Push-Location ..\..\..\$args }
Function Global:Up4 { Push-Location ..\..\..\..\$args }
Function Global:Up5 { Push-Location ..\..\..\..\..\$args }
Function Global:Up6 { Push-Location ..\..\..\..\..\..\$args }
Function Global:Up7 { Push-Location ..\..\..\..\..\..\..\$args }
Function Global:Up8 { Push-Location ..\..\..\..\..\..\..\..\$args }
Function Global:Up9 { Push-Location ..\..\..\..\..\..\..\..\..\$args }

###########
# Aliases #
###########

Set-Alias -Name e -Value explorer.exe -Scope Global
Set-Alias -Name de -Value Del-Env -Scope Global
Set-Alias -Name ga -Value Get-Alias -Scope Global
Set-Alias -Name gca -Value Get-CmdletAlias -Scope Global
Set-Alias -Name gchm -Value Get-CHM -Scope Global
Set-Alias -Name ge -Value Get-Env -Scope Global
Set-Alias -Name gh -Value Get-Help -Scope Global
Set-Alias -Name gip -Value Get-ItemProperty -Scope Global
Set-Alias -Name gmh -Value Get-MoreHelp -Scope Global
Set-Alias -Name goh -Value Get-OnlineHelp -Scope Global
Set-Alias -Name gwmic -Value Get-WmiClass -Scope Global
Set-Alias -Name help -Value Get-Help -Scope Global
Set-Alias -Name n -Value notepad.exe -Scope Global
Set-Alias -Name psh -Value PSCMD -Scope Global
Set-Alias -Name psi -Value PSISE -Scope Global
Set-Alias -Name sa -Value Set-Alias -Scope Global
Set-Alias -Name se -Value Set-Env -Scope Global
Set-Alias -Name wd -Value Write-Debug -Scope Global
Set-Alias -Name we -Value Write-Error -Scope Global
Set-Alias -Name wh -Value Write-Host -Scope Global
Set-Alias -Name wo -Value Write-Output -Scope Global
Set-Alias -Name wv -Value Write-Verbose -Scope Global
Set-Alias -Name ww -Value Write-Warning -Scope Global

#####################################
# Variables ## Functions ## Aliases #
#####################################

# Path to the VFA (VariableFunctionAlias) script
$NewVFAScript = ("$Home\Documents\Scripts\PowerShell\Setup\CreateNewVFA.ps1")

# AllUsersStartMenu
New-VFA -Name "AllUsersStartMenu" -Alias "ausm" -VType "SF" -File $NewVFAScript -Clean

# AllUsersPrograms
New-VFA -Name "AllUsersPrograms" -Alias "aup" -VType "SF" -File $NewVFAScript 

# AllUsersStartup
New-VFA -Name "AllUsersStartup" -Alias "aus" -VType "SF" -File $NewVFAScript 

# AppData
New-VFA -Name "AppData" -Alias "ad" -VType "ENV" -File $NewVFAScript 

# Documents
New-VFA -Name "Documents" -Alias "docs" -VType "SF" -SF "MyDocuments" -File $NewVFAScript 

# Desktop
New-VFA -Name "Desktop" -Alias "dt" -VType "SF" -File $NewVFAScript
 
# Favorites
New-VFA -Name "Favorites" -Alias "fav" -VType "SF" -File $NewVFAScript

# Fonts
New-VFA -Name "Fonts" -VType "SF" -File $NewVFAScript

# LocalAppData
New-VFA -Name "LocalAppData" -Alias "lad" -VType "ENV" -File $NewVFAScript

# NetHood
New-VFA -Name "NetHood" -Alias "nh" -VType "SF" -File $NewVFAScript

# PrintHood
New-VFA -Name "PrintHood" -Alias "ph" -VType "SF" -File $NewVFAScript

# ProgramData
New-VFA -Name "ProgramData" -Alias "pd" -VType "ENV" -File $NewVFAScript

# Programs
New-VFA -Name "Programs" -VType "SF" -File $NewVFAScript

# QuickLaunch
#New-VFA -Name "QuickLaunch" -Alias "ql" -VType "SF" -File $NewVFAScript
New-VFA -Name "QuickLaunch" -Alias "ql" -VType "Path" -Path "$AppData\Microsoft\Internet Explorer\Quick Launch" -File $NewVFAScript

# Recent
New-VFA -Name "Recent" -VType "SF" -File $NewVFAScript

# SendTo
New-VFA -Name "SendTo" -Alias "st" -VType "SF" -File $NewVFAScript

# StartMenu
New-VFA -Name "StartMenu" -Alias "sm" -VType "SF" -File $NewVFAScript

# Startup
New-VFA -Name "Startup" -Alias "su" -VType "SF" -File $NewVFAScript

# TaskBar
#New-VFA -Name "TaskBar" -Alias "tb" -VType "SF" -File $NewVFAScript
New-VFA -Name "TaskBar" -Alias "tb" -VType "Path" -Path "$QuickLaunch\User Pinned\TaskBar" -File $NewVFAScript

# Templates
New-VFA -Name "Templates" -VType "SF" -File $NewVFAScript
 
# Scripts
New-VFA -Name "Scripts" -Alias "s" -VType "Path" -Path "`$Home\Documents\Scripts" -File $NewVFAScript 

# PSDir
New-VFA -Name "PSDir" -VType "Path" -Path "`$Documents\WindowsPowerShell" -File $NewVFAScript 

# PSProfile
New-VFA -Name "PSProfile" -Alias "psp" -VType "Path" -Path "`$Documents\WindowsPowerShell" -File $NewVFAScript 

# PSScripts
New-VFA -Name "PSScripts" -Alias "pss" -VType "Path" -Path "`$Scripts\PowerShell" -File $NewVFAScript 

# PSSetupScripts
New-VFA -Name "PSSetupScripts" -Alias "psss" -VType "Path" -Path "`$Scripts\PowerShell\Setup" -File $NewVFAScript 

# PSTestScripts
New-VFA -Name "PSTestScripts" -Alias "psts" -VType "Path" -Path "`$Desktop\PSTestScripts" -File $NewVFAScript 

# PSScriptsModulePath
New-VFA -Name "PSScriptsModulePath" -Alias "pssmp" -VType "Path" -Path "`$PSScripts\Modules" -File $NewVFAScript 

# PSUserModulePath
New-VFA -Name "PSUserModulePath" -Alias "psump" -VType "Path" -Path "`$PSDir\Modules\" -File $NewVFAScript 

# PSWindowsModulePath
New-VFA -Name "PSWindowsModulePath" -Alias "pswmp" -VType "Path" -Path "`$PSHome\Modules\" -File $NewVFAScript 
 
# System32
New-VFA -Name "System32" -Alias "sys32" -VType "ENV" -File $NewVFAScript

# SystemDrive
New-VFA -Name "SystemDrive" -Alias "sd" -VType "ENV" -File $NewVFAScript

# TestScripts
New-VFA -Name "TestScripts" -Alias "ts" -VType "Path" -Path "`$Desktop\TestScripts" -File $NewVFAScript 

# VirtualStore
New-VFA -Name "VirtualStore" -Alias "vs" -VType "Path" -Path "`$Env:LocalAppData\VirtualStore" -File $NewVFAScript 

# WinDir
New-VFA -Name "WinDir" -VType "ENV" -File $NewVFAScript

# Debuggers
New-VFA -Name "Debuggers" -Alias "dbg" -VType "Path" -Path "`$SystemDrive\Debuggers" -File $NewVFAScript 

# DbgChm
New-VFA -Name "DbgChm" -VType "Path" -Path "`$Debuggers\debugger.chm" -File $NewVFAScript 

# Call the VFA script
. $NewVFAScript

##########
# Office #
##########

$ProgramDataPrograms = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

If ($ComputerName -eq "HALLASUS64")
{
	# Office 2016
	$OfficePath = $ProgramDataPrograms
	If ( (Test-Path $OfficePath) )
	{
	    If ( (Test-Path ($OfficePath + "\Access 2016.lnk") ) ) { Set-Alias -Name access -Value ($OfficePath + "\Access 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\Excel 2016.lnk") ) ) { Set-Alias -Name excel -Value ($OfficePath + "\Excel 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\InfoPath Designer 2016.lnk") ) ) { Set-Alias -Name infopathd -Value ($OfficePath + "\InfoPath Designer 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\InfoPath Filler 2016.lnk") ) ) { Set-Alias -Name infopathf -Value ($OfficePath + "\InfoPath Filler 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\OneNote 2016.lnk") ) ) { Set-Alias -Name onenote -Value ($OfficePath + "\OneNote 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\Outlook 2016.lnk") ) ) { Set-Alias -Name outlook -Value ($OfficePath + "\Outlook 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\PowerPoint 2016.lnk") ) ) { Set-Alias -Name powerpoint -Value ($OfficePath + "\PowerPoint 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\Publisher 2016.lnk") ) ) { Set-Alias -Name publisher -Value ($OfficePath + "\Publisher 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\SharePoint Workspace 2016.lnk") ) ) { Set-Alias -Name sharepoint -Value ($OfficePath + "\SharePoint Workspace 2016.lnk") -Scope Global }
	    If ( (Test-Path ($OfficePath + "\Word 2016.lnk") ) ) { Set-Alias -Name word -Value ($OfficePath + "\Word 2016.lnk") -Scope Global }
	}
}

If ($ComputerName -eq "CA003-EQLT353")
{
	# Office 2010
	$OfficePath = $ProgramDataPrograms + "\Microsoft Office"
	If ( (Test-Path $OfficePath) )
	{
	    Set-Alias -Name access -Value ($OfficePath + "\Microsoft Access 2010.lnk") -Scope Global
	    Set-Alias -Name excel -Value ($OfficePath + "\Microsoft Excel 2010.lnk") -Scope Global
	    Set-Alias -Name infopathd -Value ($OfficePath + "\Microsoft InfoPath Designer 2010.lnk") -Scope Global
	    Set-Alias -Name infopathf -Value ($OfficePath + "\Microsoft InfoPath Filler 2010.lnk") -Scope Global
	    Set-Alias -Name onenote -Value ($OfficePath + "\Microsoft OneNote 2010.lnk") -Scope Global
	    Set-Alias -Name outlook -Value ($OfficePath + "\Microsoft Outlook 2010.lnk") -Scope Global
	    Set-Alias -Name powerpoint -Value ($OfficePath + "\Microsoft PowerPoint 2010.lnk") -Scope Global
	    Set-Alias -Name publisher -Value ($OfficePath + "\Microsoft Publisher 2010.lnk") -Scope Global
	    Set-Alias -Name sharepoint -Value ($OfficePath + "\Microsoft SharePoint Workspace 2010.lnk") -Scope Global
	    Set-Alias -Name word -Value ($OfficePath + "\Microsoft Word 2010.lnk") -Scope Global
	}
	# Office 2013
	$OfficePath = $ProgramDataPrograms + "\Microsoft Office 2013"
	If ( (Test-Path $OfficePath) )
	{
	    Set-Alias -Name access -Value ($OfficePath + "\Access 2013.lnk") -Scope Global
	    Set-Alias -Name excel -Value ($OfficePath + "\Excel 2013.lnk") -Scope Global
	    Set-Alias -Name infopathd -Value ($OfficePath + "\InfoPath Designer 2013.lnk") -Scope Global
	    Set-Alias -Name infopathf -Value ($OfficePath + "\InfoPath Filler 2013.lnk") -Scope Global
	    Set-Alias -Name onenote -Value ($OfficePath + "\OneNote 2013.lnk") -Scope Global
	    Set-Alias -Name outlook -Value ($OfficePath + "\Outlook 2013.lnk") -Scope Global
	    Set-Alias -Name powerpoint -Value ($OfficePath + "\PowerPoint 2013.lnk") -Scope Global
	    Set-Alias -Name publisher -Value ($OfficePath + "\Publisher 2013.lnk") -Scope Global
	    Set-Alias -Name sharepoint -Value ($OfficePath + "\SharePoint Workspace 2013.lnk") -Scope Global
	    Set-Alias -Name word -Value ($OfficePath + "\Word 2013.lnk") -Scope Global
	}

	# Office 2016
	$OfficePath = $ProgramDataPrograms + "\Microsoft Office 2016"
	If ( (Test-Path $OfficePath) )
	{
	    Set-Alias -Name access -Value ($OfficePath + "\Access 2016.lnk") -Scope Global
	    Set-Alias -Name excel -Value ($OfficePath + "\Excel 2016.lnk") -Scope Global
	    Set-Alias -Name infopathd -Value ($OfficePath + "\InfoPath Designer 2016.lnk") -Scope Global
	    Set-Alias -Name infopathf -Value ($OfficePath + "\InfoPath Filler 2016.lnk") -Scope Global
	    Set-Alias -Name onenote -Value ($OfficePath + "\OneNote 2016.lnk") -Scope Global
	    Set-Alias -Name outlook -Value ($OfficePath + "\Outlook 2016.lnk") -Scope Global
	    Set-Alias -Name powerpoint -Value ($OfficePath + "\PowerPoint 2016.lnk") -Scope Global
	    Set-Alias -Name publisher -Value ($OfficePath + "\Publisher 2016.lnk") -Scope Global
	    Set-Alias -Name sharepoint -Value ($OfficePath + "\SharePoint Workspace 2016.lnk") -Scope Global
	    Set-Alias -Name word -Value ($OfficePath + "\Word 2016.lnk") -Scope Global
	}
}
	
#############
# Microsoft #
#############

If ( ($EFE -eq [String]::Empty) -and (Test-Path" \\ae-share\public\efe") )
{
    $Global:EFE = "\\ae-share\public\efe"
    Function Global:EFE { Push-Location $EFE }
}

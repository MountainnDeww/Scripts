#############
# Variables #
#############

$Global:wshShell = New-Object -ComObject Wscript.Shell

$Global:ComputerName = "$Env:ComputerName"

#############
# Functions #
#############

Function Global:Up  { pushd ..\$args }
Function Global:Up1 { pushd ..\$args }
Function Global:Up2 { pushd ..\..\$args }
Function Global:Up3 { pushd ..\..\..\$args }
Function Global:Up4 { pushd ..\..\..\..\$args }
Function Global:Up5 { pushd ..\..\..\..\..\$args }
Function Global:Up6 { pushd ..\..\..\..\..\..\$args }
Function Global:Up7 { pushd ..\..\..\..\..\..\..\$args }
Function Global:Up8 { pushd ..\..\..\..\..\..\..\..\$args }
Function Global:Up9 { pushd ..\..\..\..\..\..\..\..\..\$args }

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

Set-Alias -Name access -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Access 2016.lnk" -Scope Global
Set-Alias -Name excel -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Excel 2016.lnk" -Scope Global
Set-Alias -Name infopathd -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft InfoPath Designer 2016.lnk" -Scope Global
Set-Alias -Name infopathf -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft InfoPath Filler 2016.lnk" -Scope Global
Set-Alias -Name onenote -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft OneNote 2016.lnk" -Scope Global
Set-Alias -Name outlook -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Outlook 2016.lnk" -Scope Global
Set-Alias -Name powerpoint -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft PowerPoint 2016.lnk" -Scope Global
Set-Alias -Name publisher -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Publisher 2016.lnk" -Scope Global
Set-Alias -Name sharepoint -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft SharePoint Workspace 2016.lnk" -Scope Global
Set-Alias -Name word -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Word 2016.lnk" -Scope Global

#####################################
# Variables ## Functions ## Aliases #
#####################################

If ( ($AllUsersStartMenu -eq [String]::Empty) -or ($AllUsersStartMenu -ne $wshShell.SpecialFolders.Item("AllUsersStartMenu")) )
{
    $Global:AllUsersStartMenu = $wshShell.SpecialFolders.Item("AllUsersStartMenu")
    Function Global:AllUsersStartMenu { pushd $AllUsersStartMenu }
    Set-Alias -Name ausm -Value AllUsersStartMenu -Scope Global
}

If ( ($AllUsersPrograms -eq [String]::Empty) -or ($AllUsersPrograms -ne $wshShell.SpecialFolders.Item("AllUsersPrograms")) )
{
    $Global:AllUsersPrograms = $wshShell.SpecialFolders.Item("AllUsersPrograms")
    Function Global:AllUsersPrograms { pushd $AllUsersPrograms }
    Set-Alias -Name aup -Value AllUsersPrograms -Scope Global
}

If ( ($AllUsersStartup -eq [String]::Empty) -or ($AllUsersStartup -ne $wshShell.SpecialFolders.Item("AllUsersStartup")) )
{
    $Global:AllUsersStartup = $wshShell.SpecialFolders.Item("AllUsersStartup")
    Function Global:AllUsersStartup { pushd $AllUsersStartup }
    Set-Alias -Name aus -Value AllUsersStartup -Scope Global
}

If ( ($AppData -eq [String]::Empty) -or ($AppData -ne $Env:AppData) )
{
    $Global:AppData = "$Env:AppData"
    Function Global:AppData { pushd $AppData }
    Set-Alias -Name ad -Value AppData -Scope Global
}

If ( ($Documents -eq [String]::Empty) -or ($Documents -ne $wshShell.SpecialFolders.Item("MyDocuments")) )
{
    $Global:Documents = $wshShell.SpecialFolders.Item("MyDocuments")
    If (!$Documents) { $Global:Documents = "$Home\Documents" }
    Function Global:Documents { pushd $Documents }
    Set-Alias -Name docs -Value Documents -Scope Global
}

If ( ($Desktop -eq [String]::Empty) -or ($Desktop -ne $wshShell.SpecialFolders.Item("Desktop")) )
{
    $Global:Desktop = $wshShell.SpecialFolders.Item("Desktop")
    If (!$Desktop) { $Global:Desktop = "$Home\Desktop" }
    Function Global:Desktop { pushd $Desktop }
    Set-Alias -Name dt -Value Desktop -Scope Global
}

If ( ($Favorites -eq [String]::Empty) -or ($Favorites -ne $wshShell.SpecialFolders.Item("Favorites")) )
{
    $Global:Favorites = $wshShell.SpecialFolders.Item("Favorites")
    Function Global:Favorites { pushd $Favorites }
    Set-Alias -Name fav -Value Favorites -Scope Global
}

If ( ($Fonts -eq [String]::Empty) -or ($Fonts -ne $wshShell.SpecialFolders.Item("Fonts")) )
{
    $Global:Fonts = $wshShell.SpecialFolders.Item("Fonts")
    Function Global:Fonts { pushd $Fonts }
}

If ( ($LocalAppData -eq [String]::Empty) -or ($LocalAppData -ne $Env:LocalAppData) )
{
    $Global:LocalAppData = "$Env:LocalAppData"
    Function Global:LocalAppData { pushd $LocalAppData }
    Set-Alias -Name lad -Value LocalAppData -Scope Global
}

If ( ($NetHood -eq [String]::Empty) -or ($NetHood -ne $wshShell.SpecialFolders.Item("NetHood")) )
{
    $Global:NetHood = $wshShell.SpecialFolders.Item("NetHood")
    Function Global:NetHood { pushd $NetHood }
    Set-Alias -Name nh -Value NetHood -Scope Global
}

If ( ($PrintHood -eq [String]::Empty) -or ($PrintHood -ne $wshShell.SpecialFolders.Item("PrintHood")) )
{
    $Global:PrintHood = $wshShell.SpecialFolders.Item("PrintHood")
    Function Global:PrintHood { pushd $PrintHood }
    Set-Alias -Name ph -Value PrintHood -Scope Global
}

If ( ($ProgramData -eq [String]::Empty) -or ($ProgramData -ne $Env:ProgramData) )
{
    $Global:ProgramData = "$Env:ProgramData"
    Function Global:ProgramData { pushd $ProgramData }
    Set-Alias -Name pd -Value ProgramData -Scope Global
}

If ( ($Programs -eq [String]::Empty) -or ($Programs -ne $wshShell.SpecialFolders.Item("Programs")) )
{
    $Global:Programs = $wshShell.SpecialFolders.Item("Programs")
    Function Global:Programs { pushd $Programs }
}

If ( ($PSDir -eq [String]::Empty) -or ($PSDir -ne "$Documents\WindowsPowerShell") )
{
    $Global:PSDir = "$Documents\WindowsPowerShell"
    Function Global:PSDir { pushd $PSDir }
}

If ( ($PSScripts -eq [String]::Empty) -or ($PSScripts -ne "$Documents\WindowsPowerShell") )
{
    $Global:PSScripts = "$Documents\WindowsPowerShell"
    Function Global:PSScripts { pushd $PSScripts }
    Set-Alias -Name pss -Value PSScripts -Scope Global
}

If ( ($PSTestScripts -eq [String]::Empty) -or ($PSTestScripts -ne "$Desktop\PSTestScripts") )
{
    $Global:PSTestScripts = "$Desktop\PSTestScripts"
    Function Global:PSTestScripts { pushd $PSTestScripts }
}

If ( ($PSScriptsModulePath -eq [String]::Empty) -or ($PSScriptsModulePath -ne "$PSScripts\Modules") )
{
    $Global:PSScriptsModulePath = "$PSScripts\Modules\"
    Function Global:PSScriptsModulePath { pushd $PSScriptsModulePath }
    Set-Alias -Name pssmp -Value PSScriptsModulePath -Scope Global
}

If ( ($PSUserModulePath -eq [String]::Empty) -or ($PSUserModulePath -ne "$PSDir\Modules\") )
{
    $Global:PSUserModulePath = "$PSDir\Modules\"
    Function Global:PSUserModulePath { pushd $PSUserModulePath }
    Set-Alias -Name psump -Value PSUserModulePath -Scope Global
}

If ( ($PSWindowsModulePath -eq [String]::Empty) -or ($PSWindowsModulePath -ne "$PSHome\Modules\") )
{
    $Global:PSWindowsModulePath = "$PSHome\Modules\"
    Function Global:PSWindowsModulePath { pushd $PSWindowsModulePath }
    Set-Alias -Name pswmp -Value PSWindowsModulePath -Scope Global
}

If ( ($QuickLaunch -eq [String]::Empty) -or ($QuickLaunch -ne $wshShell.SpecialFolders.Item("QuickLaunch")) )
{
    $Global:QuickLaunch = $wshShell.SpecialFolders.Item("QuickLaunch")
    If (!$QuickLaunch) { $Global:QuickLaunch = "$AppData\Microsoft\Internet Explorer\Quick Launch" }
    Function Global:QuickLaunch { pushd $QuickLaunch }
    Set-Alias -Name ql -Value QuickLaunch -Scope Global
}

If ( ($Recent -eq [String]::Empty) -or ($Recent -ne $wshShell.SpecialFolders.Item("Recent")) )
{
    $Global:Recent = $wshShell.SpecialFolders.Item("Recent")
    Function Global:Recent { pushd $Recent }
}

If ( ($Scripts -eq [String]::Empty) -or ($Scripts -ne "$Home\Scripts") )
{
    $Global:Scripts = "$Home\Scripts"
    Function Global:Scripts { pushd $Scripts }
    Set-Alias -Name s -Value Scripts -Scope Global
}

If ( ($SendTo -eq [String]::Empty) -or ($SendTo -ne $wshShell.SpecialFolders.Item("SendTo")) )
{
    $Global:SendTo = $wshShell.SpecialFolders.Item("SendTo")
    Function Global:SendTo { pushd $SendTo }
    Set-Alias -Name st -Value SendTo -Scope Global
}

If ( ($StartMenu -eq [String]::Empty) -or ($StartMenu -ne $wshShell.SpecialFolders.Item("StartMenu")) )
{
    $Global:StartMenu = $wshShell.SpecialFolders.Item("StartMenu")
    Function Global:StartMenu { pushd $StartMenu }
    Set-Alias -Name sm -Value StartMenu -Scope Global
}

If ( ($Startup -eq [String]::Empty) -or ($Startup -ne $wshShell.SpecialFolders.Item("Startup")) )
{
    $Global:Startup = $wshShell.SpecialFolders.Item("Startup")
    Function Global:Startup { pushd $Startup }
    Set-Alias -Name su -Value StartUp -Scope Global
}

If ( ($System32 -eq [String]::Empty) -or ($System32 -ne "$Env:WinDir\System32") )
{
    $Global:System32 = "$Env:WinDir\System32"
    Function Global:System32 { pushd $System32 }
    Set-Alias -Name sys32 -Value System32 -Scope Global
}

If ( ($SystemDrive -eq [String]::Empty) -or ($SystemDrive -ne "$Env:SystemDrive") )
{
    $Global:SystemDrive = "$Env:SystemDrive"
    Function Global:SystemDrive { pushd $SystemDrive }
}

If ( ($TaskBar -eq [String]::Empty) -or ($TaskBar -ne $wshShell.SpecialFolders.Item("TaskBar")) )
{
    $Global:TaskBar = $wshShell.SpecialFolders.Item("TaskBar")
    If (!$TaskBar) { $Global:TaskBar = "$QuickLaunch\User Pinned\TaskBar" }
    Function Global:TaskBar { pushd $TaskBar }
    Set-Alias -Name tb -Value TaskBar -Scope Global
}

If ( ($Templates -eq [String]::Empty) -or ($Templates -ne $wshShell.SpecialFolders.Item("Templates")) )
{
    $Global:Templates = $wshShell.SpecialFolders.Item("Templates")
    Function Global:Templates { pushd $Templates }
}

If ( ($TestScripts -eq [String]::Empty) -or ($TestScripts -ne "$Desktop\TestScripts") )
{
    $Global:TestScripts = "$Desktop\TestScripts"
    Function Global:TestScripts { pushd $TestScripts }
    Set-Alias -Name ts -Value TestScripts -Scope Global
}

If ( ($VirtualStore -eq [String]::Empty) -or ($VirtualStore -ne ($Env:LocalAppData + "\VirtualStore")) )
{
    $Global:VirtualStore = ($Env:LocalAppData + "\VirtualStore")
    Function Global:VirtualStore { pushd $VirtualStore }
}

If ( ($WinDir -eq [String]::Empty) -or ($WinDir -ne "$Env:WinDir") )
{
    $Global:WinDir = "$Env:WinDir"
    Function Global:WinDir { pushd $WinDir }
}

If ( ($Debuggers -eq [String]::Empty) -or ($Debuggers -ne "$SystemDrive\Debuggers") )
{
    $Global:Debuggers = "$SystemDrive\Debuggers"
    Function Global:Debuggers { pushd $Debuggers }
    Set-Alias -Name dbg -Value Debuggers -Scope Global
}

If ( ($DbgChm -eq [String]::Empty) -or ($DbgChm -ne "$Debuggers\debugger.chm") )
{
    $Global:DbgChm = "$Debuggers\debugger.chm"
    Function Global:DbgChm { Invoke-Item $DbgChm }
}

#############
# Microsoft #
#############

If ( ($EFE -eq [String]::Empty) -and (Test-Path" \\ae-share\public\efe") )
{
    $Global:EFE = "\\ae-share\public\efe"
    Function Global:EFE { pushd $EFE }
}

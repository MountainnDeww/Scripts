Function Delete-Files ([String[]] $Files)
{
    ForEach ($File In $Files)
    {
        Delete-Item "$SystemPS\$File"
        Delete-Item "$UserPS\$File"
    }
}

Function Delete-Folders ([String[]] $Folders)
{
    ForEach ($Folder In $Folders)
    {
        Delete-Item "$SystemPS\$Folder" -Recurse
        Delete-Item "$UserPS\$Folder" -Recurse
    }
}

Function Delete-Item ([String] $Item, [Switch] $Recurse)
{
    If (Test-Path $Item)
    { 
        If ($Recurse) { Remove-Item -LiteralPath $Item -Force -Recurse }
        Else { Remove-Item -LiteralPath $Item -Force }
    }
}

Function Remove-EnvironmentVariables 
{
    [String[]] $VarArray = @(
          "_NT_SOURCE_PATH"
        , "_NT_SYMBOL_PATH"
        , "AllUsersStartMenu"
        , "AllUsersPrograms"
        , "AllUsersStartup"
        , "AppData"
        , "BIN"
        , "COMPASS"
        , "CorExtBranch"
        , "DbgChm"
        , "Debuggers"
        , "Desktop"
        , "Documents"
        , "EFE"
        , "Favorites"
        , "FBLDRIVE"
        , "FBLESC"
        , "FBLESCACDC"
        , "FBLESCACDCAUTO"
        , "FBLESCACDCAUTODEV"
        , "FBLESCACDCEFE"
        , "Fonts"
        , "IDW"
        , "InetRoot"
        , "LocalAppData"
        , "MyPublic"
        , "MyScratch"
        , "NetHood"
        , "OBJ"
        , "One"
        , "OneDrive"
        , "OSBINROOT"
        , "PrintHood"
        , "PRODUCTS_PUBLIC_PRODUCTS_ROOT"
        , "Programs"
        , "ProgramData"
        , "PS"
        , "PSDir"
        , "PSScripts"
        , "PSScriptsModulePath"
        , "PSTestScripts"
        , "PSUserModulePath"
        , "PSWindowsModulePath"
        , "QuickLaunch"
        , "Recent"
        , "SbWccDev"
        , "SB_WCC_DEV"
        , "Scripts"
        , "SDScripts"
        , "SendTo"
        , "Sky"
        , "SkyDrive"
        , "StartMenu"
        , "Startup"
        , "SysInternals"
        , "System32"
        , "SystemDrive"
        , "TAEF"
        , "TaskBar"
        , "Templates"
        , "TESTBINROOT"
        , "TestScripts"
        , "Tools"
        , "UE"
        , "UE32"
        , "VirtualStore"
        , "WinDir"
        , "WinMainWTRCompass"
        , "WinMain_WTR_Compass"
        , "WTT_OSBINROOT"
        , "WTT_TESTBINROOT"
    )
    
    # Don't know if these should be added or not.

    #CorExtBranch                   SB_WCC_DEV                                                               
    #Coverage                       C:\ProgramData\Coverage                                                  
    #FP_NO_HOST_CHECK               NO                                                                       
    #InetRoot                       D:\SB_WCC_DEV                                                            
    #PRODUCTS_PUBLIC_PRODUCTS_ROOT  \\products\public\products                                               
    #PSModulePath                   C:\Users\normh\Documents\WindowsPowerShell\Modules;C:\WINDOWS\system32...
    #SYSTEMTYPE                     other                                                                    

    Remove-EnvironmentVariable $VarArray
}

Function Remove-EnvironmentVariable ([String[]] $VarArray)
{
    ForEach($Item In $VarArray)
    {
        If ([Environment]::GetEnvironmentVariable($Item, [EnvironmentVariableTarget]::Machine))
        {
            [Environment]::SetEnvironmentVariable($Item, $null, [EnvironmentVariableTarget]::Machine)
        }
        
        If ([Environment]::GetEnvironmentVariable($Item, [EnvironmentVariableTarget]::User))
        {
            [Environment]::SetEnvironmentVariable($Item, $null, [EnvironmentVariableTarget]::User)
        }
        
#		ForEach($Var In (ls Variable:))
#		{
#			If ($Var.Name -eq $Item)
#			{
#				If(Get-Variable -Name $Item)
#				{
#					Remove-Variable -Name $Item -Force
#				}
#			}
#		}
   }
}

Remove-Module -Name Location -Force -ErrorAction SilentlyContinue
Remove-Module -Name URL -Force -ErrorAction SilentlyContinue
Remove-Module -Name Environment -Force -ErrorAction SilentlyContinue
Remove-Module -Name Shares -Force -ErrorAction SilentlyContinue
Remove-Module -Name Normh -Force -ErrorAction SilentlyContinue
Remove-Module -Name Automation -Force -ErrorAction SilentlyContinue
Remove-Module -Name Common -Force -ErrorAction SilentlyContinue

If ( Test-Path $Env:UserProfile\Desktop\PSTestScripts )
{
    $Files = Get-ChildItem -Path ($Env:UserProfile + "\Desktop\PSTestScripts") -Filter "deployer*install*.xml" -Recurse
    ForEach ( $File In $Files ) { Delete-Item $File.FullName }
}

$Script:SystemPS = "$Env:Windir\system32\WindowsPowerShell\v1.0"
$Script:UserPS = "$Env:UserProfile\Documents\WindowsPowerShell"
Delete-Files @("profile.ps1", "Microsoft.PowerShell_profile.ps1", "Microsoft.PowerShellISE_profile.ps1")
Delete-Folders @("Modules\Automation", "Modules\Common", "Modules\Environment", "Modules\Locations", "Modules\Shares", "Modules\Normh", "Modules\URLs")

Remove-EnvironmentVariables

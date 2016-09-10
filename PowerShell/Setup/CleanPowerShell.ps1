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

Function IsDoNotDelete([String] $StrVar )
{
	[Boolean] $InDND = $false

	ForEach($DND In $DoNotDelete)
	{
		If ($StrVar -eq $DND)
		{
			$InDND = $true
		}
	}
	Return $InDND
}

Function Remove-EnvironmentVariable ([String[]] $VarArray)
{

	ForEach($Item In $VarArray)
	{
		#Write-Host "Item:" $Item

		If (!(IsDoNotDelete($Item)))
		{
			If ([Environment]::GetEnvironmentVariable($Item, [EnvironmentVariableTarget]::Machine))
			{
				[Environment]::SetEnvironmentVariable($Item, $null, [EnvironmentVariableTarget]::Machine)
			}
		
			If ([Environment]::GetEnvironmentVariable($Item, [EnvironmentVariableTarget]::User))
			{
				[Environment]::SetEnvironmentVariable($Item, $null, [EnvironmentVariableTarget]::User)
			}

			#This doesn't work, Besides, removing the variable from the profiles will prevent them from being created in new sessions
			#ForEach($Var In (ls Variable:))
			#{
			#	If ($Var.Name -eq $Item)
			#	{
			#		Remove-Variable -Name {$Item} -Force
			#	}
			#}
		}
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
		, "BIN"
		, "DbgChm"
		, "Debuggers"
		, "Desktop"
		, "Documents"
		, "Favorites"
		, "Fonts"
		, "IDW"
		, "InetRoot"
		, "MyPublic"
		, "MyScratch"
		, "NetHood"
		, "One"
		, "OneDrive"
		, "PrintHood"
		, "Programs"
		, "PS"
		, "PSDir"
		, "PSScripts"
		, "PSScriptsModulePath"
		, "PSTestScripts"
		, "PSUserModulePath"
		, "PSWindowsModulePath"
		, "QuickLaunch"
		, "Recent"
		, "Scripts"
		, "SDScripts"
		, "SendTo"
		, "Sky"
		, "SkyDrive"
		, "StartMenu"
		, "Startup"
		, "SysInternals"
		, "System32"
		, "TaskBar"
		, "Templates"
		, "TestScripts"
		, "Tools"
		, "UE"
		, "UE32"
		, "VirtualStore"
	)
		#, "COMPASS"
		#, "CorExtBranch"
		#, "EFE"
		#, "FBLDRIVE"
		#, "FBLESC"
		#, "FBLESCACDC"
		#, "FBLESCACDCAUTO"
		#, "FBLESCACDCAUTODEV"
		#, "FBLESCACDCEFE"
		#, "LocalAppData"
		#, "OBJ"
		#, "OSBINROOT"
		#, "PRODUCTS_PUBLIC_PRODUCTS_ROOT"
		#, "SbWccDev"
		#, "SB_WCC_DEV"
		#, "TAEF"
		#, "TESTBINROOT"
		#, "WinMainWTRCompass"
		#, "WinMain_WTR_Compass"
		#, "WTT_OSBINROOT"
		#, "WTT_TESTBINROOT"
	
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

[String[]] $DoNotDelete = @(
	  "ALLUSERSPROFILE"
	, "APPDATA"
	, "CommonProgramFiles"
	, "CommonProgramFiles(x86)"
	, "CommonProgramW6432"
	, "COMPUTERNAME"
	, "ComSpec"
	, "HOMEDRIVE"
	, "HOMEPATH"
	, "LOCALAPPDATA"
	, "LOGONSERVER"
	, "NUMBER_OF_PROCESSORS"
	, "OS"
	, "Path"
	, "PATHEXT"
	, "PROCESSOR_ARCHITECTURE"
	, "PROCESSOR_IDENTIFIER"
	, "PROCESSOR_LEVEL"
	, "PROCESSOR_REVISION"
	, "ProgramData"
	, "ProgramFiles"
	, "ProgramFiles(x86)"
	, "ProgramW6432"
	, "PROMPT"
	, "PSModulePath"
	, "PUBLIC"
	, "SystemDrive"
	, "SystemRoot"
	, "TEMP"
	, "TMP"
	, "USERDOMAIN"
	, "USERDOMAIN_ROAMINGPROFILE"
	, "USERNAME"
	, "USERPROFILE"
	, "VS110COMNTOOLS"
	, "VS120COMNTOOLS"
	, "windir"
)

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

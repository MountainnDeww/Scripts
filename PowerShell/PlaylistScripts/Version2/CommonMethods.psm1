 <#
	.SYNOPSIS
		Playlist Common Methods Powershell Module.

	.DESCRIPTION
		CommonMethods.psm1 - Module containing playlist powershell methods.

	.NOTES
		Script          : CommonMethods.psm1
		Version         : 1.0
		Author          : Norm Hall
		Email           : norm.hall@outlook.com, halln77@hotmail.com
		Creation Date   : September 16, 2016
		Purpose/Change  : Initial release
		Change Date     : 
		Purpose/Change  : 
		Comment         :        
#>

#[CmdletBinding()]

# Copy Files To Destination
Function CopyFilesToDestination ($Files, $DestinationPath)
{
	ForEach ($File In $Files)
	{
		Copy-Item -Path $File.FullName -Destination $DestinationPath -Force
		$FilePath = Join-Path -Path $DestinationPath -ChildPath $File.Name
		If (Test-Path $FilePath ) { Write-Host $FilePath }
		Else { Write-Host ("File not found:" + $FilePath) -ForegroundColor Red }
	}
}

# Remove a list of files
Function RemoveFiles ($Files)
{
	ForEach ($File In $Files)
	{
		Remove-Item -Path $File -Force
		Write-Host "." -NoNewline
	}
}

# Write string out to file
Function Write-ToFile ([String] $FilePath, [String] $String)
{
	If (!(Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force; Write-Host } 

	try
	{
		Out-File -FilePath $FilePath -InputObject $String -Append -Force
	}
	catch [System.IO.IOException]
	{
		$Script:CaughtException = $True
		Write-Host "." -NoNewline
		Sleep 2
		Write-ToFile $FilePath $String
	}
}

# Create an empty file with .clean ext
Function CreateCleanFile ([String] $FilePath)
{
	$CleanFilePath = ($FilePath + ".clean")
	#If ((Test-Path $FilePath)) { New-Item -Type File -Path $CleanFilePath -Force | Out-Null } 
	ReCreateEmptyFile $CleanFilePath
	Return $CleanFilePath
}

# Create an empty file
Function ReCreateEmptyFile ([String] $FilePath)
{
	If ((Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force | Out-Null } 
}

# Clean the file
Function SetMusicFolder ([String] $BackupFilePath, [String] $FilePath)
{
	$FileContent = Get-Content $BackupFilePath
	ForEach($Line In $FileContent)
	{
		If ($Line.Contains($SearchPath))
		{
			Write-ToFile $FilePath $Line.Replace($SearchPath, $ReplacePath)
		}
		Else
		{
			Write-ToFile $FilePath $Line
		}
	}
}

# Backup a file
Function BackupFile ([String] $FilePath)
{
	$BackupPath = ($FilePath + ".bak")
	Copy-Item -LiteralPath $FilePath -Destination $BackupPath
	Return $BackupPath
}


# Get the Script Information
Function Get-ScriptInfo ($ScriptFullPath, $Debug)
{
	#$Global:ScriptFullPath = $PSCommandPath
	#$Global:ScriptFullPath = $MyInvocation.MyCommand.Path
	$ScriptPath = Split-Path $ScriptFullPath -Parent
	#$ScriptDrive = $ScriptPath.Split("\")[0]
	$ScriptDrive = Split-Path $ScriptFullPath -Qualifier
	#$ScriptFile = $ScriptFullPath.Remove(0,$ScriptPath.Length+1)
	$ScriptFile = Split-Path $ScriptFullPath -Leaf
	$ScriptFileArray = $ScriptFile.Split(".")
	$ScriptExt = $ScriptFileArray[$ScriptFileArray.Count-1]
	$ScriptName = $Null
	ForEach($Item In $ScriptFileArray)
	{
		If ($Item -ne $ScriptExt)
		{
			If ($ScriptName)
			{
				$ScriptName = $ScriptName + "." + $Item
			}
			Else
			{
				$ScriptName = $Item
			}
		}
	}

	If ($Debug)
	{
		Write-Host "ScriptFullPath : $ScriptFullPath"
		Write-Host "ScriptPath     : $ScriptPath"
		Write-Host "ScriptDrive    : $ScriptDrive"
		Write-Host "ScriptFile     : $ScriptFile"
		Write-Host "ScriptFileArray: $ScriptFileArray"
		Write-Host "ScriptName     : $ScriptName"
		Write-Host "ScriptExt      : $ScriptExt"
	}

	$ScriptDictionary = @{"FullPath" = $ScriptFullPath; "Drive" = $ScriptDrive; "Path" = $ScriptPath; "File" = $ScriptFile; "Name" = $ScriptName; "Ext" = $ScriptExt}

	Return $ScriptDictionary
}
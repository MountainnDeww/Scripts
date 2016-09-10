#[CmdletBinding()]
Param (
    [Switch] $Debug,
    [Switch] $Verbose
)

Function RenameFolders ([String] $RootFolderPath)
{
	ForEach ($FolderName In Get-ChildItem $RootFolderPath )
	{
		RenameFolder -FolderName $FolderName
	}
}

Function RenameFolder ([String] $FolderName)
{
	#$ParentPath = Split-Path $FolderPath
	#$FolderName = Split-Path $FolderPath -Leaf
    #Write-Host "FolderPath =" $FolderPath
    #Write-Host "ParentPath =" $ParentPath

    #Write-Host "FolderName =" $FolderName

    #$Folders = Get-ChildItem $ParentPath -Filter ([String]::Format("*{0}*", $FolderName))

	If ($FolderName.StartsWith("TFS"))
	{
		$NewFolderName = $FolderName.Replace("TFS", "TFS ")
    
		$FolderPath = Join-Path -Path $RootFolderPath -ChildPath $FolderName
		$NewFolderPath = Join-Path -Path $RootFolderPath -ChildPath $NewFolderName

        #Write-Host "FolderPath =" $FolderPath
        #Write-Host "NewFolderPath =" $NewFolderPath
		
		If(!(Test-Path $NewFolderPath))
		{
			Rename-Item $FolderPath -NewName $NewFolderPath
		}
	}
	
	Return $NewFolderPath
}

#
$Script:SUCCESS = 0
$Script:FAILURE = 1

# Get the latest Local TimeStamp; ((Get-Date).DateTime).ToString())
$Script:TimeString = [DateTime]::Now.ToString("yyyyMMdd-HHmmffff")

# TFC Info
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent

# Rename the TFS folders
$Script:RootFolderPath = "C:\Users\nohall\Documents\Testing\SQL\CA6336"
CD $RootFolderPath
RenameFolders -RootFolderPath $RootFolderPath

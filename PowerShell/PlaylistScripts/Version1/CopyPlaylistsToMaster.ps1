Param (
	[Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
Function CopyPlaylistsToMaster ($Files, $MasterPlaylistPath)
{
	ForEach ($File In $Files)
	{
		Copy-Item -Path $File.FullName -Destination $MasterPlaylistPath -Force
		$MasterFilePath = Join-Path -Path $MasterPlaylistPath -ChildPath $File.Name
		If (Test-Path $MasterFilePath ) { Write-Host $MasterFilePath }
		Else { Write-Host ("File not found:" + $MasterFilePath) -ForegroundColor Red }
	}
}

$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$MasterPlayListPath = $env:USERPROFILE + "\OneDrive\Documents\MasterPlaylists"

$WPLMasterPlaylistPath = ($MasterPlayListPath + "\WPL")
$ZPLMasterPlaylistPath = ($MasterPlayListPath + "\ZPL")

$WPLFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))
$ZPLFiles = Get-ChildItem(($PlayListPath + "\*.zpl"))

If ($PrintStatus) { Write-Host; Write-Host "Copying Playlists to MasterPlaylists." -ForegroundColor Green; Write-Host }

CopyPlaylistsToMaster $WPLFiles $WPLMasterPlaylistPath
CopyPlaylistsToMaster $ZPLFiles $ZPLMasterPlaylistPath

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

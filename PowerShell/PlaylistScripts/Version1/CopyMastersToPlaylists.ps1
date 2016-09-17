Param (
	[Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
Function CopyMastersToPlaylists ($MasterPlaylistFiles, $PlaylistPath)
{
	ForEach ($File In $MasterPlaylistFiles)
	{
		Copy-Item -Path $File.FullName -Destination $PlaylistPath -Force
		$MasterFilePath = Join-Path -Path $PlaylistPath -ChildPath $File.Name
		If (Test-Path $MasterFilePath ) { Write-Host $MasterFilePath }
		Else { Write-Host ("File not found:" + $MasterFilePath) -ForegroundColor Red }
	}
}

$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$MasterPlayListPath = $env:USERPROFILE + "\OneDrive\Documents\MasterPlaylists"

$WPLMasterPlaylistFiles = Get-ChildItem($MasterPlayListPath + "\WPL\*.wpl")
$ZPLMasterPlaylistFiles = Get-ChildItem($MasterPlayListPath + "\ZPL\*.zpl")

If ($PrintStatus) { Write-Host; Write-Host "Copying MasterPlaylists to Playlists." -ForegroundColor Green; Write-Host }

CopyMastersToPlaylists $WPLMasterPlaylistFiles $PlayListPath
CopyMastersToPlaylists $ZPLMasterPlaylistFiles $PlayListPath

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

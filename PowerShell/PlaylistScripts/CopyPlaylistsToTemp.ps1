Param (
	[Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
Function CopyPlaylistsToTemp ($Files, $TempPlaylistPath)
{
	ForEach ($File In $Files)
	{
		Copy-Item -Path $File.FullName -Destination $TempPlaylistPath -Force
		$TempFilePath = Join-Path -Path $TempPlaylistPath -ChildPath $File.Name
		If (Test-Path $TempFilePath ) { Write-Host $TempFilePath }
		Else { Write-Host ("File not found:" + $TempFilePath) -ForegroundColor Red }
	}
}

Function RemoveFiles ($Files)
{
	ForEach ($File In $Files)
	{
		Remove-Item -Path $File -Force
	}
}


$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$WPLTempPlaylistPath = ($env:USERPROFILE + "\OneDrive\Documents\TempPlaylists\WPL")
If (!(Test-Path $WPLTempPlaylistPath)) { New-Item -ItemType Directory -Path $WPLTempPlaylistPath -Force; Write-Host }
RemoveFiles (Get-ChildItem(($WPLTempPlaylistPath + "\*.wpl")))

$ZPLTempPlaylistPath = ($env:USERPROFILE + "\OneDrive\Documents\TempPlaylists\ZPL")
If (!(Test-Path $ZPLTempPlaylistPath)) { New-Item -ItemType Directory -Path $ZPLTempPlaylistPath -Force; Write-Host }
RemoveFiles (Get-ChildItem(($ZPLTempPlaylistPath + "\*.zpl")))

$WPLFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))
$ZPLFiles = Get-ChildItem(($PlayListPath + "\*.zpl"))

If ($PrintStatus) { Write-Host; Write-Host "Copying Playlists to TempPlaylists." -ForegroundColor Green; Write-Host }

CopyPlaylistsToTemp $WPLFiles $WPLTempPlaylistPath
CopyPlaylistsToTemp $ZPLFiles $ZPLTempPlaylistPath

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

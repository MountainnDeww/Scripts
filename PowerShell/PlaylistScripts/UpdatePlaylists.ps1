# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$PlayListScripts = $env:USERPROFILE + "\OneDrive\Scripts\PowerShell\PlaylistScripts"

$Global:MusicDrive = "M:"
$Global:MusicPath = $MusicDrive + "\Music"
$Global:PlayListPath = $MusicPath + ("\Playlists")

cd $PlayListScripts

Write-Host; Write-Host "Updating Playlists." -ForegroundColor Green; Write-Host

& .\CopyPlaylistsToTemp.ps1 -PrintStatus
#& .\CopyMastersToPlaylists.ps1 -PrintStatus
#& .\SetMusicFolderInFiles.ps1 -PrintStatus
& .\CreateCleanPlayListFiles.ps1 -PrintStatus -Relative
& .\ReplacePlWithCleanPl.ps1 -PrintStatus
& .\RemoveBakClean.ps1 -Bak -PrintStatus -Clean
& .\CopyPlaylistsToMaster.ps1 -PrintStatus

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$PlayListScripts = "C:\Users\Norman\SkyDrive\Documents\Scripts\PowerShell\PlaylistScripts"

cd $PlayListScripts

Write-Host "Run UpdatePlaylists.ps1 to update the playlists."
Write-Host "It will run the following scripts:"
Write-Host
Write-Host "& .\CopyPlaylistsToMaster.ps1 -Batch"
Write-Host "#& .\CopyMastersToPlaylists.ps1 -Batch"
Write-Host "#& .\SetMusicFolderInFiles.ps1 -Batch -Drive E:"
Write-Host "& .\CreateCleanPlayListFiles.ps1 -Batch"
Write-Host "& .\ReplacePlWithCleanPl.ps1 -Batch"
Write-Host "& .\RemoveBakClean.ps1 -Bak -Batch -Clean"

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

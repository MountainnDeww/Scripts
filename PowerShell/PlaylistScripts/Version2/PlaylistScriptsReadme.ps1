# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$PlayListScripts = "C:\Users\Norman\OneDrive\Documents\Scripts\PowerShell\PlaylistScripts"

cd $PlayListScripts

Write-Host "Run UpdatePlaylists.ps1 to update the playlists."
Write-Host
Write-Host "It will do the following:"
Write-Host "1. Copy Playlists To Temp Folder"
Write-Host "2. Create Clean PlayList Files"
Write-Host "3. Replace existing Playlists with Clean Playlists"
Write-Host "4. Copy Playlists To Master Folder"

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

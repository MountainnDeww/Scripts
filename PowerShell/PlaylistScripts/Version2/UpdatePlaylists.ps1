<#
	.SYNOPSIS
		Update Playlist Powershell Script.

	.DESCRIPTION
		UpdatePlaylists.ps1 - Main Script to update playlists.

	.NOTES
		Script          : UpdatePlaylists.ps1
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

################
# Load Modules #
################
$ModulePath = (Split-Path $PSCommandPath -Parent)
Import-Module $ModulePath\CommonMethods.psm1 -Force #-Global -DisableNameChecking
Import-Module $ModulePath\PlaylistMethods.psm1 -Force #-Global -DisableNameChecking


###################
# Run Main Script #
###################

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$Global:MusicDrive = "M:"
$Global:MusicPath = $MusicDrive + "\Music"
$Global:PlayListPath = $MusicPath + ("\Playlists")

$RootPath = ($env:USERPROFILE + "\OneDrive")
$Documents = ($RootPath + "\Documents")

Write-Host; Write-Host "Updating Playlists." -ForegroundColor Green; Write-Host

CopyPlaylistsToTemp -TempPlaylistPath ($Documents + "\TempPlaylists") -PrintStatus
#CopyMastersToPlaylists -PrintStatus
#SetMusicFolderInFiles -Relative -PrintStatus
#SetMusicFolderInFiles -OldMusicPath "F:\Music" -Relative -PrintStatus
CreateCleanPlayListFiles -PrintStatus -Relative
ReplacePlWithCleanPl -PrintStatus
CopyPlaylistsToMaster -MasterPlayListPath ($Documents + "\MasterPlaylists") -PrintStatus

Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

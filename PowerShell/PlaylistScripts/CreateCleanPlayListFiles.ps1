Param (
	[Switch] $PrintStatus,
	[Switch] $Relative
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False
$startDir = $PWD
$workingDir = $ScriptPath.Path

CD $workingDir

If ($PrintStatus) { Write-Host; Write-Host "Creating Clean Playlists." -ForegroundColor Green; Write-Host }

$Files = Get-ChildItem(($PlayListPath + "\*.*pl"))
ForEach ($File In $Files)
{
	If ($Relative) { & .\CreateCleanPlayList.ps1 -FilePath $File.FullName -RelativePaths }
	Else { & .\CreateCleanPlayList.ps1 -FilePath $File.FullName }

	$FilePath = $File.FullName + ".clean"
	If (Test-Path $FilePath ) { Write-Host $FilePath }
	Else { Write-Host ("File not found:" + $FilePath) -ForegroundColor Red }
}

CD $startDir

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

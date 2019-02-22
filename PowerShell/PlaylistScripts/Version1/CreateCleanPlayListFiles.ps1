Param (
	[Switch] $WPL,
	[Switch] $PrintStatus,
	[Switch] $Relative
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False
$startDir = $PWD
$workingDir = $ScriptPath.Path

CD $workingDir

Function RemoveFiles ($Files)
{
    ForEach ($File In $Files)
    {
        Remove-Item -Path $File -Force
        Write-Host "." -NoNewline
    }
}

If ($WPL) 
{ 
    If ($PrintStatus) { Write-Host; Write-Host ("Removing pls and zpl files.") -ForegroundColor Green; Write-Host }
    RemoveFiles (Get-ChildItem(($PlayListPath + "\*.pls")))
    RemoveFiles (Get-ChildItem(($PlayListPath + "\*.zpl")))
    Write-Host

    $Files = Get-ChildItem(($PlayListPath + "\*.wpl")) 
}
Else 
{
    $Files = Get-ChildItem(($PlayListPath + "\*.*pl"))
}

If ($PrintStatus) { Write-Host; Write-Host "Creating Clean Playlists." -ForegroundColor Green; Write-Host }

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

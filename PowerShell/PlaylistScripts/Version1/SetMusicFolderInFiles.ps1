Param (
    [String] $MusicPath,
    [String] $PlayListPath,
    [Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

#If ($Drive) { $MusicPath = ($Drive + "\Music") }
#Else { ("M:\Music") }

$WPLFiles = Get-ChildItem ($PlayListPath + "\*.wpl")
ForEach ($File In $WPLFiles)
{
    Write-Host $File.FullName
    & .\SetMusicFolder.ps1 -FilePath $File.FullName -MusicPath $MusicPath
}

$ZPLFiles = Get-ChildItem ($PlayListPath + "\*.zpl")
ForEach ($File In $ZPLFiles)
{
    Write-Host $File.FullName
    & .\SetMusicFolder.ps1 -FilePath $File.FullName -MusicPath $MusicPath
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

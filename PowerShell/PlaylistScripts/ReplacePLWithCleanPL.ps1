Param (
    [Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

If ($PrintStatus) { Write-Host; Write-Host "Replacing Dirty Playlists with Clean Playlists." -ForegroundColor Green; Write-Host }

$Files = Get-ChildItem(($PlayListPath + "\*.*pl"))
ForEach ($File In $Files)
{
    $CleanPL = ($File.FullName + ".clean")
    IF (Test-Path $CleanPL)
    {
        Move-Item -Path $CleanPL -Destination $File.FullName -Force
        Write-Host $File.FullName
    }
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

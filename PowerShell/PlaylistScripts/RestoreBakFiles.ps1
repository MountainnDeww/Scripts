Param (
    [Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$WPLFiles = Get-ChildItem ($PlayListPath + "\*.wpl")
ForEach ($File In $WPLFiles)
{
    $BakFile = ($File.FullName + ".bak")
    If (Test-Path $BakFile)
    {
        Write-Host $File.FullName
        Remove-Item $File.FullName
        Rename-Item $BakFile $File.FullName
    }
}

$ZPLFiles = Get-ChildItem ($PlayListPath + "\*.zpl")
ForEach ($File In $ZPLFiles)
{
    $BakFile = ($File.FullName + ".bak")
    If (Test-Path $BakFile)
    {
        Write-Host $File.FullName
        Remove-Item $File.FullName
        Rename-Item $BakFile $File.FullName
    }
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

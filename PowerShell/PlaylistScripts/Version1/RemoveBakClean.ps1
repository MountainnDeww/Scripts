Param (
    [Switch] $Bak,
    [Switch] $PrintStatus,
    [Switch] $Clean
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

Function RemoveFiles ($Files)
{
    ForEach ($File In $Files)
    {
        Remove-Item -Path $File -Force
        Write-Host "." -NoNewline
    }
}

$WPLFiles = ($PlayListPath + "\*.wpl")
$ZPLFiles = ($PlayListPath + "\*.zpl")

If  ($Bak)
{
    If ($PrintStatus) { Write-Host; Write-Host "Removing .bak files." -ForegroundColor Green; Write-Host }

    RemoveFiles (Get-ChildItem(($WPLFiles + ".bak")))
    RemoveFiles (Get-ChildItem(($ZPLFiles + ".bak")))
}

If  ($Clean)
{
    If ($PrintStatus) { Write-Host; Write-Host "Removing .clean files." -ForegroundColor Green; Write-Host }

    RemoveFiles (Get-ChildItem(($WPLFiles + ".clean")))
    RemoveFiles (Get-ChildItem(($ZPLFiles + ".clean")))
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

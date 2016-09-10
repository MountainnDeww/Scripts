Param (
    [Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$PlayListScripts = $env:USERPROFILE + "\OneDrive\Scripts\PowerShell\PlaylistScripts"

$Global:MusicDrive = "M:"
$Global:MusicPath = $MusicDrive + "\Music"
$Global:PlayListPath = $MusicPath + ("\Playlists")

cd $PlayListScripts

$ZplFiles = Get-ChildItem(($PlayListPath + "\*.zpl"))

ForEach ($File In $ZplFiles)
{
    $DestinationPath = (Split-Path $File -Parent)
    $SourceFile = (Split-Path $File -Leaf)
    $SourceFileName = $SourceFile.Split(".")[0]

    $DestinationFile = ($DestinationPath + "\" + $SourceFileName + ".wpl")

    Copy-Item $File $DestinationFile -Force

    $wplContent = Get-Content($File)
    $wplContent.Replace("<?zpl version=`"2.0`"?>", "<?wpl version=`"1.0`"?>")
    Out-File -FilePath $DestinationFile -InputObject $wplContent -Force
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

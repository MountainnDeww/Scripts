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

$WplFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))

ForEach ($File In $WplFiles)
{
    $DestinationPath = (Split-Path $File -Parent)
    $SourceFile = (Split-Path $File -Leaf)
    $SourceFileName = $SourceFile.Split(".")[0]

    $DestinationFile = ($DestinationPath + "\" + $SourceFileName + ".zpl")

    Copy-Item $File $DestinationFile -Force

    $zplContent = Get-Content($File)
    $zplContent = $zplContent.Replace("<?wpl version=`"1.0`"?>", "<?zpl version=`"2.0`"?>")
    Out-File -FilePath $DestinationFile -InputObject $zplContent -Force
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

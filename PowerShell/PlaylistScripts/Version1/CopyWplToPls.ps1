Param (
    [Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$PlayListScripts = $env:USERPROFILE + "\OneDrive\Scripts\PowerShell\PlaylistScripts"

$Global:MusicDrive = "M:"
$Global:MusicPath = $MusicDrive + "\Music"
$Global:PlayListPath = $MusicPath + ("\Playlists")

Set-Location $PlayListScripts

# Create the file
Function CreatePLSFile ([String] $SourceFilePath, [String] $DestinationFilePath)
{
    $FileContent = Get-Content $SourceFilePath
    ForEach($Line In $FileContent)
    {
        If ($Line -eq ("<?wpl version=""1.0""?>"))
        {
            Write-ToFile $DestinationFilePath ("[playlist]")
        }

        If ($Line.Contains("<media src="))
        {
            Write-ToFile $DestinationFilePath $Line.Replace("<media src=", "").Replace("/>", "").Replace("""", "").Replace("  ", " ").Trim()
        }
    }
}

# Write string out to file
Function Write-ToFile ([String] $FilePath, [String] $String)
{
    If (!(Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force; Write-Host } 

    Try
    {
        Out-File -FilePath $FilePath -InputObject $String -Append -Force
    }
    Catch [System.IO.IOException]
    {
        $Script:CaughtException = $True
        Write-Host "." -NoNewline
        Start-Sleep 2
        Write-ToFile $FilePath $String
    }
}


$WplFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))

If ($PrintStatus) { Write-Host; Write-Host "Creating PLS Files." -ForegroundColor Green; Write-Host }

ForEach ($File In $WplFiles)
{
    $DestinationPath = (Split-Path $File -Parent)
    $SourceFile = (Split-Path $File -Leaf)
    $SourceFileName = $SourceFile.Split(".")[0]

    $DestinationFile = ($DestinationPath + "\" + $SourceFileName + ".pls")

    CreatePLSFile $File $DestinationFile
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

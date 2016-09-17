Param (
    [String] $FilePath, 
    [String] $MusicPath,
    [Switch] $PrintStatus,
    [Switch] $Relative
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

$RelativePath = "<media src=`"..\"
If (-Not($FileMusicPath)) { $FileMusicPath = [String]::Format("<media src=`"{0}\", ($MusicPath)) }
If (-Not($FileMusicPath.StartsWith("<media src=`""))) { $FileMusicPath = ("<media src=`"" + $MusicPath) }
If (-Not($FileMusicPath.EndsWith("\"))) { $FileMusicPath = ($FileMusicPath + "\") }
$LiteralPath = $FileMusicPath

If ($Relative)
{
    $Script:SearchPath = $LiteralPath
    $Script:ReplacePath = $RelativePath
}
Else
{
    $Script:SearchPath = $RelativePath
    $Script:ReplacePath = $LiteralPath
}


# Clean the file
Function SetMusicFolder ([String] $BackupFilePath, [String] $FilePath)
{
    $FileContent = Get-Content $BackupFilePath
    ForEach($Line In $FileContent)
    {
        If ($Line.Contains($SearchPath))
        {
            Write-ToFile $FilePath $Line.Replace($SearchPath, $ReplacePath)
        }
        Else
        {
            Write-ToFile $FilePath $Line
        }
    }
}

# Write string out to file
Function Write-ToFile ([String] $FilePath, [String] $String)
{
    If (!(Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force; Write-Host } 

    try
    {
        Out-File -FilePath $FilePath -InputObject $String -Append -Force
    }
    catch [System.IO.IOException]
    {
        $Script:CaughtException = $True
        Write-Host "." -NoNewline
        Sleep 2
        Write-ToFile $FilePath $String
    }
}

Function BackupFile ([String] $FilePath)
{
    $BackupPath = ($FilePath + ".bak")
    Copy-Item -LiteralPath $FilePath -Destination $BackupPath
    Return $BackupPath
}

Function ReCreateEmptyFile ([String] $FilePath)
{
    If ((Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force | Out-Null } 
}

If ($FilePath)
{
    $BackupFilePath = BackupFile $FilePath
    ReCreateEmptyFile $FilePath
    SetMusicFolder $BackupFilePath $FilePath
}
Else
{
    Write-Warning "Syntax: SetMusicFolder.ps1 [-FilePath] `"FullPathToFile`" [[-MusicPath] `"FullPathToMusicFolder`"]"
}

If ($CaughtException) { Write-Host }

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

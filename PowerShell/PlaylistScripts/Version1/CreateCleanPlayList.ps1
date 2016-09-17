Param (
    [String] $FilePath, 
    [Switch] $PrintStatus,
    [Switch] $RelativePaths
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

# Clean the file
Function RemovePlayListInfo ([String] $FilePath, [String] $CleanFilePath)
{
    If ($PrintStatus) { Write-Host; Write-Host "Removing Playlists Info." -ForegroundColor Green; Write-Host }

    $LiteralMediaSrc = [String]::Format("<media src=`"{0}\", ($MusicPath))
    $RelativeMediaSrc = "<media src=`"..\"

    $FileContent = Get-Content $FilePath
    ForEach($Line In $FileContent)
    {
        If (-Not($Line.Contains("<meta ")) -and -Not($Line.Contains("<guid")) -and -Not($Line.Contains("<author/>")) -and -Not($Line.Contains("<author />")))
        {
            $NewLine = $Line

            $StringStart = -1

            If ($NewLine.Contains("<head>"))
            {
                $StringStart = $NewLine.IndexOf("<head>")
                $NewLine = ("  " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("</head>"))
            {
                $StringStart = $NewLine.IndexOf("</head>")
                $NewLine = ("  " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("<body>"))
            {
                $StringStart = $NewLine.IndexOf("<body>")
                $NewLine = ("  " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("</body>"))
            {
                $StringStart = $NewLine.IndexOf("</body>")
                $NewLine = ("  " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("<title>"))
            {
                $StringStart = $NewLine.IndexOf("<title>")
                $NewLine = ("    " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("<seq>"))
            {
                $StringStart = $NewLine.IndexOf("<seq>")
                $NewLine = ("    " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("</seq>"))
            {
                $StringStart = $NewLine.IndexOf("</seq>")
                $NewLine = ("    " + $NewLine.SubString($StringStart))
            }

            If ($Line.Contains("<media src="))
            {
                $StringStart = $NewLine.IndexOf("<media src=")
                $NewLine = ("      " + $NewLine.SubString($StringStart))
            }

            If ($RelativePaths -and $NewLine.Contains($LiteralMediaSrc))
            {
                $NewLine = $NewLine.Replace($LiteralMediaSrc, $RelativeMediaSrc)
            }

            If ($NewLine.Contains("&apos;"))
            {
                $NewLine = $NewLine.Replace("&apos;", "'")
            }

            $EndStringStart = -1
            If ($Line.Contains("serviceId=")) { $EndStringStart = $NewLine.IndexOf("serviceId=") }
            ElseIf ($Line.Contains("albumTitle=")) { $EndStringStart = $NewLine.IndexOf("albumTitle=") }
            ElseIf ($Line.Contains("albumArtist=")) { $EndStringStart = $NewLine.IndexOf("albumArtist=") }
            ElseIf ($Line.Contains("trackTitle=")) { $EndStringStart = $NewLine.IndexOf("trackTitle=") }
            ElseIf ($Line.Contains("trackArtist=")) { $EndStringStart = $NewLine.IndexOf("trackArtist=") }
            ElseIf ($Line.Contains("duration=")) { $EndStringStart = $NewLine.IndexOf("duration=") }
            ElseIf ($Line.Contains("cid=")) { $EndStringStart = $NewLine.IndexOf("cid=") }
            ElseIf ($Line.Contains("tid=")) { $EndStringStart = $NewLine.IndexOf("tid=") }

            If ($EndStringStart -ge 0)
            {
                $NewLine = ($NewLine.SubString(0, $EndStringStart) + "/>")
            }

            If ($NewLine.EndsWith("""/>"))
            {
                $NewLine = $NewLine.Replace("""/>", """ />")
            }

            Write-ToFile $CleanFilePath $NewLine
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

Function CreateCleanFile ([String] $FilePath)
{
    $CleanFilePath = ($FilePath + ".clean")
    If ((Test-Path $FilePath)) { New-Item -Type File -Path $CleanFilePath -Force | Out-Null } 
    Return $CleanFilePath
}

Function ReCreateEmptyFile ([String] $FilePath)
{
    If ((Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force | Out-Null } 
}

#Cls

#$Script:FilePath = "D:\Music\Playlists\Favorite Rock.wpl"
#$NewFileParent = Split-Path $FilePath -Parent
#$FileLeaf = Split-Path $FilePath -Leaf
#$FileName = $FileLeaf.Split(".")
#$NewFileLeaf = ($FileName[0] + "_New." + $FileName[1])
#$Script:NewFilePath = Join-Path $NewFileParent -ChildPath $NewFileLeaf

If ($FilePath)
{
    RemovePlayListInfo $FilePath (CreateCleanFile $FilePath)
}
Else
{
    Write-Warning "Syntax: RemovePlayListInfo.ps1 [-FilePath] `"FullPathToFile`""
}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

If ($CaughtException) { Write-Host }

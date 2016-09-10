Param (
    [String] $WplFilePath,
    [String] $ZplFilePath,
    [Switch] $PrintStatus
)

# Get a dictionary of the current script path, name, ext
$ScriptPath = Get-ScriptInfo $PSCommandPath $False

# Compare the files
Function CompareLines ([String] $WplFilePath, [String] $ZplFilePath)
{
    $WplFileContent = Get-Content $WplFilePath
    $ZplFileContent = Get-Content $ZplFilePath
    ForEach($WplLine In $WplFileContent)
    {
        If (!($WplLine.Contains("wpl version")))
        {
            ForEach($ZplLine In $ZplFileContent)
            {
                If (!($WplLine.Contains("zpl version")))
                {
                    If ($WplLine -ne $ZplLine) { "" }
                }
            }
        }
    }
}

If($WplFilePath -and $ZplFilePath) { CompareLines $WplFilePath $ZplFilePath}

If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }

If ($CaughtException) { Write-Host }

Param (
    [String] $FilePath1 = "\\dfs01-p\f$\DFSV5Engines\PipelineLogs\runid_0000005492.log",
    [String] $FilePath2 = "\\dfs01-p\f$\DFSV5Engines\PipelineLogs\runid_0000005501.log"
)

Function GetErrorList($FilePath)
{
    Write-Host "Collecting errors from" (Split-Path $FilePath -Leaf)

    $Count = 0
    [System.Collections.ArrayList] $ErrorList = @()

    $FileContent = Get-Content $FilePath

    ForEach($Line In $FileContent)
    {
        #If ( ($Count -gt 0) -and ($Count % 1000) -eq 0 ) { Write-Host "." -NoNewLine }
        #If ( ($Count -gt 0) -and ($Count % (1000*80) ) -eq 0 ) { Write-Host }

        If ($Line.Contains("[Error] [Cleansing] [InsertOriginalScrubbedSoftwareProducts]"))
        {
            $TempLine = $Line.Substring(90)
            $SplitLine = $TempLine.Split(',')
            $ErrorList.Add($SplitLine) | Out-Null
            $Count++
        }
    }

    Write-Host ([String]::Format("Error count: {0}", $Count)); Write-Host

    #Write-Host; 
    #ForEach($Item In $ErrorList)
    #{
    #    Write-Host $Item
    #}

    Return $ErrorList
}

Function GetMatchingErrorList ($ErrorList1, $ErrorList2)
{
    Write-Host "Looking for matching errors."

    $Count = 0
    [System.Collections.ArrayList] $ErrorList = @()

    ForEach($Item1 In $ErrorArray1)
    {
        ForEach($Item2 In $ErrorArray2)
        {
            #Write-Host "." -NoNewLine

            #If ( ($Item1[0] -eq $Item2[0]) -and ($Item1[1] -eq $Item2[1]) -and ($Item1[2] -eq $Item2[2]) -and ($Item1[3] -eq $Item2[3]) -and ($Item1[4] -eq $Item2[4]) -and ($Item1[5] -eq $Item2[5]) -and ($Item1[6] -eq $Item2[6]) )
            If ( ($Item1[1] -eq $Item2[1]) -and ($Item1[2] -eq $Item2[2]) -and ($Item1[3] -eq $Item2[3]) -and ($Item1[4] -eq $Item2[4]) -and ($Item1[5] -eq $Item2[5]) -and ($Item1[6] -eq $Item2[6]) )
            {
                $ErrorList.Add($Item1) | Out-Null
                $ErrorList.Add($Item2) | Out-Null
                $Count++
            }
        }
    }

    Write-Host ([String]::Format("Matching error count: {0}", $Count)); Write-Host

    Return $ErrorList
}

cls

If (![String]::IsNullOrEmpty($FilePath1) -and ![String]::IsNullOrEmpty($FilePath2) -and (Test-Path $FilePath1) -and (Test-Path $FilePath2))
{
    [System.Collections.ArrayList] $ErrorList1 = @()
    [System.Collections.ArrayList] $ErrorList2 = @()
    [System.Collections.ArrayList] $MatchingErrorList = @()

    $ErrorList1 = GetErrorList $FilePath1
    $ErrorList2 = GetErrorList $FilePath2
    $MatchingErrorList = GetMatchingErrorList $ErrorList1 $ErrorList2

    If ( ($MatchingErrorList) -and ($MatchingErrorList.Count -gt 0) )
    {
        Write-Host; Write-Host "oSWID, newSoftwareName, newVendorName, newMajorVersion, newMinorVersion, newArchitecture, newLanguageID, newLocaleID, overwrite"
        Write-Host "-------------------------------------------------------------------------------------------------------------------------------"
        ForEach ($Item In $MatchingErrorList)
        {
            Write-Host $Item
        }
    }
}
# Latest EOM Files: \\Ca003-prfs001\CA-8\Wells Fargo Consent Order - 6336\Data Files\WF SFTP Transfers\Incoming

Param (
    [String] $InputFile,
    [String] $OutPutFile,
    [String] $OldString,
    [String] $NewString
    #[Switch] $ShowDetails
)

Function Syntax()
{
    Write-Host
    #Write-Warning "Please supply an input and an output file path." 
    Write-Warning "Please supply an input file path." 
    Write-Host
    Write-Host "Syntax: .\Replace.ps1 -InputFile .\Input.txt [-OutPutFile .\Output.txt] [-OldString `"OldString`"] [-NewString `"NewString`"] [-ShowDetails]"
    Write-Host
}

Function TypeFileName([String] $Message, [String] $FilePath)
{
    Write-Host 
    Write-Host "${Message}: [" -NoNewLine -ForegroundColor White
    Write-Host $FilePath -NoNewLine -ForegroundColor Cyan
    Write-Host "] ..." -ForegroundColor White
}

Function TypeReplacementText([String] $OldString, [String] $NewString)
{
    Write-Host 
    Write-Host "Replacing [" -NoNewLine -ForegroundColor White
    Write-Host $OldString -NoNewLine -ForegroundColor Magenta
    Write-Host "] with [" -NoNewLine -ForegroundColor White
    Write-Host $NewString -NoNewLine -ForegroundColor Magenta
    Write-Host "] ..." -ForegroundColor White
}

CLS

#$ArrayOfStrings = @()
If([String]::IsNullOrEmpty($InputFile) -or [String]::IsNullOrEmpty($OldString) -or [String]::IsNullOrEmpty($NewString)) { Syntax }
#If([String]::IsNullOrEmpty($InputFile) -or [String]::IsNullOrEmpty($OutPutFile)) { Syntax }
#If([String]::IsNullOrEmpty($InputFile)) { Syntax }

#If([String]::IsNullOrEmpty($OldString)) { $OldString = "KRONCKE,D`"`"ARCANGELO" }
#If([String]::IsNullOrEmpty($NewString)) { $NewString = "KRONCKE,D ARCANGELO" }

If(-NOT [String]::IsNullOrEmpty($InputFile))
{
    TypeFileName -Message "Reading file content from" -FilePath $InputFile
    
    $EOMFileInput = Get-Content -Path $InputFile

    IF($EOMFileInput -match $OldString) {

        #If($ShowDetails) {
        #    Write-Host; Write-Host "Line containting old string:" -ForegroundColor White
        #    $EOMFileInput -match $OldString
        #}

        TypeReplacementText -OldString $OldString -NewString $NewString
        $EOMFile = $EOMFileInput -replace $OldString, $NewString

        #If( $ShowDetails) {
        #    Write-Host; Write-Host "Line containting new string:" -ForegroundColor White
        #    $EOMFile -match $NewString
        #}

        If([String]::IsNullOrEmpty($OutPutFile)) {
            TypeFileName -Message "Backing up original file to" -FilePath ($InPutFile + ".bak")
            Copy-Item -Path $InPutFile -Destination "$InPutFile.bak"

            TypeFileName -Message "Writing updated content to" -FilePath $InPutFile
            Out-File -FilePath $InPutFile -InputObject $EOMFile -Force -Encoding utf8
        }
        Else {
            TypeFileName -Message "Writing updated content to" -FilePath $OutPutFile
            Out-File -FilePath $OutPutFile -InputObject $EOMFile -Force -Encoding utf8
        }
    }
    Else
    {
        Write-Host; Write-Warning "The old string [$OldString] was not found. No changes have been made."
    }
}
Write-Host; Write-Host "Script Complete!" -ForegroundColor Green

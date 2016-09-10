#############
# Variables #
#############

$Global:DataDrive = "C:"
$Global:BackupDrive = "D:"


#############
# Functions #
#############

Function Global:LS-Archive { ls -Attributes Archive }
Function Global:LS-Directory { ls -Directory }
Function Global:LS-File { ls -File }
Function Global:LS-Hidden { ls -Hidden }
Function Global:LS-Readonly { ls -Readonly }
Function Global:LS-System { ls -System }
Function Global:LS-Name  { ls -Name }
Function Global:LS-SortName { ls | Sort-Object }
Function Global:LS-SortDirectory { ls | Sort-Object -Property Directory -Descending }
Function Global:LS-SortExtension { ls | Sort-Object -Property Extension }
Function Global:LS-SortLength { ls | Sort-Object -Property Length }
Function Global:LS-SortMode { ls | Sort-Object -Property Mode }
Function Global:LS-SortTime { ls | Sort-Object -Property LastWriteTime }
Function Global:LS-Recurse { ls -Recurse $args }

Function Global:LS-FullPath { If ($args.Count -eq 0) { ls $PWD | select { $_.FullName } } else { ForEach ($arg In $args) { ls $PWD -Filter $arg | select { $_.FullName } } } }
Function Global:LS-FullPathRecurse { If ($args.Count -eq 0) { ls $PWD -Recurse | select { $_.FullName } } else { ForEach ($arg In $args) { ls $PWD -Recurse -Filter $arg | select { $_.FullName } } } }

#############
# Microsoft #
#############

#Function Global:FBLESC { pushd $Env:FBLESC }
#Function Global:FBLESCACDC { pushd $Env:FBLESCACDC }


###########
# Aliases #
###########

Set-Alias -Name LSA  -Value LS-Archive -Scope Global
Set-Alias -Name LSD  -Value LS-Directory -Scope Global
Set-Alias -Name LSF  -Value LS-File -Scope Global
Set-Alias -Name LSFP  -Value LS-FullPath -Scope Global
Set-Alias -Name LSFPR  -Value LS-FullPathRecurse -Scope Global
Set-Alias -Name LSH  -Value LS-Hidden -Scope Global
Set-Alias -Name LSRO  -Value LS-Readonly -Scope Global
Set-Alias -Name LSS  -Value LS-System -Scope Global
Set-Alias -Name LSR -Value LS-Recurse -Scope Global
Set-Alias -Name LSN  -Value LS-Name -Scope Global
Set-Alias -Name LSSN -Value LS-SortName -Scope Global
Set-Alias -Name LSSD -Value LS-SortDirectory -Scope Global
Set-Alias -Name LSSE -Value LS-SortExtension -Scope Global
Set-Alias -Name LSSL -Value LS-SortLength -Scope Global
Set-Alias -Name LSSM -Value LS-SortMode -Scope Global
Set-Alias -Name LSST -Value LS-SortTime -Scope Global

#####################################
# Variables ## Functions ## Aliases #
#####################################

If (Test-Path($Home))
{
    Function Global:Home { pushd $Home }
}

If (Test-Path(($Env:SystemDrive + "\")))
{
    $Global:Root = ($Env:SystemDrive + "\")
    Function Global:Root { pushd $Root }
}

If (Test-Path(($Home + "\OneDrive")))
{
    $Global:OneDrive = ($Home + "\OneDrive")
    Function Global:OneDrive { pushd $OneDrive }
    Set-Alias -Name od -Value OneDrive -Scope Global
}
Else
{
    $Global:OneDrive = ($Home + "\SkyDrive")
    Function Global:OneDrive { pushd $OneDrive }
    Set-Alias -Name od -Value OneDrive -Scope Global
}

$Global:OneDocs = ($OneDrive + "\Documents")
Function Global:OneDocs { pushd $OneDocs }
Set-Alias -Name odd -Value OneDocs -Scope Global

$Global:OneScripts = ($OneDrive + "\Scripts")
Function Global:OneScripts { pushd $OneScripts }
Set-Alias -Name ods -Value OneScripts -Scope Global

$Global:OnePSScripts = ($OneScripts + "\PowerShell")
Function Global:OnePSScripts { pushd $OnePSScripts }
Set-Alias -Name odpss -Value OnePSScripts -Scope Global

$Global:OnePSModules = ($OnePSScripts + "\Modules")
Function Global:OnePSModules { pushd $OnePSModules }
Set-Alias -Name odpsm -Value OnePSModules -Scope Global

$Global:OneSDScripts = ($OneScripts + "\SDScripts")
Function Global:OneSDScripts { pushd $OneSDScripts }
Set-Alias -Name odsds -Value OneSDScripts -Scope Global

$Global:SDScripts = $OneSDScripts
Function Global:SDScripts { pushd $SDScripts }
Set-Alias -Name sdscr -Value SDScripts -Scope Global

If (Test-Path env:SysInternals) {
    $Global:SysInternals = ($env:SysInternals)
    Function Global:SysInternals { pushd $SysInternals }
    Set-Alias -Name sysint -Value SysInternals -Scope Global
}

If (Test-Path env:Tools)
{
    $Global:Tools = $env:Tools
    Function Global:Tools { pushd $Tools }
}
ElseIf (Test-Path(($Env:SystemDrive + "\tools")))
{
    $Global:Tools = ($Env:SystemDrive + "\tools")
    Function Global:Tools { pushd $Tools }
}

If (Test-Path env:Bin)
{
    $Global:Bin = $env:Bin
    Function Global:Bin { pushd $Bin }
}
ElseIf (Test-Path(($Env:SystemDrive + "\tools\bin")))
{
    $Global:Bin = ($Env:SystemDrive + "\tools\bin")
    Function Global:Bin { pushd $Bin }
}

If (Test-Path env:IDW)
{
    $Global:IDW = $env:IDW
    Function Global:IDW { pushd $IDW }
}
ElseIf (Test-Path(($Env:SystemDrive + "\tools\bin\idw")))
{
    $Global:IDW = ($Env:SystemDrive + "\tools\bin\idw")
    Function Global:IDW { pushd $IDW }
}

If (Test-Path(${Env:ProgramFiles(x86)} + "\Microsoft Visual Studio 12.0\Common7\IDE"))
{
    $Global:IDE = (${Env:ProgramFiles(x86)} + "\Microsoft Visual Studio 12.0\Common7\IDE")
    Function Global:IDE { pushd $IDE }
}
ElseIf (Test-Path($Env:ProgramFiles + "\Microsoft Visual Studio 12.0\Common7\IDE"))
{
    $Global:IDE = ($Env:ProgramFiles + "\Microsoft Visual Studio 12.0\Common7\IDE")
    Function Global:IDE { pushd $IDE }
}

If (Test-Path($IDE + "\devenv.exe"))
{
    $Global:DevEnv = ($IDE + "\devenv.exe")
    Function Global:DevEnv { Start "$DevEnv $args" }
}

Function Global:Copy-TempC { copy $args C:\temp }
Set-Alias -Name CTC -Value Copy-TempC -Scope Global

Function Global:Copy-TempD { copy $args D:\temp }
Set-Alias -Name CTD -Value Copy-TempD -Scope Global

Function Global:Copy-TempE { copy $args E:\temp }
Set-Alias -Name CTE -Value Copy-TempE -Scope Global

$Global:TEMPC = "C:\temp\"
Function Global:TEMPC { pushd $TEMPC$args }

$Global:TEMPD = "D:\temp\"
Function Global:TEMPD { pushd $TEMPD$args }

$Global:TEMPE = "E:\temp\"
Function Global:TEMPE { pushd $TEMPE$args }


$Global:SqlBin = (${Env:ProgramFiles(x86)} + "\Microsoft SQL Server\110\DAC\bin")
If (Test-Path $SqlBin)
{
    Function Global:SqlBin { pushd $SqlBin }
    #Set-Alias -Name SqlBin -Value SqlBin -Scope Global

    $Global:SqlPackageEXE = ($SqlBin + "\SqlPackage.exe")
    If (Test-Path $SqlPackageEXE)
    {
        Function global:Start-SqlPackage { Start "$SqlPackageEXE $args" }
        Set-Alias -Name ssp -Value Start-SqlPackage -Scope Global
    }
}

If (!$OneDrive)
{
    $Global:OneDrive = ($Env:UserProfile + "\OneDrive")
    If (!(Test-Path($Global:OneDrive)))
    {
        $Global:OneDrive = ($Env:UserProfile + "\SkyDrive")
        If (!(Test-Path($Global:OneDrive)))
        {
            Write-Warning "Local OneDrive (or SkyDrive) does not exist"
        }
    }
}
If ($OneDrive -and ([String]::IsNullOrEmpty($OneDrive) -or ($Env:OneDrive -ne $OneDrive))) { PS-SetX -VariableName "OneDrive" -VariableValue $OneDrive -Reset }

If (!$Scripts) { $Global:Scripts = ($OneDrive + "\Scripts") }
If ($Scripts -and ([String]::IsNullOrEmpty($Scripts) -or ($Env:Scripts -ne $Scripts))) { PS-SetX -VariableName "Scripts" -VariableValue $Scripts -Reset }

If (!$SDScripts) { $Global:SDScripts = ($OneDrive + "\Scripts\SDScripts") }
If ($SDScripts -and ([String]::IsNullOrEmpty($SDScripts) -or ($Env:SDScripts -ne $SDScripts))) { PS-SetX -VariableName "SDScripts" -VariableValue $SDScripts -Reset }

If (!$SysInternals) { $Global:SysInternals = ($Env:SystemDrive + "\Tools\SysInternalsSuite") }
If ($SysInternals -and ([String]::IsNullOrEmpty($SysInternals) -or ($Env:SysInternals -ne $SysInternals))) { PS-SetX -VariableName "SysInternals" -VariableValue $SysInternals -Reset }


#############
# Microsoft #
#############

#$Global:MSSDK = "C:\Program Files (x86)\Microsoft SDKs"
#Function Global:MSSDK { start "$MSSDK" }

#$Global:UltraEdit = ($Env:ProgramFiles + "\IDM Computer Solutions\UltraEdit")
#If (Test-Path $UltraEdit)
#{
#    Function Global:UltraEdit { pushd $UltraEdit }
#    Set-Alias -Name ue -Value UltraEdit -Scope Global

#    $Global:UltraEditEXE = ($UltraEdit + "\uedit32.exe")
#    If (Test-Path $UltraEditEXE)
#    {
#        Function global:Start-UltraEdit { Start "$UltraEditEXE $args" }
#        Set-Alias -Name sue -Value Start-UltraEdit -Scope Global
#    }
#}

#$Global:UltraEdit32 = (${Env:ProgramFiles(x86)} + "\IDM Computer Solutions\UltraEdit")
#If (Test-Path $UltraEdit32)
#{
#    Function Global:UltraEdit32 { pushd $UltraEdit32 }
#    Set-Alias -Name ue32 -Value UltraEdit32 -Scope Global
    
#    $Global:UltraEdit32EXE = ($UltraEdit32 + "\Uedit32.exe")
#    If (Test-Path $UltraEdit32EXE)
#    {
#        Function global:Start-UltraEdit32 { Start "$UltraEdit32EXE $args" }
#        Set-Alias -Name sue32 -Value Start-UltraEdit32 -Scope Global
#    }
#}

#$Global:BeyondCompare = ($Env:ProgramFiles + "\Beyond Compare 2")
#If (Test-Path $BeyondCompare)
#{
#    Function Global:BeyondCompare { pushd $BeyondCompare }
#    Set-Alias -Name bc2 -Value BeyondCompare -Scope Global

#    $Global:BeyondCompareEXE = ($BeyondCompare + "\BC2.exe")
#    If (Test-Path $BeyondCompareEXE)
#    {
#        Function global:Start-BeyondCompare { Start "$BeyondCompareEXE $args" }
#        Set-Alias -Name sbc2 -Value Start-BeyondCompare -Scope Global
#    }
#}

#$Global:BeyondCompare32 = (${Env:ProgramFiles(x86)} + "\Beyond Compare 2")
#If (Test-Path $BeyondCompare32)
#{
#    Function Global:BeyondCompare32 { pushd $BeyondCompare32 }
#    Set-Alias -Name bc232 -Value BeyondCompare32 -Scope Global

#    $Global:BeyondCompare32EXE = ($BeyondCompare32 + "\BC2.exe")
#    If (Test-Path $BeyondCompare32EXE)
#    {
#        Function global:Start-BeyondCompare32 { Start "$BeyondCompare32EXE $args" }
#        Set-Alias -Name sbc232 -Value Start-BeyondCompare32 -Scope Global
#    }
#}

#$Global:Odd = ($Env:ProgramFiles + "\Odd")
#If (Test-Path $Odd)
#{
#    Function Global:Odd { pushd $Odd }

#    $Global:OddEXE = ($Odd + "\Odd.exe")
#    If (Test-Path $OddEXE)
#    {
#        Function global:Start-Odd { Start "$OddEXE $args" }
#        Set-Alias -Name sodd -Value Start-Odd -Scope Global
#    }
#}

#$Global:Odd32 = (${Env:ProgramFiles(x86)} + "\Odd")
#If (Test-Path $Odd32)
#{
#    Function Global:Odd32 { pushd $Odd32 }

#    $Global:Odd32EXE = ($Odd32 + "\Odd.exe")
#    If (Test-Path $Odd32EXE)
#    {
#        Function global:Start-Odd32 { Start "$Odd32EXE $args" }
#        Set-Alias -Name sodd32 -Value Start-Odd32 -Scope Global
#    }
#}

#$Global:SDB = ($Env:ProgramFiles + "\Development Tools")
#If (Test-Path $SDB)
#{
#    Function Global:SDB { pushd $SDB }

#    $Global:SDBEXE = ($SDB + "\sdb.exe")
#    If (Test-Path $SDBEXE)
#    {
#        Function global:Start-SDB { Start "$SDBEXE $args" }
#        Set-Alias -Name ssdb -Value Start-SDB -Scope Global
#    }
#}

#$Global:SDB32 = (${Env:ProgramFiles(x86)} + "\Development Tools")
#If (Test-Path $SDB32)
#{
#    Function Global:SDB32 { pushd $SDB32 }

#    $Global:SDB32EXE = ($SDB32 + "\sdb.exe")
#    If (Test-Path $SDB32EXE)
#    {
#        Function global:Start-SDB32 { Start "$SDB32EXE $args" }
#        Set-Alias -Name ssdb32 -Value Start-SDB32 -Scope Global
#    }
#}

#$Global:MyScratch = "\\scratch2\scratch\$Env:UserName"
#Function Global:MyScratch { pushd $MyScratch }
#Set-Alias -Name myscr -Value MyScratch -Scope Global

#$Global:MyPublic = "\\ae-share\public\$Env:UserName"
#Function Global:MyPublic { pushd $MyPublic }
#Set-Alias -Name mypub -Value MyPublic -Scope Global

#Function Global:AESCRATCH { start \\ae-share\scratch\$args }
#Function Global:AEPUBLIC  { start \\ae-share\public\$args }
#Function Global:NHSCRATCH { start \\ae-share\scratch\normh\$args }
#Function Global:NHPUBLIC  { start \\ae-share\public\normh\$args }

#Function Global:EFE         { start \\ae-share\public\efe\$args }
#Function Global:EFESCRIPTS  { start \\ae-share\public\efe\scripts\$args }
#Function Global:EFETEST     { start \\ae-share\public\efe\test\$args }
#Function Global:EFETOOLS    { start \\ae-share\public\efe\tools\$args }

#If (!$SbWccDev) { $Global:SbWccDev = "D:\SB_WCC_DEV" }
#If ($SbWccDev -and ([String]::IsNullOrEmpty($Env:SbWccDev) -or ($Env:SbWccDev -ne $SbWccDev))) { PS-SetX -VariableName "SbWccDev" -VariableValue $SbWccDev -Reset }

#If (!$WinmainWTRCompass) { $Global:WinmainWTRCompass = "D:\Winmain_WTR_Compass" }
#If ($WinmainWTRCompass -and ([String]::IsNullOrEmpty($Env:WinmainWTRCompass) -or ($Env:WinmainWTRCompass -ne $WinmainWTRCompass))) { PS-SetX -VariableName "WinmainWTRCompass" -VariableValue $WinmainWTRCompass -Reset }

#If (!$EFE) { $Global:EFE = "\\ae-share\public\efe" }
#If ($EFE -and ([String]::IsNullOrEmpty($Env:EFE) -or ($Env:EFE -ne $EFE))) { PS-SetX -VariableName "EFE" -VariableValue $EFE -Reset }

#If (!$MyScratch) { $Global:MyScratch = "\\scratch2\scratch\$Env:UserName" }
#If ($MyScratch -and ([String]::IsNullOrEmpty($Env:MyScratch) -or ($Env:MyScratch -ne $MyScratch))) { PS-SetX -VariableName "MyScratch" -VariableValue $MyScratch -Reset }

#If (!$MyPublic) { $Global:MyPublic = "\\ae-share\public\$Env:UserName" }
#If ($MyPublic -and ([String]::IsNullOrEmpty($Env:MyPublic) -or ($Env:MyPublic -ne $MyPublic))) { PS-SetX -VariableName "MyPublic" -VariableValue $MyPublic -Reset }

#If (!$OsBinRoot) { $Global:OsBinRoot = $Env:OsBinRoot }
#If ($OsBinRoot -and ([String]::IsNullOrEmpty($Env:OsBinRoot) -or ($Env:OsBinRoot -ne $OsBinRoot))) { PS-SetX -VariableName "OsBinRoot" -VariableValue $OsBinRoot -Reset }

#If(!$TestBinRoot) { $Global:TestBinRoot = $Env:TestBinRoot }
#If ($TestBinRoot -and ([String]::IsNullOrEmpty($Env:TestBinRoot) -or ($Env:TestBinRoot -ne $TestBinRoot))) { PS-SetX -VariableName "TestBinRoot" -VariableValue $TestBinRoot -Reset }

#If (!$TAEF) { $TAEF = ($Env:ProgramFiles + "\Microsoft Visual Studio 10.0\Common7\IDE\Extensions\Microsoft\WinIDE\TAEF") }
#If ($TAEF -and ([String]::IsNullOrEmpty($Env:TAEF) -or ($Env:TAEF -ne $TAEF))) { PS-SetX -VariableName "TAEF" -VariableValue $TAEF -Reset }

#If (!$TestScripts) { $Global:TestScripts = ($Env:UserProfile + "\Desktop\TestScripts") }
#If ($TestScripts -and ([String]::IsNullOrEmpty($Env:TestScripts) -or ($Env:TestScripts -ne $TestScripts))) { PS-SetX -VariableName "TestScripts" -VariableValue $TestScripts -Reset }

#Switch ($Env:PROCESSOR_ARCHITECTURE)
#{
#    "x86" { $Global:OBJ = "objfre\i386" }
#    "amd64" { $Global:OBJ = "objfre\amd64" }
#    "arm" { $Global:OBJ = "objfre\arm" }
#}

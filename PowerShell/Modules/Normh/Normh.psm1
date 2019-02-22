#############
# Variables #
#############

$Global:DataDrive = "C:"
$Global:BackupDrive = "D:"


#############
# Functions #
#############

If ((Get-ChildItem Function:LS-Archive       -ErrorAction Ignore) -eq $NULL) { Function Global:LS-Archive       { Get-ChildItem -Attributes Archive } }
If ((Get-ChildItem Function:LS-Directory     -ErrorAction Ignore) -eq $NULL) { Function Global:LS-Directory     { Get-ChildItem -Directory } }
If ((Get-ChildItem Function:LS-File          -ErrorAction Ignore) -eq $NULL) { Function Global:LS-File          { Get-ChildItem -File } }
If ((Get-ChildItem Function:LS-Hidden        -ErrorAction Ignore) -eq $NULL) { Function Global:LS-Hidden        { Get-ChildItem -Hidden } }
If ((Get-ChildItem Function:LS-Readonly      -ErrorAction Ignore) -eq $NULL) { Function Global:LS-Readonly      { Get-ChildItem -Readonly } }
If ((Get-ChildItem Function:LS-System        -ErrorAction Ignore) -eq $NULL) { Function Global:LS-System        { Get-ChildItem -System } }
If ((Get-ChildItem Function:LS-Name          -ErrorAction Ignore) -eq $NULL) { Function Global:LS-Name          { Get-ChildItem -Name } }
If ((Get-ChildItem Function:LS-SortName      -ErrorAction Ignore) -eq $NULL) { Function Global:LS-SortName      { Get-ChildItem | Sort-Object } }
If ((Get-ChildItem Function:LS-SortDirectory -ErrorAction Ignore) -eq $NULL) { Function Global:LS-SortDirectory { Get-ChildItem | Sort-Object -Property Directory -Descending } }
If ((Get-ChildItem Function:LS-SortExtension -ErrorAction Ignore) -eq $NULL) { Function Global:LS-SortExtension { Get-ChildItem | Sort-Object -Property Extension } }
If ((Get-ChildItem Function:LS-SortLength    -ErrorAction Ignore) -eq $NULL) { Function Global:LS-SortLength    { Get-ChildItem | Sort-Object -Property Length } }
If ((Get-ChildItem Function:LS-SortMode      -ErrorAction Ignore) -eq $NULL) { Function Global:LS-SortMode      { Get-ChildItem | Sort-Object -Property Mode } }
If ((Get-ChildItem Function:LS-SortTime      -ErrorAction Ignore) -eq $NULL) { Function Global:LS-SortTime      { Get-ChildItem | Sort-Object -Property LastWriteTime } }
If ((Get-ChildItem Function:LS-Recurse       -ErrorAction Ignore) -eq $NULL) { Function Global:LS-Recurse       { Get-ChildItem -Recurse $args } }

If ((Get-ChildItem Function:LS-FullPath -ErrorAction Ignore) -eq $NULL) { Function Global:LS-FullPath { If ($args.Count -eq 0) { Get-ChildItem $PWD | select { $_.FullName } } else { ForEach ($arg In $args) { Get-ChildItem $PWD -Filter $arg | select { $_.FullName } } } } }
If ((Get-ChildItem Function:LS-FullPathRecurse -ErrorAction Ignore) -eq $NULL) { Function Global:LS-FullPathRecurse { If ($args.Count -eq 0) { Get-ChildItem $PWD -Recurse | select { $_.FullName } } else { ForEach ($arg In $args) { Get-ChildItem $PWD -Recurse -Filter $arg | select { $_.FullName } } } } }

#############
# Microsoft #
#############

#Function Global:FBLESC { Push-Location $Env:FBLESC }
#Function Global:FBLESCACDC { Push-Location $Env:FBLESCACDC }


###########
# Aliases #
###########

IF ( (Get-ChildItem Alias:LSA   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSA   -Value LS-Archive         -Scope Global }
IF ( (Get-ChildItem Alias:LSD   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSD   -Value LS-Directory       -Scope Global }
IF ( (Get-ChildItem Alias:LSF   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSF   -Value LS-File            -Scope Global }
IF ( (Get-ChildItem Alias:LSFP  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSFP  -Value LS-FullPath        -Scope Global }
IF ( (Get-ChildItem Alias:LSFPR -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSFPR -Value LS-FullPathRecurse -Scope Global }
IF ( (Get-ChildItem Alias:LSH   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSH   -Value LS-Hidden          -Scope Global }
IF ( (Get-ChildItem Alias:LSRO  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSRO  -Value LS-Readonly        -Scope Global }
IF ( (Get-ChildItem Alias:LSS   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSS   -Value LS-System          -Scope Global }
IF ( (Get-ChildItem Alias:LSR   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSR   -Value LS-Recurse         -Scope Global }
IF ( (Get-ChildItem Alias:LSN   -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSN   -Value LS-Name            -Scope Global }
IF ( (Get-ChildItem Alias:LSSN  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSSN  -Value LS-SortName        -Scope Global }
IF ( (Get-ChildItem Alias:LSSD  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSSD  -Value LS-SortDirectory   -Scope Global }
IF ( (Get-ChildItem Alias:LSSE  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSSE  -Value LS-SortExtension   -Scope Global }
IF ( (Get-ChildItem Alias:LSSL  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSSL  -Value LS-SortLength      -Scope Global }
IF ( (Get-ChildItem Alias:LSSM  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSSM  -Value LS-SortMode        -Scope Global }
IF ( (Get-ChildItem Alias:LSST  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name LSST  -Value LS-SortTime        -Scope Global }

#####################################
# Variables ## Functions ## Aliases #
#####################################

If ( (Test-Path($Home)) -and ((Get-ChildItem Function:Home -ErrorAction Ignore) -eq $NULL) ) { Function Global:Home { Push-Location $Home } }

# Path to the VFA (VariableFunctionAlias) script
$NewVFAScript = ("$Home\Documents\Scripts\PowerShell\Setup\CreateNormhVFA.ps1")

# If (Test-Path("$Env:SystemDrive\"))
# {
#     $Global:Root = ("$Env:SystemDrive\")
#     If ( (Test-Path($Root)) -and (Get-ChildItem Function:Root -ErrorAction Ignore) -eq $NULL ) { Function Global:Root { Push-Location $Root } }
# }
New-VFA -Name "Root" -VType "Path" -Path "$Env:SystemDrive\" -File $NewVFAScript -Clean

$NewPath = $Home + "\source"
If (Test-Path($NewPath)) { New-VFA -Name "Source" -Alias "src" -VType "Path" -Path $NewPath -File $NewVFAScript }

$NewPath = $Home + "\source\repos"
If (Test-Path($NewPath)) { New-VFA -Name "Repos" -Alias "sr" -VType "Path" -Path $NewPath -File $NewVFAScript }


If (Test-Path("$Home\OneDrive")) { $Global:OneDrive = "$Home\OneDrive" }
ElseIf (Test-Path("$Home\SkyDrive")) { $Global:OneDrive = "$Home\SkyDrive" }
# If ( (Test-Path($OneDrive)) -and (Get-ChildItem Function:OneDrive -ErrorAction Ignore) -eq $NULL ) { Function Global:OneDrive { Push-Location $OneDrive } }
# If ( ((Get-ChildItem Function:OneDrive -ErrorAction Ignore) -ne $NULL) -and (Get-ChildItem Alias:od -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name od -Value OneDrive -Scope Global }
New-VFA -Name "OneDrive" -Alias "od" -VType "Path" -Path $OneDrive -File $NewVFAScript 

If (Test-Path($OneDrive))
{
	# $Global:OneDocs = "$OneDrive\Documents"
	# If ( (Get-ChildItem Function:OneDocs -ErrorAction Ignore) -eq $NULL ) { Function Global:OneDocs { Push-Location $OneDocs } }
	# If ( (Get-ChildItem Alias:odd  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name odd -Value OneDocs -Scope Global }
	New-VFA -Name "OneDocs" -Alias "odd" -VType "Path" -Path "$OneDrive\Documents" -File $NewVFAScript 
	
	# $Global:OneScripts = "$OneDocs\Scripts"
	# If ( (Get-ChildItem Function:OneScripts -ErrorAction Ignore) -eq $NULL ) { Function Global:OneScripts { Push-Location $OneScripts } }
	# If ( (Get-ChildItem Alias:ods  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name ods -Value OneScripts -Scope Global }
	New-VFA -Name "OneScripts" -Alias "ods" -VType "Path" -Path "$OneDocs\Scripts" -File $NewVFAScript 
	
	# $Global:OnePSScripts = "$OneScripts\PowerShell"
	# If ( (Get-ChildItem Function:OnePSScripts -ErrorAction Ignore) -eq $NULL ) { Function Global:OnePSScripts { Push-Location $OnePSScripts } }
	# If ( (Get-ChildItem Alias:odpss  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name odpss -Value OnePSScripts -Scope Global }
	New-VFA -Name "OnePSScripts" -Alias "odpss" -VType "Path" -Path "$OneScripts\PowerShell" -File $NewVFAScript 
	
	# $Global:OnePSModules = "$OnePSScripts\Modules"
	# If ( (Get-ChildItem Function:OnePSModules -ErrorAction Ignore) -eq $NULL ) { Function Global:OnePSModules { Push-Location $OnePSModules } }
	# If ( (Get-ChildItem Alias:odpsm  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name odpsm -Value OnePSModules -Scope Global }
	New-VFA -Name "OnePSModules" -Alias "odpsm" -VType "Path" -Path "$OnePSScripts\Modules" -File $NewVFAScript 
	
	# $Global:OneSDScripts = "$OneScripts\SDScripts"
	# If ( (Get-ChildItem Function:OneSDScripts -ErrorAction Ignore) -eq $NULL ) { Function Global:OneSDScripts { Push-Location $OneSDScripts } }
	# If ( (Get-ChildItem Alias:odsds  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name odsds -Value OneSDScripts -Scope Global }
	New-VFA -Name "OneSDScripts" -Alias "odsds" -VType "Path" -Path "$OneScripts\SDScripts" -File $NewVFAScript 
	
	# $Global:SDScripts = $OneSDScripts
	# If ( (Get-ChildItem Function:SDScripts -ErrorAction Ignore) -eq $NULL ) { Function Global:SDScripts { Push-Location $SDScripts } }
	# If ( (Get-ChildItem Alias:sdscr  -ErrorAction Ignore) -eq $NULL ) { Set-Alias -Name sdscr -Value SDScripts -Scope Global }
	New-VFA -Name "SDScripts" -Alias "sdscr" -VType "Path" -Path $OneSDScripts -File $NewVFAScript
}

# If (Test-Path env:Tools) { $Global:Tools = $env:Tools }
# ElseIf (Test-Path(($Env:SystemDrive + "\tools"))) { $Global:Tools = ($Env:SystemDrive + "\tools") }
# If ( (Get-ChildItem Function:SDScripts -ErrorAction Ignore) -eq $NULL ) { Function Global:Tools { Push-Location $Tools } }
#New-VFA -Name "Tools" -File $NewVFAScript -VType "ENV" -Path $NULL

# If (Test-Path env:Bin) { $Global:Bin = $env:Bin }
# ElseIf (Test-Path(($Env:SystemDrive + "\tools\bin"))) { $Global:Bin = ($Env:SystemDrive + "\tools\bin") }
# New-VFA -Name "Bin" -File $NewVFAScript -VType "ENV" -Path $NULL
#If ( (Get-ChildItem Function:SDScripts -ErrorAction Ignore) -eq $NULL ) { Function Global:Bin { Push-Location $Bin } }

# If (Test-Path env:IDW) { $Global:IDW = $env:IDW }
# ElseIf (Test-Path(($Env:SystemDrive + "\tools\bin\idw"))) { $Global:IDW = ($Env:SystemDrive + "\tools\bin\idw") }
# If ( (Get-ChildItem Function:IDW -ErrorAction Ignore) -eq $NULL ) { Function Global:IDW { Push-Location $IDW } }
#New-VFA -Name "IDW" -File $NewVFAScript -VType "ENV" -Path $NULL

If (Test-Path("${Env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE")) { $Global:IDE = ("${Env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE") }
ElseIf (Test-Path("$Env:ProgramFiles\Microsoft Visual Studio 12.0\Common7\IDE")) { $Global:IDE = ("$Env:ProgramFiles\Microsoft Visual Studio 12.0\Common7\IDE") }
# If ( (Get-ChildItem Function:IDE -ErrorAction Ignore) -eq $NULL ) { Function Global:IDE { Push-Location $IDE } }
New-VFA -Name "IDE" -VType "Path" -Path $IDE -File $NewVFAScript

If (Test-Path("$IDE\devenv.exe")) { $Global:DevEnv = ("$IDE\devenv.exe") }
If ( (Get-ChildItem Function:DevEnv -ErrorAction Ignore) -eq $NULL ) { Function Global:DevEnv { Start "$DevEnv $args" } }
If (($DevEnv.Length -ne 0) -and ((Get-ChildItem Alias:$DevEnv -ErrorAction Ignore) -eq $NULL)) { Set-Alias -Name "de" -Value $DevEnv -Scope Global }

Function Global:Copy-TempC { copy $args C:\temp }
Set-Alias -Name CTC -Value Copy-TempC -Scope Global

Function Global:Copy-TempD { copy $args D:\temp }
Set-Alias -Name CTD -Value Copy-TempD -Scope Global

Function Global:Copy-TempE { copy $args E:\temp }
Set-Alias -Name CTE -Value Copy-TempE -Scope Global
$Global:TEMPC = "C:\temp\"
Function Global:TEMPC { Push-Location $TEMPC$args }
$Global:TEMPD = "D:\temp\"
Function Global:TEMPD { Push-Location $TEMPD$args }
$Global:TEMPE = "E:\temp\"
Function Global:TEMPE { Push-Location $TEMPE$args }

$Global:SqlBin = (${Env:ProgramFiles(x86)} + "\Microsoft SQL Server\110\DAC\bin")
If (Test-Path $SqlBin)
{
    Function Global:SqlBin { Push-Location $SqlBin }
    #Set-Alias -Name SqlBin -Value SqlBin -Scope Global

    $Global:SqlPackageEXE = ($SqlBin + "\SqlPackage.exe")
    If (Test-Path $SqlPackageEXE)
    {
        Function global:Start-SqlPackage { Start "$SqlPackageEXE $args" }
        Set-Alias -Name ssp -Value Start-SqlPackage -Scope Global
    }
}

If (Test-Path($OneDrive))
{
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
}

If (!$Scripts) { $Global:Scripts = "$Home\Documents\Scripts" }
If ($Scripts -and ([String]::IsNullOrEmpty($Scripts) -or ($Env:Scripts -ne $Scripts))) { PS-SetX -VariableName "Scripts" -VariableValue $Scripts -Reset }

If (Test-Path($OneDrive))
{
	If (!$SDScripts) { $Global:SDScripts = ($OneSDScripts) }
	If ($SDScripts -and ([String]::IsNullOrEmpty($SDScripts) -or ($Env:SDScripts -ne $SDScripts))) { PS-SetX -VariableName "SDScripts" -VariableValue $SDScripts -Reset }
}

If ($Env:ComputerName -eq "HALLASUS64") { If (!$SysInternals) { $Global:SysInternals = ($Env:SystemDrive + "\Tools\SysInternalsSuite") } }
If ($Env:ComputerName -eq "CA003-EQLT353") { If (!$SysInternals) { $Global:SysInternals = ($Home + "\Tools\SysInternalsSuite") } }
If ($SysInternals -and ([String]::IsNullOrEmpty($SysInternals) -or ($Env:SysInternals -ne $SysInternals))) { PS-SetX -VariableName "SysInternals" -VariableValue $SysInternals -Reset }
# If (Test-Path env:SysInternals) {
#     #$Global:SysInternals = ($env:SysInternals)
#     Function Global:SysInternals { Push-Location $SysInternals }
#     Set-Alias -Name sysint -Value SysInternals -Scope Global
# }
New-VFA -Name "SysInternals" -Alias "sysint" -VType "ENV" -File $NewVFAScript

# Call the VFA script
. $NewVFAScript



#############
# Microsoft #
#############

#$Global:MSSDK = "C:\Program Files (x86)\Microsoft SDKs"
#Function Global:MSSDK { start "$MSSDK" }

#$Global:UltraEdit = ($Env:ProgramFiles + "\IDM Computer Solutions\UltraEdit")
#If (Test-Path $UltraEdit)
#{
#    Function Global:UltraEdit { Push-Location $UltraEdit }
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
#    Function Global:UltraEdit32 { Push-Location $UltraEdit32 }
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
#    Function Global:BeyondCompare { Push-Location $BeyondCompare }
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
#    Function Global:BeyondCompare32 { Push-Location $BeyondCompare32 }
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
#    Function Global:Odd { Push-Location $Odd }

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
#    Function Global:Odd32 { Push-Location $Odd32 }

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
#    Function Global:SDB { Push-Location $SDB }

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
#    Function Global:SDB32 { Push-Location $SDB32 }

#    $Global:SDB32EXE = ($SDB32 + "\sdb.exe")
#    If (Test-Path $SDB32EXE)
#    {
#        Function global:Start-SDB32 { Start "$SDB32EXE $args" }
#        Set-Alias -Name ssdb32 -Value Start-SDB32 -Scope Global
#    }
#}

#$Global:MyScratch = "\\scratch2\scratch\$Env:UserName"
#Function Global:MyScratch { Push-Location $MyScratch }
#Set-Alias -Name myscr -Value MyScratch -Scope Global

#$Global:MyPublic = "\\ae-share\public\$Env:UserName"
#Function Global:MyPublic { Push-Location $MyPublic }
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

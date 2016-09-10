<#
    .SYNOPSIS
        Update Tool Installations

    .DESCRIPTION
        Install common test tools and utilities

    .PARAMETER -AtlasTools
        Install Atlas Tools

    .PARAMETER -Bugger
        Install Bugger

    .PARAMETER -Odd
        Install Odd

    .PARAMETER -IDNA
        Install IDNA

    .PARAMETER -SDB3
        Install SDB3

    .PARAMETER -CodeFlow
        Install CodeFlow

    .PARAMETER -SDPack
        Install SDPack

    .PARAMETER -MagicMouse
        Install MagicMouse

    .PARAMETER -Win7Razzle
        Install Win7Razzle

    .INPUTS
        <Inputs if any, otherwise state None>

    .OUTPUTS
        <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

    .EXAMPLE
        UpdateToolInstalls.ps1 [-AtlasTools] [-Bugger] [-Odd] [-IDNA] [-SDB3] [-CodeFlow] [-SDPack] [-MagicMouse] [-Win7Razzle]

    .NOTES
        Script          : UpdateToolInstalls.ps1
        Version         : 1.0
        Author          : Norm Hall
        Email           : normh@microsoft.com, halln77@hotmail.com
        Creation Date   : May 15, 2013
        Purpose/Change  : Initial release
        Comment         :        
	#>

#[CmdletBinding()]

Param (
    [Switch] $AtlasTools,
    [Switch] $Bugger,
    [Switch] $Odd,
    [Switch] $IDNA,
    [Switch] $SDB3,
    [Switch] $CodeFlow,
    [Switch] $SDPack,
    [Switch] $MagicMouse,
    [Switch] $Win7Razzle,
    [Switch] $Debug,
    [Switch] $Clean,
    [Switch] $Reset
)

Function CopyFiles ($Source)
{
	Remove-Item $InstallFolder -Recurse
	Copy-Item "$Source\*.*" "$InstallFolder\*.*" -Recurse
}

Function AtlasTools
{
	start file://atlasrelease/tools/ATLAS/ClientApps/install.js
}

Function Bugger
{
	CopyFiles "\\tkfiltoolbox\Tools\Bugger\2013"
	& Bugger2013Setup.msi
}

Function MagicMouse
{
	CopyFiles "\\tkfiltoolbox\tools\MagicMouse\2.0.X.0"
	& UpdateRelease.cmd
}

Function Odd
{
	CopyFiles "\\tkfiltoolbox\tools\23785\2.7.0.1\msi"
	& Odd.msi
}

Function IDNA
{
	Remove-Item $InstallFolder -Recurse
	$ARCH = "x86"
	If ($PROCESSOR_ARCHITECTURE -eq "AMD64") { $ARCH = "x64" }
	If (Test-Path "$Env:ProgramFiles\Debugging Tools for Windows(x86)") { $DBGFOLDER = "$Env:ProgramFiles\Debugging Tools for Windows(x86)" }
	If (Test-Path "$Env:ProgramFiles\Debugging Tools for Windows(x64)") { $DBGFOLDER = "$Env:ProgramFiles\Debugging Tools for Windows(x64)" }
	If (Test-Path "$Env:SystemDrive\Debuggers") { $DBGFOLDER = "$Env:SystemDrive\Debuggers" }
	Copy-Item "\\tkfiltoolbox\tools\TimeTravelTracing\6.02.9250_a\$ARCH\*.*" "$DBGFOLDER\TTT\*.*" -Recurse
}

Function SDB3
{
	CopyFiles "\\tkfiltoolbox\tools\20301\SDB 3 (.NET 2.0)"
	& "SDB Setup.msi"
}

Function CodeFlow
{
	Start "http://toolbox/codeflow/Project/FileDownload.aspx?DownloadId=41629&TrackDownload=true"
}

Function SDPack
{
	Start "http://toolbox/21839/Project/FileDownload.aspx?DownloadId=32421&TrackDownload=true"
}

Function Win7Razzle
{
	Start "http://toolbox/win7razzlelauncher/Project/FileDownload.aspx?DownloadId=30375&ReturnUrl=http%3a%2f%2ftoolbox%2fWiki%2fView.aspx%3fProjectName%3dwin7razzlelauncher"
}

$InstallFolder = "$TEMP\Install"
If(!(Test-Path $InstallFolder)) { New-Item $InstallFolder -ItemType Directory }
Remove-Item $InstallFolder -Recurse

CD $InstallFolder

$All = $true

If ($AtlasTools) { $All = $false; AtlasTools }
If ($Bugger) { $All = $false; Bugger }
If ($Odd) { $All = $false; Odd }
If ($IDNA) { $All = $false; IDNA }
If ($SDB3) { $All = $false; SDB3 }
If ($CodeFlow) { $All = $false; CodeFlow }
If ($SDPack) { $All = $false; SDPack }
If ($MagicMouse) { $All = $false; MagicMouse }
If ($Win7Razzle) { $All = $false; Win7Razzle }

If ($All)
{
 AtlasTools
 Bugger
 Odd
 IDNA
 SDB3
 CodeFlow
 SDPack
 #MagicMouse
 #Win7Razzle
}

Remove-Item $InstallFolder -Recurse

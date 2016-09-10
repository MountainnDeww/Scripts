<#
    .SYNOPSIS
       	Update Tools in WinDir

    .DESCRIPTION
        Copy common IDW tools into WinDir

    .PARAMETER -AccChecker
        Install Accessability Checker

    .EXAMPLE
        UpdateTools.ps1 [-AccChecker]

    .NOTES
        Script          : UpdateTools.ps1
        Version         : 1.0
        Author          : Norm Hall
        Email           : normh@microsoft.com, halln77@hotmail.com
        Creation Date   : May 15, 2013
        Purpose/Change  : Initial release
        Comment         :        
	#>

#[CmdletBinding()]

Param (
    [Switch] $AccChecker
)

Function AccChecker
{
	& $SCRIPTS\Setup\EnableNetFx3.cmd
 	If ( Test-Path \\tkfiltoolbox\tools\AccCheck\2 )
	{
		#& xcopy "\\tkfiltoolbox\tools\AccCheck\2\$Env:Processor_Architecture\AccChecker\*.*" "$Desktop\AccChecker\*.*" /diecry
		Copy-Item "\\tkfiltoolbox\tools\AccCheck\2\$Env:Processor_Architecture\AccChecker\*.*" "$Desktop\AccChecker\*.*" -Recurse
 	}
}

Function CopyFiles ( $Files )
{
	If ( Test-Path $OsBinRoot )
	{
		ForEach ( $File In $Files )
		{
			#& xcopy "$OsBinRoot\$Root\$File.*" "%windir%\%~1.*" /diecry > nul
			If ( !( Test-Path $WinDir\$File ) ) { Copy-Item $OsBinRoot\$Root\$File $WinDir\$File }
		}
	}
}

If ( !$OsBinRoot ) { & .\SetBinRoot.ps1 }

If ( $OsBinRoot )
{
    $ROOT = "IDW"
    $FILES = @( "depends.exe", "depends.dll", "filever.exe", "kill.exe", "sfpcopy.exe", "sleep.exe", "tlist.exe", "traceview.exe" )
    CopyFiles $FILES
}

If ( $AccChecker ) { AccChecker }

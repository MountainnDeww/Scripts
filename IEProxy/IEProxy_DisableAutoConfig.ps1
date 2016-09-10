<# HEADER
    .SYNOPSIS
        To Disables the Auto Configuration script.

    .DESCRIPTION
        Edits the registry then refreshes IE.
        
    .PARAMETER [none]
        No parameters

    .EXAMPLE
        IEProxy_DisableAutoConfig.ps1


    .NOTES
        Script:         IEProxy_DisableAutoConfig.ps1
        Version: 		1.0
        Author:         Norm Hall
        Email:          halln77@hotmail.com
        Creation Date:  June 13, 2016
        Purpose/Change: Initial release
        Change Date:    
        Purpose/Change: 
        Comment: 
        
        Registry Provider
        https://technet.microsoft.com/en-us/library/hh847848.aspx       
#>

Param (
    [Switch] $Debug = $False
)

#Disable the AutoConfigURL
$IEPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

$RegKeyIE = Get-ItemProperty -Path $IEPath

If (($RegKeyIE.AutoConfigURL).Length -gt 0)
{
    Remove-ItemProperty -Path $IEPath -Name AutoConfigURL
}


#Uncheck the Auto Config Script checkbox
$IEConnPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"
$RegKeyIEConn = Get-ItemProperty -Path $IEConnPath

$Data = $RegKeyIEConn.DefaultConnectionSettings
$Data[8] = 1
Set-ItemProperty -Path $IEConnPath -Name DefaultConnectionSettings -Value $Data
If($Debug) {
    $RegKeyIEConn.DefaultConnectionSettings[8]
}

$Data = $RegKeyIEConn.SavedLegacySettings
$Data[8] = 1
Set-ItemProperty -Path $IEConnPath -Name SavedLegacySettings -Value $Data
If($Debug) {
    $RegKeyIEConn.SavedLegacySettings[8]
}


#Refresh IE
#If you don't want to have to restart IE you can add this to your Powershell script:

$source=@"
[DllImport("wininet.dll")]
public static extern bool InternetSetOption(int hInternet, int dwOption, int lpBuffer, int dwBufferLength);  
"@

#Create type from source
$wininet = Add-Type -memberDefinition $source -passthru -name InternetSettings

#INTERNET_OPTION_PROXY_SETTINGS_CHANGED
$wininet::InternetSetOption([IntPtr]::Zero, 95, [IntPtr]::Zero, 0)|out-null

#INTERNET_OPTION_REFRESH
$wininet::InternetSetOption([IntPtr]::Zero, 37, [IntPtr]::Zero, 0)|out-null

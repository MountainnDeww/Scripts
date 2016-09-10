<# HEADER
    .SYNOPSIS
        To Enable the Auto Configuration script.

    .DESCRIPTION
        Edits the registry then refreshes IE.
        
    .PARAMETER [none]
        No parameters

    .EXAMPLE
        IEProxy_EnableAutoConfig.ps1


    .NOTES
        Script:         IEProxy_EnableAutoConfig.ps1
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

#Enable the AutoConfigURL
$IEPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$IEConnPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"

$RegKeyIE = Get-ItemProperty -Path $IEPath
$RegKeyIEConn = Get-ItemProperty -Path $IEConnPath

If (($RegKeyIE.AutoConfigURL).Length -eq 0)
{
    If($Debug) {
        New-ItemProperty -Path $IEPath -Name AutoConfigURL -PropertyType String -Value "http://10.21.23.11:8083/proxy.pac"
    }
    Else
    {
        New-ItemProperty -Path $IEPath -Name AutoConfigURL -PropertyType String -Value "http://10.21.23.11:8083/proxy.pac" | Out-Null
    }
}


#Check the Auto Config Script checkbox
$Data = $RegKeyIEConn.DefaultConnectionSettings
$Data[8] = 5
Set-ItemProperty -Path $IEConnPath -Name DefaultConnectionSettings -Value $Data
If($Debug) {
    $RegKeyIEConn.DefaultConnectionSettings[8]
}
$Data = $RegKeyIEConn.SavedLegacySettings
$Data[8] = 5
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

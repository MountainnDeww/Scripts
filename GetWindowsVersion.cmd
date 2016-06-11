:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Get Windows version, architecture and computer name useing WMI
::
:: Get PowerShell version
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@CLS
@Echo Windows:
@powershell -Command "Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName . | Format-Table -Property Name,Version,CSDVersion,OSArchitecture,BuildType,CSName -Wrap"
@Echo PowerShell:
@powershell -Command "Get-Host | Format-Table -Property Version"

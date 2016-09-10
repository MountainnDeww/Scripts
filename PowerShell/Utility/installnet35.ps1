#HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Servicing\LocalSourcePath to be “c:\somefolder” 

function IsAdmin
{
  $wid=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp=new-object System.Security.Principal.WindowsPrincipal($wid)
  $adm=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  return $prp.IsInRole($adm)
}

function IsTestOverride
{
    if (Test-Path -path HKLM:\Software\Microsoft\dog8)
    {
        Write-Host "SetTestOverride Found"
        return $TRUE
    }   
    else
    {
        Write-Host "SetTestOverride Not Found"
        return $FALSE
    }
    Write-Host "IsTestOverride RETURN FALSE"
    return $FALSE
}

function RemTestOverride
{
    # Probe dog8:
    if (!(Test-Path -path HKLM:\Software\Microsoft\dog8))
    {
        Write-host "SetTestOverride Not set, return FALSE"
        return $FALSE
    }
    elseif (Test-Path -path HKLM:\Software\Microsoft\dog8)
    {
        Remove-Item -path HKLM:\Software\Microsoft\dog8
        Write-host "dog8\SetTestOverride Removed, return TRUE"
        return $TRUE
    }
    Write-host "RemTestOverride Return FALSE"
    return $FALSE
}

function SetTestOverride
{
    # Create dog8 if you haven't done so already:
    if (!(Test-Path -path HKLM:\Software\Microsoft\dog8))
    {
        md HKLM:\Software\Microsoft\dog8
        if (New-ItemProperty HKLM:\Software\Microsoft\dog8 -name "settestoverride" -value "1" -propertyType dword)
        {
            Write-host "SetTestOverride Return TRUE"
            return $TRUE
        }
    }
    else
    {
        Remove-ItemProperty -path HKLM:\Software\Microsoft\dog8 -name "settestoverride"
        New-ItemProperty HKLM:\Software\Microsoft\dog8 -name "settestoverride" -value "1" -propertyType dword
        Write-host "SetTestOverride Return TRUE"
        return $TRUE
    }
    Write-host "SetTestOverride Return FALSE"
    return $FALSE
}

function SetBuildOverride
{
    # Create policy key if you haven't done so already:
    if (!(Test-Path -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing))
    {
        md HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing
    
        if (New-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -name "LocalSourcePath" -value $buildpathoverride)
        {
            Write-host "BuildPathOverride Return TRUE"
            return $TRUE
        }
    }
    else
    {
        Remove-ItemProperty -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -name "LocalSourcePath"
        New-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -name "LocalSourcePath" -value $buildpathoverride
        Write-host "BuildPathOverride Return TRUE"
        return $TRUE
    }
    Write-host "SetBuildOverride Return FALSE"
    return $FALSE
}


if (-not $(IsAdmin))
{
    # Re-run as admin
    $psi = new-object System.Diagnostics.ProcessStartInfo "powershell"
    $psi.Verb = "runas"
    $psi.arguments = "-executionpolicy unrestricted -file $($MyInvocation.MyCommand.Path.ToString())"
    $dummy = [System.Diagnostics.Process]::Start($psi)
    return
}

#Init Vars
$TestOverrideSet=0
$BuildPathOverrideSet=0


if (($args[0] -eq "-?") -or ($args[0] -eq "-help"))
{
   Write-Host ""
   Write-Host "Usage: enablenet35.ps1 "
   Write-Host "           sets the group policy path for installing .net 3.5 from build shares"
   Write-Host ""
   Write-Host "Example: enablenet35.ps1"
   Write-Host "Example: enablenet35.ps1 settestoverride \\server\share\sources\SxS"
   Write-Host "         (this will tell the script to override the normal location of the share to a custom location)"
   Write-Host ""
   Write-Host "****contact govm for issues****"
   exit
}

$a = $args.length
if ($a -eq 0)
{
    Write-host "No Build Path Override Present. Setting Location Automatically"
    $buildpathoverride = ""
    #However, we don't want the group policy to overwrite the machine state if the user had previously set the testoverride
    #Once testoverride is set, the user would have to clear the registry key with removetestoverride
    if ($(IsTestOverride))
    {
        $TestOverrideSet = 1
        Write-host ""
        Write-host "TestOverride Previously Set, using existing build path info"
        Write-host "If you wish to revert to default auto-set behaviour"
        Write-host "run 'installnet35.ps1 removetestoverride'"
        Write-host ""
    }
}
elseif (($args[0] -eq "settestoverride") -and ($args[1].length -ne 0))
{
    Write-host "Build Path Override Present."
    $buildpathoverride = $args[1]
    Write-host Custom Build Path is: $buildpathoverride
    if ($(SetTestOverride))
        {
            $TestOverrideSet = 1
        }
    if ($(SetBuildOverride))
        {
            $BuildPathOverrideSet = 1
        }
}
elseif ($args[0] -eq "removetestoverride")
{
    Write-host "Removing SetTestOverride Flag"
    if ($(RemTestOverride))
    {
        exit
    }
    exit
}
elseif ($args[0] -ne "settestoverride")
{
   Write-Host "****Invalid Parameter****"
   Write-Host ""
   Write-Host "Usage: enablenet35.ps1 "
   Write-Host "           sets the group policy path for installing .net 3.5 from build shares"
   Write-Host ""
   Write-Host "Example: enablenet35.ps1"
   Write-Host "Example: enablenet35.ps1 settestoverride \\server\share\sources\SxS"
   Write-Host "         (this will tell the script to override the normal location of the share to a custom location)"
   Write-Host ""
   Write-Host "****contact govm for issues****"
   exit
}

Write-Host BuildPathOverrideSet $BuildPathOverrideSet
Write-host TestOverrideSet $TestOverrideSet

if (($BuildPathOverrideSet -eq 0) -and ($TestOverrideSet -eq 0))
{
    $buildstring = $(get-itemproperty hklm:\software\microsoft\windows` nt\currentversion buildlabex).buildlabex
    Write-host Build string is: $buildstring

    $proxy = new-webserviceproxy "http://BuildServices01.ntdev.corp.microsoft.com/Web/ReleaseApi/FindBuild.asmx"

    $path = $proxy.GetPathFromBuildNameEx($buildstring, "", "client_$([globalization.cultureinfo]::CurrentCulture.Name)", "")
    Write-host Path to Build is: $path

    # Create policy key if you haven't done so already:
    if (!(Test-Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing))
    {
        md HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing
        if (New-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -name "LocalSourcePath" -value "$path\sources\SxS")
        {
            Write-host "BuildPath Return TRUE"
            return $TRUE
        }
    }
    else
    {
        Remove-ItemProperty -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -name "LocalSourcePath"
        New-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Servicing -name "LocalSourcePath" -value "$path\sources\SxS"
        Write-host "BuildPath Return TRUE"
        return $TRUE
    }
    Write-host "BuildPath Return FALSE"
    return $FALSE
}
Write-Host "****contact govm for issues****"
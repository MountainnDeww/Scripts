<# HEADER
    .SYNOPSIS
        To Edit / Display Internet Proxy Settings.

    .DESCRIPTION
        Used to Enable, Disable or Display the Internet Proxy Settings.
        
    .PARAMETER EnableProxy
        Used to enable the proxy setting.

    .PARAMETER DisableProxy
        Used to disable the proxy setting.

    .PARAMETER DisplayProxy
        Used to display the proxy setting.

    .PARAMETER Debug
        Used to debug the script.

    .EXAMPLE
        ProfileSetup.ps1

    .EXAMPLE
        LanSetting.ps1 -EnableProxy

    .EXAMPLE
        LanSetting.ps1 -EnableProxy -Debug

    .NOTES
        Script:         LanSetting.ps1
        Version: 		1.0
        Author:         Norm Hall
        Email:          halln77@hotmail.com
        Creation Date:  January 01, 2013
        Purpose/Change: Initial release
        Change Date:    June 08, 2013
        Purpose/Change: Clean up script
        Comment:        
#>

Param (
    [Switch] $EnableProxy,
    [Switch] $DisableProxy,
    [Switch] $DisplayProxy,
    [Switch] $Debug = $False
)

Function EnableProxy()
{
    If ($Debug) { Write-Host "Enabling proxy." }

    # Click the Lan Settings button
    If ($Debug) { Write-Host "Clicking Lan Settings Button." }
    [System.Windows.Forms.SendKeys]::SendWait("%l")
    $result = $p.WaitForInputIdle(500)

    #Clear the Windows CLipboard
    #[Windows.Clipboard]::SetText("text")
    If ($Debug) { Write-Host "Clearing Clipboard." }
    [Windows.Clipboard]::Clear()

    # Read Configuration Script Address
    If ($Debug) { Write-Host "Reading proxy URL." }
    [System.Windows.Forms.SendKeys]::SendWait("{TAB 2}^c")
    $result = $p.WaitForInputIdle(500)

    #Test if the Windows Clipboard matches the Proxy URL
    If ([Windows.Clipboard]::GetText() -eq $ProxyURL)
    {
        If ($Debug) { Write-Host "Proxy URL = $ProxyURL" }

        #Display configuration status
        Write-Host "Automatic configuration script enabled."

        # Close dialog
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER}")
        $result = $p.WaitForInputIdle(500)
    }
    Else
    #If not, then set the Proxy URL
    {
        If ($Debug) { Write-Host "Setting proxy URL." }

        # Enable automatic configuration script
        [System.Windows.Forms.SendKeys]::SendWait("%s%r")
        $result = $p.WaitForInputIdle(500)

        # Set proxy URL
        [System.Windows.Forms.SendKeys]::SendWait($ProxyURL)
        $result = $p.WaitForInputIdle(500)

        #Display configuration status
        Write-Host "Automatic configuration script enabled."

        # Close dialog
        [System.Windows.Forms.SendKeys]::SendWait("{TAB 2}{ENTER}")
        $result = $p.WaitForInputIdle(500)
    }
}

Function DisableProxy()
{
    If ($Debug) { Write-Host "Disabling proxy." }

    # Click the Lan Settings button
    If ($Debug) { Write-Host "Clicking Lan Settings Button." }
    [System.Windows.Forms.SendKeys]::SendWait("%l")
    $result = $p.WaitForInputIdle(500)

    #Clear the Windows CLipboard
    If ($Debug) { Write-Host "Clearing Clipboard." }
    [Windows.Clipboard]::Clear()

    # Read Configuration Script Address
    If ($Debug) { Write-Host "Reading proxy URL." }
    [System.Windows.Forms.SendKeys]::SendWait("{TAB 2}^c")
    $result = $p.WaitForInputIdle(500)


    #Test if the Windows Clipboard matches the Proxy URL
    If ([Windows.Clipboard]::GetText() -eq $ProxyURL)
    {
        If ($Debug) { Write-Host "Proxy URL = $ProxyURL" }

        # Disable automatic configuration script
        [System.Windows.Forms.SendKeys]::SendWait("%s")
        $result = $p.WaitForInputIdle(500)

        #Clear the Windows CLipboard
        If ($Debug) { Write-Host "Clearing Clipboard." }
        [Windows.Clipboard]::Clear()

        #Try
        #{
        #    [Windows.Clipboard]::Clear()
        #}
        #Catch [System.Exception]
        #{
        #    Write-Warning "System.Exception 'Windows.Clipboard'" 
        #}
        #Catch [InvalidOperation]
        #{
        #    Write-Warning "InvalidOperation 'Windows.Clipboard'" 
        #}
        #Catch [RuntimeException]
        #{
        #    Write-Warning "RuntimeException 'Windows.Clipboard'" 
        #}
        #Catch [TypeNotFound]
        #{
        #    Write-Warning "TypeNotFound 'Windows.Clipboard'" 
        #}

        # Read Configuration Script Address
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}^c")
        If ($Debug) { Write-Host "Reading proxy URL." }
        $result = $p.WaitForInputIdle(500)

        #Test if the Windows Clipboard is empty
        If ([Windows.Clipboard]::GetText() -eq "")
        {
            #Display configuration status
            If ($Debug) { Write-Host "Proxy URL = nothing." }
            Write-Host "Automatic configuration script disabled."

            # Close dialog
            [System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER}")
            $result = $p.WaitForInputIdle(500)
        }

    }
    Else
    {
        #Display configuration status
        If ($Debug) { Write-Host "Close Dialog" }
        Write-Host "Automatic configuration script disabled."

        # Close dialog
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER}")
        $result = $p.WaitForInputIdle(500)
    }

}

Function DisplayProxy()
{
    If ($Debug) { Write-Host "Displaying proxy." }

    # Click the Lan Settings button
    If ($Debug) { Write-Host "Clicking Lan Settings Button." }
    [System.Windows.Forms.SendKeys]::SendWait("%l")
    $result = $p.WaitForInputIdle(500)

    #Clear the Windows CLipboard
    If ($Debug) { Write-Host "Clearing Clipboard." }
    #[Windows.Clipboard]::SetText("text")
    [Windows.Clipboard]::Clear()

    # Read Configuration Script Address
    If ($Debug) { Write-Host "Reading proxy URL." }
    [System.Windows.Forms.SendKeys]::SendWait("{TAB 2}^c")
    $result = $p.WaitForInputIdle(500)

    #Test if the Windows Clipboard matches the Proxy URL
    If ([Windows.Clipboard]::GetText() -eq $ProxyURL)
    {
        #Display configuration status
        If ($Debug) { Write-Host "Proxy URL = $ProxyURL" }
        Write-Host "Automatic configuration script enabled: $ProxyURL"

        # Close dialog
        [System.Windows.Forms.SendKeys]::SendWait("{TAB 2}{ENTER}")
        $result = $p.WaitForInputIdle(500)
    }
    Else
    {
        #Display configuration status
        If ($Debug) { Write-Host "Proxy URL = nothing" }
        Write-Host "Automatic configuration script Disabled."

        # Close dialog
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER}")
        $result = $p.WaitForInputIdle(500)
    }
}

# Open the Internet Options Dialog -> Connections Tab
Function OpenDialog ()
{
    #& "$env:windir\System32\inetcpl.cpl"

    # Setup the starup image and arguments
    $Script:psi = [Diagnostics.ProcessStartInfo]("$env:windir\System32\rundll32.exe")
    $psi.Arguments = "shell32.dll,Control_RunDLL inetcpl.cpl,,4"

    # Launch the app
    $Script:p = [Diagnostics.Process]::Start($psi)
    $result = $p.WaitForInputIdle(500)

    # Select the app window
    [Microsoft.VisualBasic.Interaction]::AppActivate($p.ID)
    $result = $p.WaitForInputIdle(500)

    #$p.CloseMainWindow()
    #$p.Close()
    #$p.Kill()

}

# Close the Internet Options Dialog
Function CloseDialog ()
{
    # Close dialog
    [System.Windows.Forms.SendKeys]::SendWait("{TAB 5}{ENTER}")
    $result = $p.WaitForInputIdle(500)
}

# Clear the screen
CLS

# Add required assemblies
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# Windows.Clipboard
Add-Type -Assembly PresentationCore

# Proxy URL to search for
$ProxyURL = "http://10.21.23.11:8083/proxy.pac"

# Variable to hold Process return status
$result = ""

# Open the Internet Options Dialog -> Connections Tab
OpenDialog

# Enable, Disable or Display the Proxy URL
If ($EnableProxy) { EnableProxy }
If ($DisableProxy) { DisableProxy }
If ($DisplayProxy) { DisplayProxy }

# Close the Internet Options Dialog
CloseDialog

<# HEADER
    .SYNOPSIS
        To Open Internet Proxy Settings Connections Tab, LAN Settings Dialog.

    .DESCRIPTION
        Used to  the dialog windows for editing LAN settings.
        
    .PARAMETER [none]
        No parameters

    .EXAMPLE
        IECOnnectionsLan.ps1


    .NOTES
        Script:         LanSetting.ps1
        Version: 		1.0
        Author:         Norm Hall
        Email:          halln77@hotmail.com
        Creation Date:  June 15, 2016
        Purpose/Change: Initial release
        Change Date:    
        Purpose/Change: 
        Comment:        
#>

Param (
    [Switch] $Debug = $False
)

#Open the Local Area Network (LAN) Settings dialog
Function OpenLanSettingsDialog()
{
    # Click the Lan Settings button
    If ($Debug) { Write-Host "Clicking Lan Settings Button." }
    [System.Windows.Forms.SendKeys]::SendWait("%l")
    $result = $p.WaitForInputIdle(500)
}

# Open the Internet Options Dialog -> Connections Tab
Function OpenIEDialog ()
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
Function CloseIEDialog ()
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

# Variable to hold Process return status
$result = ""

# Open the Internet Options Dialog -> Connections Tab
OpenIEDialog

#Open the Local Area Network (LAN) Settings dialog
OpenLanSettingsDialog

# Close the Internet Options Dialog
#CloseIEDialog

 <#
    .SYNOPSIS
        Common Powershell Module.

    .DESCRIPTION
        Common.psm1 - Module containing common powershell methods.

    .NOTES
        Script          : Common.psm1
        Version         : 1.0
        Author          : Norm Hall
        Email           : normh@microsoft.com, halln77@hotmail.com
        Creation Date   : January 18, 2013
        Purpose/Change  : Initial release
        Change Date     : June 20, 2013
        Purpose/Change  : Remove methods
        Comment         :        
#>

#[CmdletBinding()]

# Global Session Variables
$Global:ServiceState_Stopped = 1
$Global:ServiceState_Running = 4
$Global:DefaultSeconds = New-TimeSpan -Seconds 30

# Pause
Function Global:Pause { Read-Host 'Press [Enter] to continue ...' | Out-Null }

# Notepad++
$NPP = [String]::Format("{0}\Notepad++\notepad++.exe", ${env:ProgramFiles(x86)})
Function Global:NPP { & "$NPP" $args }

# Refresh Modules - Copy down any changed files and re-import modules
Function Global:Refresh-Modules
{
	#CLS
	
    #UpdateFiles (Get-ChildItem -Path $SkyPSScripts -Recurse) (Get-ChildItem -Path $PSScripts -Recurse)

    Copy-Item -Path $PSOriginalUserModules\* -Destination $PSUserModulePath -Recurse -Force
	Write-Host "Modules Copied to $PSUserModulePath" -ForegroundColor Green

    $ErrorActionPreference = "Stop"
    Try
    {
        Copy-Item -Path $PSOriginalUserModules\* -Destination $PSWindowsModulePath -Recurse -Force
		Write-Host "Modules Copied to $PSWindowsModulePath" -ForegroundColor Green
    }
    Catch [System.UnauthorizedAccessException]
    {
        Write-Warning ([String]::Format("Copy-Item Access Denied [{0}]`nRun this script elevated.", $PSWindowsModulePath))
        Throw [System.UnauthorizedAccessException]
    }
    $ErrorActionPreference = "Continue"

    Remove-Module Normh -Force
    Remove-Module Environment -Force
    Remove-Module Common -Force
    Remove-Module URLs -Force
    Remove-Module Shares -Force
    Remove-Module Locations -Force

    Import-Module Locations -Force -Global -DisableNameChecking
    Import-Module Shares -Force -Global -DisableNameChecking
    Import-Module URLs -Force -Global -DisableNameChecking
    Import-Module Common -Force -Global -DisableNameChecking
    Import-Module Environment -Force -Global -DisableNameChecking
    Import-Module Normh -Force -Global -DisableNameChecking

	Write-Host; Write-Host "Refresh Complete!" -ForegroundColor Green; Write-Host
}

# Write string out to profile
Function Global:Write-ToProfile([string] $FilePath, [string] $String, [switch] $BlankBefore, [switch] $BlankAfter)
{
    If (!(Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force }
    If ($BlankBefore) { Write-ToFile -File $FilePath -String [String]::Empty }
    Write-ToFile -File $FilePath -String $String
    If ($BlankAfter) { Write-ToFile -File $FilePath -String [String]::Empty }
}

# Create a new empty file
Function Global:New-EmptyFile([String] $FilePath)
{
    If (!(Test-Path $FilePath)) { New-Item -Type File -Path $FilePath -Force | Out-Null }
    else { Write-Host "$FilePath already exists."}
}

# Write string out to file
Function Global:Write-ToFile($File, [String] $String, [Switch] $ANSI)
{
    If ($ANSI) { Out-File -FilePath $File -InputObject "$String" -Append -Encoding ascii -Force }
    Else { Out-File -FilePath $File -InputObject "$String" -Append -Force }
}

# Write a global variabel to the profile
Function Global:Write-VariableToProfile([String] $Variable, [String] $String, [Boolean] $Force)
{
    $FoundVar = $False
    $VariableString = [String]::Empty
    $ProfileContent = Get-Content $Profile
    ForEach($Line In $ProfileContent)
    {
        If ($Line.StartsWith("`$$Variable") -or $Line.StartsWith("`$Global:$Variable"))
        {
            $FoundVar = $True
            $VariableString = $Line.Split("=")[1].Trim()
        }
    }
    If ($FoundVar)
    {
        $VariableValue = $ExecutionContext.InvokeCommand.ExpandString($VariableString)
        $VariableValue = $VariableValue.TrimStart("`"").TrimEnd("`"")
        If ($VariableValue -ne $String)
        {
            Write-Warning "Variable already exists"
            Write-Warning "Existing: `$$Variable = $VariableValue"
            Write-Warning "     New: `$$Variable = $String"
            If($Force)
            {
                Write-ToProfile "`$Global:$Variable = `"$String`""
                Write-Host "Forced writting variable to file."
            }
        }
    }
    Else
    {
        Write-ToProfile "`$Global:$Variable = `"$String`""
    }
}

# Add a line of text to the Profile
Function Global:Write-LineToProfile([String] $NewLine)
{
    $FoundLine = $False
    $ProfileContent = Get-Content $Profile
    ForEach($Line In $ProfileContent)
    {
        If ($Line.StartsWith("$NewLine"))
        {
            $FoundLine = $True
        }
    }

    If (!$FoundLine)
    {
        Write-ToProfile $NewLine
    }
}

Function Global:Get-ScriptInfo ($ScriptFullPath, $Debug)
{
    If ($ScriptFullPath.Length -gt 0)
    {
        #$Global:ScriptFullPath = $PSCommandPath
        #$Global:ScriptFullPath = $MyInvocation.MyCommand.Path
        $ScriptPath = Split-Path $ScriptFullPath -Parent
        #$ScriptDrive = $ScriptPath.Split("\")[0]
        $ScriptDrive = Split-Path $ScriptFullPath -Qualifier
        #$ScriptFile = $ScriptFullPath.Remove(0,$ScriptPath.Length+1)
        $ScriptFile = Split-Path $ScriptFullPath -Leaf
        $ScriptFileArray = $ScriptFile.Split(".")
        $ScriptExt = $ScriptFileArray[$ScriptFileArray.Count-1]
        $ScriptName = $Null
        ForEach($Item In $ScriptFileArray)
        {
            If ($Item -ne $ScriptExt)
            {
                If ($ScriptName)
                {
                    $ScriptName = $ScriptName + "." + $Item
                }
                Else
                {
                    $ScriptName = $Item
                }
            }
        }

        If ($Debug)
        {
            Write-Host "ScriptFullPath : $ScriptFullPath"
            Write-Host "ScriptPath     : $ScriptPath"
            Write-Host "ScriptDrive    : $ScriptDrive"
            Write-Host "ScriptFile     : $ScriptFile"
            Write-Host "ScriptFileArray: $ScriptFileArray"
            Write-Host "ScriptName     : $ScriptName"
            Write-Host "ScriptExt      : $ScriptExt"
        }

        $ScriptDictionary = @{"FullPath" = $ScriptFullPath; "Drive" = $ScriptDrive; "Path" = $ScriptPath; "File" = $ScriptFile; "Name" = $ScriptName; "Ext" = $ScriptExt}
    }
    Return $ScriptDictionary
}

# Get the BuildLabEx value from the registry
Function Global:Get-BuildLabEx
{
    Return (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx
}

# Get the Lacale name from the registry
Function Global:Get-LocaleName
{
    Return (Get-ItemProperty -Path 'HKCU:\Control Panel\International').LocaleName
}

# Get Data from the Registry
Function Global:Get-RegistryValue([String] $KeyPath, [String] $KeyName)
{
    If (Test-Path $KeyPath)
    {
        Try
        {
            Get-ItemProperty -Path $KeyPath -Name $KeyName -ErrorAction SilentlyContinue
        }
        Catch
        {
            Return $null
        }
    }
}

# Set Data to the Registry
Function Global:Set-RegistryValue([String] $KeyPath, [String] $KeyName, [String] $KeyValue, [String] $DataType)
{
    If (!(Test-Path $KeyPath))
    {
        CreateNewRegKey $KeyPath
    }

    If ([String]::IsNullOrEmpty((Get-RegistryValue $KeyPath $KeyName)))
    {
        New-ItemProperty -Path $KeyPath -Name $KeyName -Value $KeyValue -PropertyType $DataType
        Write-Host "Created new registry value: `nKeyPath $KeyPath `nKeyName $KeyName `nKeyValue $KeyValue `nDataType $DataType"
    }
    Else
    {
        Set-ItemProperty -Path $KeyPath -Name $KeyName -Value $KeyValue
        Write-Host "Set registry value: `nKeyPath $KeyPath `nKeyName $KeyName `nKeyValue $KeyValue `nDataType $DataType"
    }
}

# Remove KeyName from the Registry
Function Global:Remove-RegistryValue([String] $KeyPath, [String] $KeyName)
{
    If (Test-Path $KeyPath)
    {
        If (![String]::IsNullOrEmpty((Get-RegistryValue $KeyPath $KeyName)))
        {
            Remove-ItemProperty -Path $KeyPath  -Name $KeyName
            Write-Host "Registry Item Property Removed: `nKeyPath $KeyPath `nKeyName $KeyName"
        }
    }
}

# Remove Data from the Registry
Function Global:Remove-RegistryKey([String] $KeyPath)
{
    If (Test-Path $KeyPath)
    {
        Remove-Item $KeyPath
        Write-Host "Registry Key Removed: `nKeyPath $KeyPath"
    }
}

# Create a New Registry Key
Function Global:CreateNewRegKey ([String] $newKey)
{
    $parentKey = Split-Path $newKey -Parent
    If (!(Test-Path $parentKey))
    {
        CreateNewRegKey $parentKey
    }
    New-Item -Path $newKey
    Write-Host "Registry Key Created: `nNewKey: $newKey"
}

# Restart a service
Function Global:Service-Restart ([String] $ServiceName)
{
    Write-Host; Write-Host "Restarting $ServiceName ..."

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($Null -ne $Service )
    {
        Restart-Service $Service.Name -Force

        $Service.WaitForStatus($ServiceState_Running, $DefaultSeconds)

        Service-VerifyState $Service.Name $ServiceState_Running
    }
}

# Stop a service
Function Global:Service-Stop ([String] $ServiceName)
{
    Write-Host; Write-Host "Stopping $ServiceName ..."

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($Null -ne $Service )
    {
        If ($Service.Status -eq $ServiceState_Running -and $Service.CanStop)
        {
            $Service.Stop()
            $Service.WaitForStatus($ServiceState_Stopped, $DefaultSeconds)
        }
        Service-VerifyState $Service.Name $ServiceState_Stopped
    }
}

# Start a service
Function Global:Service-Start ([String] $ServiceName)
{
    Write-Host; Write-Host "Starting $ServiceName ..."

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($Null -ne $Service )
    {
        If ($Service.Status -eq $ServiceState_Stopped)
        {
            $Service.Start()
            $Service.WaitForStatus($ServiceState_Running, $DefaultSeconds)
        }
        Service-VerifyState $Service.Name $ServiceState_Running
    }
}

# Verify a service state
Function Global:Service-VerifyState ([String]$ServiceName, [Int32]$ServiceState)
{
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    
    If ($Null -ne $Service )
    {
        If ($Service.Status -ne $ServiceState)
        {
            $Service.WaitForStatus($ServiceState, $DefaultSeconds)
        }

        $ServiceStatus = $Service.Name + ": " + $Service.Status
        If ($Service.Status -ne $ServiceState)
        {
            Write-Error $ServiceStatus
        }
        Else
        {
            Write-Host $ServiceStatus
        }
    }
}

# Check a service state
Function Global:Service-CheckState ([String]$ServiceName)
{
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    
    If ($Null -ne $Service )
    {
        $ServiceStatus = $Service.Name + ": " + $Service.Status
        Write-Host $ServiceStatus
    }
}

# Run a powershell script
Function Global:Run-PowershellScript ($ScriptPath, $ScriptArgs)
{
    Start-Process -NoNewWindow -Wait -FilePath $PSHome\PowerShell.exe -ArgumentList "-ExecutionPolicy RemoteSigned -File $ScriptPath $ScriptArgs"
}

# Run a shell script
Function Global:Run-ShellScript ($ScriptPath)
{
    Write-Host $ScriptPath
    Start-Process -Wait $ScriptPath
}

Function Global:Get-BinRoots
{
    If (!$TestBinRoot -or !$OSBinRoot)
    {
        $HKLM_ENVIRONMENT = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'

        If ( [String]::IsNullOrEmpty($Global:OSBinRoot) ) { $Global:OSBinRoot = (Get-ItemProperty -Path $HKLM_ENVIRONMENT).OSBinRoot }
        If ( [String]::IsNullOrEmpty($Global:OSBinRoot) ) { Write-Host; Write-Warning "OSBinRoot not set" } Else { Write-VariableToProfile "OSBinRoot" "$OSBinRoot" }

        If ( [String]::IsNullOrEmpty($Global:TestBinRoot) ) { $Global:TestBinRoot = (Get-ItemProperty -Path $HKLM_ENVIRONMENT).TestBinRoot }
        If ( [String]::IsNullOrEmpty($Global:TestBinRoot) ) { Write-Host; Write-Warning "TestBinRoot not set" } Else { Write-VariableToProfile "TestBinRoot" "$TestBinRoot" }
    }
}

# Create global environment variable
Function Global:PS-SetX ([String] $VariableName, [String] $VariableValue, [Switch] $Reset)
{
    #Write-Host $VariableName; Write-Host
    #Write-Host $VariableValue; Write-Host
    #Pause

    #$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

    $FoundItem = $False

    ForEach($Item In (Get-ChildItem env:))
    {
        If ($Item.Name -eq $VariableName)
        {
            $FoundItem = $True
            $NewItemValue = [String]::Empty

            If ($VariableName -ieq "_NT_SYMBOL_PATH" -or 
                $VariableName -ieq "_NT_SOURCE_PATH" -or 
                $VariableName -ieq "PATH")
            {
                Write-Host
                $NewItemValue = $Item.Value
                $SubValueArray = $VariableValue.Split(";")
                ForEach($SubValue In $SubValueArray)
                {
                    If (!$NewItemValue.Contains($SubValue))
                    {
                        $NewItemValue = $NewItemValue + ";" + $SubValue
                    }
                }
            }
            Else
            {
                $NewItemValue = $VariableValue
            }

            # Remove double semi-colons
            $NewItemValue = $NewItemValue.Replace(";;", ";")
                    
            If ($Reset)
            {
               # Update Local
                [Environment]::SetEnvironmentVariable($Item.Name, $NewItemValue)

                # Update Machine
                $Setx = ("setx.exe " + $Item.Name + " `"" + $NewItemValue + "`" /M")
                Invoke-Expression $Setx
                #If($?) { Write-Host " Success: $VariableName $NewItemValue" }
                If(!($?)) { Write-Host " Fail setx: $VariableName $NewItemValue" }
            }
            Else
            {
                Write-Host ("Item [" + $VariableName + "] already exists in Environment")
            }
        }
    }

    If (!$FoundItem)
    {
        # Update Local
        [Environment]::SetEnvironmentVariable($VariableName, $VariableValue)

        # Update Machine
        $Setx = ("setx.exe " + $VariableName + " `"" + $VariableValue + "`" /M")
        Invoke-Expression $Setx
        #If($?) { Write-Host " Success: $VariableName $VariableValue" }
        If(!($?)) { Write-Host " Fail setx: $VariableName $VariableValue" }
    }

    # $? checks the error condition of Invoke-Expression (success or failure)
}

Function Global:Add-ItemToPath([String] $CurrentPath, [String] $NewPath)
{
    If (!$CurrentPath.Contains($NewPath)) { $CurrentPath = $CurrentPath + ";" + $NewPath}
    $CurrentPath = $CurrentPath.Replace(";;", ";")
    Return $CurrentPath
}

# Remove a Directory
Function Global:Remove-Directory ($DirectoryToRemove)
{
    if (Test-Path $DirectoryToRemove)
    {
        Remove-Item $DirectoryToRemove -Recurse -Force
        If (Test-Path $DirectoryToRemove) { Write-Host "Failed to remove [$DirectoryToRemove]" } Else { Write-Host "Successfully Removed [$DirectoryToRemove]" }
    }
}


#################
# Set Functions #
#################

Function Global:LoadModule ([String] $ModulePath)
{
    If (Test-Path $ModulePath\*.psm1)
    {
      #Write-Host "Importing modules from $ModulePath ..."
      Import-Module $ModulePath\*.psm1
    }
}

Function Global:Set-PSScripts([String] $ScriptsPath)
{
    $psScripts = "$ScriptsPath\PowerShell"
    If (!(Test-Path $psScripts)) { New-Item -ItemType Directory -Path $psScripts }
    $Env:psScripts = $psScripts
    If (Test-Path $psScripts) { Set-Location $psScripts }
    return $psScripts
}

Function Global:Set-LoadPSModulePath ([String] $ModulePath)
{
    If (![String]::IsNullOrEmpty($ModulePath))
    {
        If (!(Test-Path $ModulePath)) {New-Item -ItemType Directory -Path $ModulePath}
        $Env:psModulePath = (Add-ItemToPath $Env:psModulePath $ModulePath)
        LoadModule $ModulePath
    }
    Else
    {
        Write-Warning "Common.psm1::Set-LoadPSModulePath: ModulePath is null or empty [$ModulePath]"
    }
}

Function Global:Get-PSFileVersion {
    Get-Process -Name powershell | Format-List -Property ProcessName, FileVersion, StartTime, Id
    Get-Process -Name powershell | Format-Table -Wrap -AutoSize -Property Name,Id,Path -GroupBy Company
}

Function Global:SendNetMail ($From, $To, $CC, $Subject, $Message, $Attachments)
{
    $smtpServer = "smtphost.redmond.corp.microsoft.com"
    $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer)

    # Set default credentials
    $smtpClient.UseDefaultCredentials = $True

    $mailMessage = New-Object System.Net.Mail.MailMessage
    $mailMessage.From = $From
    $mailMessage.To.Add($To)
    #$mailMessage.CC.Add($CC)
    $mailMessage.Subject = $Subject
    $mailMessage.Body = $Message
    $mailMessage.Attachments.Add($Attachments)
    
    # Send email
    $smtpClient.Send($mailMessage)
}

Function Global:SendPSMail ($From, $To, $CC, $Subject, $Message, $Attachments)
{
    $smtpServer = "smtphost.redmond.corp.microsoft.com"
    If ($Attachments)
    {
        Send-MailMessage -From $From -To $To -CC $CC -Subject $Subject -Body $Message -Attachments $Attachments -SmtpServer $smtpServer
    }
    Else
    {
        Send-MailMessage -From $From -To $To -CC $CC -Subject $Subject -Body $Message -SmtpServer $smtpServer
    }
}

Function New-Script
{
    $fileName = Read-Host "File Name"
    if ($fileName -eq "") { $fileName="NewTemplate" }
    $author = Read-Host "Author Name"
    if ($author -eq "") { $author = $env:username }
    $email = Read-Host "eMail Address"
    if ($email -eq "") { $email="email@mycompany.com" }
    $comment=@();
    while($s = (Read-Host "Enter Comment").Trim()){$comment+="$s`r`n#"}
    $date = get-date -format d
    $file = New-Item -type file "$fileName.ps1" -force
    
    # Set the script template information
    $template = @"
    #requires -version 2
    <#
    .SYNOPSIS
        <Overview of script>

    .DESCRIPTION
        <Brief description of script>

    .PARAMETER <Parameter_Name>
        <Brief description of parameter input required. Repeat this attribute if required>

    .INPUTS
        <Inputs if any, otherwise state None>

    .OUTPUTS
        <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

    .NOTES
        Script:         $file
        Version: 		1.0
        Author: 		$author
        Email:          $email
        Creation Date:	$date
        Purpose/Change:	Initial script release
        Comment:        $comment

    .EXAMPLE
        <Example goes here. Repeat this attribute for more than one example>
    #>

    #---------------------------------------------------------[Initializations]--------------------------------------------------------

    #Set Error Action to Silently Continue
    $ErrorActionPreference = "SilentlyContinue"

    #Dot Source required Function Libraries
    . "C:\Scripts\Functions\Logging_Functions.ps1"

    #----------------------------------------------------------[Declarations]----------------------------------------------------------

    #Script Version
    $sScriptVersion = "1.0"

    #Log File Info
    $sLogPath = "C:\Windows\Temp"
    $sLogName = "<script_name>.log"
    $sLogFile = $sLogPath + "\" + $sLogName

    #-----------------------------------------------------------[Functions]------------------------------------------------------------

    <#

    Function <FunctionName>{
        Param()
        
        Begin{
            Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
        }
        
        Process{
            Try{
                <code goes here>
            }
            
            Catch{
                Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
                Break
            }
        }
        
        End{
            If($?){
                Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
                Log-Write -LogPath $sLogFile -LineValue " "
            }
        }
    }

    #>

    #-----------------------------------------------------------[Execution]------------------------------------------------------------

    #Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
    #Script Execution goes here
    #Log-Finish -LogPath $sLogFile
"@

    # Write to the file
    $template | Out-File $file
    
    # Invoke the file
    Invoke-Item $file
}
  
Set-Alias NewScript New-Script
 
Function Global:EP { n $profile }

Function Global:Profile { notepad $Profile.CurrentUserCurrentHost }

Function Global:Get-CHM { Invoke-Item $Env:windir\help\mui\0409\WindowsPowerShellHelp.chm }

Function Global:Get-CmdletAlias ($cmdletname) { Get-Alias | Where-Object {$_.definition -like "*$cmdletname*"} | Format-Table Definition, Name -auto }

Function Global:Get-MoreHelp { Get-Help $args[0] -Full | more }

Function Global:Get-OnlineHelp { Start-Process -FilePath http://technet.microsoft.com/en-us/library/bb978526.aspx }

Function Global:Get-PS3OnlineHelp { Start-Process -FilePath http://technet.microsoft.com/en-us/library/bb978525.aspx }

Function Global:Get-PS2Help { Start-Process -FilePath "$PSDir\PS2Help\WindowsPowerShell2.0CoreHelp-May2011.chm" }

Function Global:PSCMD { If ($args) { Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList $args } Else { Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" } }

Function Global:PSISE { If ($args) { Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -ArgumentList $args } Else { Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" } }

"#.Help Global:Get-WmiClass `"root\cimv2`" `"Processor`";"

Function Global:Get-WmiClass { $ns = $args[0]; $class = $args[1]; Get-WmiObject -List -Namespace $ns | Where-Object { $_.name -Match $class } }

Function Global:Get-Env { [Environment]::GetEnvironmentVariable($Variable, $Scope) }

Function Global:Set-Env { [Environment]::SetEnvironmentVariable($Variable, $Value, $Scope) }

Function Global:Del-Env { [Environment]::SetEnvironmentVariable($Variable, $Null, $Scope) }

Function Global:FS { findstr /spin $args }

Function Global:E { Start-Process -FilePath $pwd }
Function Global:F { find /i /n $args }
Function Global:Q { exit }

Function Global:RI { Remove-Item $args }
Function Global:F3 { findstr /spin $args }
Function Global:FS { findstr /spin $args }

Function Save-AllISEFiles
{
    <#
        .SYNOPSIS 
            Saves all ISE Files except for untitled files. If You have
            multiple PowerShellTabs, saves files in all tabs.
    #>

    ForEach($tab In $psISE.PowerShellTabs)
    {
        ForEach($file In $tab.Files)
        {
            If(!$file.IsUntitled)
            {
                $file.Save()
            }
        }
    }
}

# This line will add a new option in the Add-ons menu to save all ISE files with the Ctrl+Shift+S shortcut. 
# If you try to run it a second time it will complain that Ctrl+Shift+S is already in use
$SaveAsExists = $False
ForEach ($Item in $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus)
{
    If($Item.DisplayName -eq "Save All")
    { 
        $SaveAsExists = $True
    }
}
If (!$SaveAsExists)
{
    If($psISE)
    {
        $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Save All",{Save-AllISEFiles},"Ctrl+Shift+S")
    }
}

Function New-VFA ( [String] $Name, [String] $Alias, [String] $VType, [String] $SF, [String] $ENV, [String] $Path, [String] $File, [Switch] $Clean )
{
#     # Create the content
#     $NewContent = 
# @"
# If ((`$$Name.Length -eq 0) -or (`$$Name -ne `$wshShell.SpecialFolders.Item("$Name"))) { `$Global:$Name = `$wshShell.SpecialFolders.Item("$Name") }
# If ((`$$Name.Length -ne 0) -and ((Get-ChildItem Function:$Name -ErrorAction Ignore) -eq `$NULL)) { Function Global:$Name { Push-Location `$$Name } }
# If ((`$$Name.Length -ne 0) -and ((Get-ChildItem Alias:$Alias -ErrorAction Ignore) -eq `$NULL)) { Set-Alias -Name $Alias -Value $Name -Scope Global }
# "@

    # Create the Variable Type String
    # SF = 'wshShell.SpecialFolders.Item'
    # ENV = 'Environment Variable'
    # Path = 'Path to item'

    Switch ($VType)
    {
        "SF" { 
            If ($SF) { $V = "If ((`$$Name.Length -eq 0) -or (`$$Name -ne `$wshShell.SpecialFolders.Item(`"$SF`"))) { `$Global:$Name = `$wshShell.SpecialFolders.Item(`"$SF`") }" }
            Else { $V = "If ((`$$Name.Length -eq 0) -or (`$$Name -ne `$wshShell.SpecialFolders.Item(`"$Name`"))) { `$Global:$Name = `$wshShell.SpecialFolders.Item(`"$Name`") }" }
        }

        "ENV" { 
            If ($ENV) { $V = "If ((`$$Name.Length -eq 0) -or (`$$Name -ne `$Env:$ENV)) { `$Global:$Name = `$Env:$ENV }" }
            Else {$V = "If ((`$$Name.Length -eq 0) -or (`$$Name -ne `$Env:$Name)) { `$Global:$Name = `$Env:$Name }" }
        }

        "Path" { 
            If ($Path) { $V = "If ((`$$Name.Length -eq 0) -or (`$$Name -ne `"$Path`")) { `$Global:$Name = `"$Path`" }" }
            #Else { $V = "If ((`$$Name.Length -eq 0) -or (`$$Name -ne `"$Name`")) { `$Global:$Name = `"$Name`" }" }
        } 
    }

    # Create the Function String
    $F = "If ((`$$Name.Length -ne 0) -and ((Get-ChildItem Function:$Name -ErrorAction Ignore) -eq `$NULL)) { Function Global:$Name { Push-Location `$$Name } }"    

    # Create the Alias String
    If ($Alias) { $A = "If ((`$$Name.Length -ne 0) -and ((Get-ChildItem Alias:$Alias -ErrorAction Ignore) -eq `$NULL)) { Set-Alias -Name $Alias -Value $Name -Scope Global }" }

    # Create the VFA (VariableFunctionAlias) Content by combining all the strings into a Here-String 
    $NewContent = 
@"
$V
$F
$A
"@    
  
    #Write-Host $NewContent
    #Pause

    # Delete the file
    If ($Clean) { If (Test-Path $File) {Remove-Item -Path $File} }
    #Write-Host "Cleaned: $File"
    
    # Create the File if it does not exist
    If (!(Test-Path $File)) { New-Item -Type File -Path $File -Force }
    #Write-Host "Created: $File"
    
    # Write the content to the file
    Out-File -FilePath $File -InputObject "$NewContent" -Append -Force
    #Write-Host "Appended: $File"
    
}

Function Get-AllUserGroups
{
    [cmdletbinding()]
    param()
    $Groups = [System.Security.Principal.WindowsIdentity]::GetCurrent().Groups
    foreach ($Group in $Groups) {
      $GroupSID = $Group.Value
      $GroupName = New-Object System.Security.Principal.SecurityIdentifier($GroupSID)
      $GroupDisplayName = $GroupName.Translate([System.Security.Principal.NTAccount])
      $GroupDisplayName
      }
}

Function Get-Groups
{
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
    $user = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($ct, $env:USERNAME)
    $user.GetGroups() #gets all user groups (direct)
}

Function Get-AuthorizationGroups
{
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
    $user = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($ct, $env:USERNAME)
    $user.GetAuthorizationGroups() #gets all user groups including nested groups (indirect)
}
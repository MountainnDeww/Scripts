# Setup some default environment variables that will be available for each powershell session
Function Global:Set-ShellVariables
{

	If (!$Desktop -or ($Desktop.Length -eq 0)) { $Global:Desktop = ($Env:UserProfile + "\Desktop") }
	If ($Desktop -and ($Desktop.Length -gt 0) -and ([String]::IsNullOrEmpty($Env:Desktop) -or ($Env:Desktop -ne $Desktop))) { PS-SetX -VariableName "Desktop" -VariableValue $Desktop -Reset }
	
	If (!$Documents -or $Documents.Length -eq 0) { $Global:Documents = ($Env:UserProfile + "\Documents") }
	If ($Documents -and ($Documents.Length -gt 0) -and ([String]::IsNullOrEmpty($Env:Documents) -or ($Env:Documents -ne $Documents))) { PS-SetX -VariableName "Documents" -VariableValue $Documents -Reset }

	If (!$System32 -or $System32.Length -eq 0) { $Global:System32 = ($Env:SystemRoot + "\System32") }
	If ($System32 -and ($System32.Length -gt 0) -and ([String]::IsNullOrEmpty($Env:System32) -or ($Env:System32 -ne $System32))) { PS-SetX -VariableName "SYSTEM32" -VariableValue $System32 -Reset }

	If (!$PSTestScripts -or $PSTestScripts.Length -eq 0) { $Global:PSTestScripts = ($Env:UserProfile + "\Desktop\PSTestScripts") }
	If ($PSTestScripts -and ($PSTestScripts.Length -gt 0) -and ([String]::IsNullOrEmpty($Env:PSTestScripts) -or ($Env:PSTestScripts -ne $PSTestScripts))) { PS-SetX -VariableName "PSTestScripts" -VariableValue $PSTestScripts -Reset }
	
	#If (!(Test-Path $Tools)) { $Tools = "C:\Tools" }
	#If (!(Test-Path $Tools)) { $Tools = "D:\Tools" }
	#If(!$Tools) { $Global:Tools = ($Env:SystemRoot + "\Tools") }
	
	If ($Env:ComputerName -eq "HALLASUS64") { If(!$Tools -or $Tools.Length -eq 0) { $Global:Tools = ($Env:SystemRoot + "\Tools") } }
	If ($Env:ComputerName -eq "CA003-EQLT353") { If (!$Tools) { $Global:Tools = ($Env:UserProfile + "\Tools") } }
	If ($Tools -and ($Tools.Length -gt 0) -and ([String]::IsNullOrEmpty($Env:Tools) -or ($Env:Tools -ne $Tools))) { PS-SetX -VariableName "Tools" -VariableValue $Tools -Reset }

	If(!$VirtualStore -or $VirtualStore.Length -eq 0) { $Global:VirtualStore = ($Env:LocalAppData + "\VirtualStore") }
	If ($VirtualStore -and ($VirtualStore.Length -gt 0) -and ([String]::IsNullOrEmpty($Env:VirtualStore) -or ($Env:VirtualStore -ne $VirtualStore))) { PS-SetX -VariableName "VirtualStore" -VariableValue $VirtualStore -Reset }
	
	$path = ($Env:SystemDrive + "\Debuggers")
	$newPath = ($Env:Path + ";" + $path)
	If ($newPath.Length -lt 1024)
	{
		If ($Env:PATH.Contains($path) -eq $False) 
		{
			PS-SetX -VariableName "PATH" -VariableValue $newPath -Reset 
		}
	}
}

#$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
#[Security.Principal.WindowsBuiltInRole] "Administrator")


If ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") )
{
	Set-ShellVariables
}


# $ErrorActionPreference = "Stop"
# Try
# {
# 	Set-ShellVariables
# }
# Catch [System.UnauthorizedAccessException]
# {
# 	# Get a dictionary of the current script path, name, ext
# 	$ScriptPath = Get-ScriptInfo $PSCommandPath $False
# 	Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host

# 	Write-Warning ([String]::Format("Set-ShellVariables - Access Denied. `nRun this script elevated. [{0}]", $ScriptPath["Name"]))
# 	Throw [System.UnauthorizedAccessException]
# }
# $ErrorActionPreference = "Continue"



# Setup some default environment variables that will be available for each powershell session
Function Global:Set-ShellVariables
{
	If (!$Desktop) { $Global:Desktop = ($Env:UserProfile + "\Desktop") }
	If ($Desktop -and ([String]::IsNullOrEmpty($Env:Desktop) -or ($Env:Desktop -ne $Desktop))) { PS-SetX -VariableName "Desktop" -VariableValue $Desktop -Reset }

	If (!$Documents) { $Global:Documents = ($Env:UserProfile + "\Documents") }
	If ($Documents -and ([String]::IsNullOrEmpty($Env:Documents) -or ($Env:Documents -ne $Documents))) { PS-SetX -VariableName "Documents" -VariableValue $Documents -Reset }

	If (!$System32) { $Global:System32 = ($Env:SystemRoot + "\System32") }
	If ($System32 -and ([String]::IsNullOrEmpty($Env:System32) -or ($Env:System32 -ne $System32))) { PS-SetX -VariableName "SYSTEM32" -VariableValue $System32 -Reset }

	If (!$PSTestScripts) { $Global:PSTestScripts = ($Env:UserProfile + "\Desktop\PSTestScripts") }
	If ($PSTestScripts -and ([String]::IsNullOrEmpty($Env:PSTestScripts) -or ($Env:PSTestScripts -ne $PSTestScripts))) { PS-SetX -VariableName "PSTestScripts" -VariableValue $PSTestScripts -Reset }

	If(!$Tools) { $Global:Tools = ($Env:SystemRoot + "\Tools") }
	If (!(Test-Path $Tools)) { $Tools = "C:\Tools" }
	If (!(Test-Path $Tools)) { $Tools = "D:\Tools" }
	If ($Tools -and ([String]::IsNullOrEmpty($Env:Tools) -or ($Env:Tools -ne $Tools))) { PS-SetX -VariableName "Tools" -VariableValue $Tools -Reset }

	If(!$VirtualStore) { $Global:VirtualStore = ($Env:LocalAppData + "\VirtualStore") }
	If ($VirtualStore -and ([String]::IsNullOrEmpty($Env:VirtualStore) -or ($Env:VirtualStore -ne $VirtualStore))) { PS-SetX -VariableName "VirtualStore" -VariableValue $VirtualStore -Reset }

	$path = ($Env:SystemDrive + "\Debuggers")
	If (!$Env:PATH.Contains($path)) { PS-SetX -VariableName "PATH" -VariableValue ($Env:Path + ";" + $path) -Reset }

}

Set-ShellVariables

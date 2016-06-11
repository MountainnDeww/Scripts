
Param (
    [String] $Apps = @("winword.exe", "excel.exe"),
    [Switch] $Debug,
    [Switch] $Clean,
    [Switch] $Reset
)

FUNCTION Kill-Process ([String[]] $Images)
{
    ForEach($Image In $Images)
    {
        #Write-Host "Kill" $Image
        [String] $ret = Invoke-Expression ("C:\tools\SysInternalsSuite\pskill.exe " + $Image)
        If (!$ret.Contains("not exist")) {
            Write-Host $ret
            $Script:Killed = $true
        }
        Write-Host 
    }
}
Cls

#Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance "D016ECASQLS01\ECAKCDV01"
#Invoke-Sqlcmd -InputFile "C:\Tools\SqlQuery.sql" -ServerInstance "D016ECASQLS01\ECAKCDV01"

If($Debug){
    Write-Host "Apps = $Apps"
}
Else
{
    Kill-Process $Apps
}

If ($Debug -or $Killed) {  Write-Host ; PAUSE }

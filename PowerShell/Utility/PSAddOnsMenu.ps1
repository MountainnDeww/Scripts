$menuItems = @{
    "Current Tab"  = { $psISE.CurrentPowerShellTab | Get-Member | Sort Name | Out-GridView}
    "Command Pane" = { $psISE.CurrentPowerShellTab.CommandPane | Get-Member | Sort Name | Out-GridView}
    "Current File" = { $psISE.CurrentFile| Get-Member | Sort Name | Out-GridView}
    "Editor"       = { $psISE.CurrentFile.Editor | Get-Member | Sort Name | Out-GridView}
    "Options"      = { $psISE.Options | Get-Member | Sort Name | Out-GridView}
    "psISE"        = { $psISE  | Get-Member | Sort Name | Out-GridView}
}

$menuText = "ISE Objects"
$psISE.PowerShellTabs | %{
        $pstab = $_
        @($pstab.AddOnsMenu.Submenus) | 
          ?{$_.DisplayName -eq $menuText} | 
          %{$pstab.AddOnsMenu.Submenus.Remove($_) | Out-Null}
        
        $menu = $pstab.AddOnsMenu.Submenus.Add($menuText, $null, $null)

        $menuItems.GetEnumerator() |
            ForEach {
                $menu.Submenus.Add($_.Key, $_.Value, $null) | Out-Null
            }        
    }
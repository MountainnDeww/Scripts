$Share = Read-Host "Network Share"
$DomainAlias = Read-Host "User Domain\Alias"
$Password = Read-Host "User Password [Hidden]" -AsSecureString

cmdkey /add:$Share /user:$DomainAlias /pass:$Password

Write-Host

#Skal gjøres på maskiner som skal inn i domenet (cl1, mgr, srv1)

#Setter ipv4-en til DC som DNS på maskinen som skal inn i domenet
Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses IP_ADDRESS_OF_DC1

#Legger til maskinen i domenet ved hjelp av passordet til Administrator brukeren
#(mgr og cl1 krever at følgende kommandoer kjøres i powershell 5.1)
$credential = Get-Credential -UserName 'ON-PREMIUMIT\Administrator' -Message 'Credential'
Add-Computer -Credential $Credential -DomainName On-PremiumIT.sec -Passthru -Verbose
Restart-Computer

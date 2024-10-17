#Gjøres på DC1, enten manuelt eller gjennom Enter-PSSession

$rootuserou = 'On-PremiumIT-users'
New-ADOrganizationalUnit -Name $rootuserou #Oppretter OU-et

$rootuserou = Get-ADOrganizationalUnit -Filter * | Where-Object name -eq $rootuserou | Select-Object name, DistinguishedName #Erstatter $rootuserou med den faktiske OU-en, ikke bare strengen 'On-PremiumIT-users'

$usersou = @('it','dev','finance','sale','hr') #Array med navn på fremtidige OU-er
$usersou | foreach { New-ADOrganizationalUnit -name $_ -Path $rootuserou.DistinguishedName} #Oppretter OU-ene fra variabelen $usersou under On-Premium-users OU-en.

$groupou=@('global', 'local') #Navn på OU-er som skal brukes til grupper

#Oppretter OU for grupper og setter de i to variabler, nemlig $globalou og $localou
$groupou | foreach { New-ADOrganizationalUnit -name $_ -Path $rootuserou.DistinguishedName
    If ($_ -eq "global") {$globalou = Get-ADOrganizationalUnit -filter * | Where-Object name -eq $_ | Select-Object name,DistinguishedName}
    ElseIf ($_ -eq "local") {$localou = Get-ADOrganizationalUnit -filter * | Where-Object name -eq $_ | Select-Object name,DistinguishedName}        
    }

$globalgroups=@('global_it','global_dev','global_finance','global_sale','global_hr')
#Lager grupper med utgangspunkt i navn fra $globalgroups variabelen
$globalgroups | foreach { New-ADGroup -GroupCategory Security `
    -GroupScope Global `
    -Name $_ `
    -Path $globalou.DistinguishedName `
    -SamAccountName "$_"}

$localgroups=@('local_it', 'local_dev','local_finance','local_sale', 'local_hr', 'printers', 'doors')
#Lager grupper med utgangspunkt i navn fra $localgroups variabelen
$localgroups | foreach { New-ADGroup -GroupCategory Security `
    -GroupScope DomainLocal `
    -Name $_ `
    -Path $localou.DistinguishedName `
    -SamAccountName "$_"}

$printergroup = Get-ADGroup -Filter * | Where-Object name -like "printers"
$doorsgroup = Get-ADGroup -Filter * | Where-Object name -like "doors"

#Legger de globale gruppene inn i de lokale
@('it','dev','finance','sale','hr') | foreach{
    $localgroup = Get-ADGroup -Filter * | Where-Object name -like "local_*$_"
    $localgroups | Select-Object name,samaccountname
    $globalgroup = Get-ADGroup -Filter * | Where-Object name -like "global_*$_"
    $globalgroup | Select-Object name,samaccountname
    $localgroup | Add-ADGroupMember -Members $globalgroup.samaccountname
    $printergroup | Add-ADGroupMember -Members $globalgroup.samaccountname #"gir alle medlemmer i den globale gruppen tilgang til printerene"
    $doorsgroup | Add-ADGroupMember -Members $globalgroup.samaccountname #"gir alle medlemmer i den globale gruppen tilgang til dørene"
}




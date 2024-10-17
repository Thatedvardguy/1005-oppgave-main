#Gjøres på dc1

$globalou = Get-ADOrganizationalUnit -filter * | Where-Object name -eq "global" | Select-Object name,DistinguishedName

#Opprette remote desktop grupper:
New-ADGroup `
-GroupCategory Security `
-GroupScope Global `
-Name 'global_allemployees' `
-Path $globalou.DistinguishedName `
-SamAccountName 'global_allemployees'

#Legger alle brukerne i gruppen "global_allemployees"
@('dev','sale','finance','it','hr') | foreach {
    $users = Get-ADUser -Filter * -Properties department | Where-Object department -Like "$_"
    $users | Select-Object name,samaccountname
    $group = Get-ADGroup -filter * | Where-object name -like 'global_allemployees'
    $group | Select-Object name
    $group | Add-ADGroupMember -Members $users.samaccountname
}

New-ADGroup -GroupCategory Security `
    -GroupScope DomainLocal `
    -Name 'local_remotedesktop' `
    -Path 'OU=local,OU=On-PremiumIT-users,DC=On-PremiumIT,DC=sec' `
    -SamAccountName 'local_remotedesktop'

$remotedesktopusers = Get-ADGroup -filter * | Where-Object name -eq 'local_remotedesktop'
$remotedesktopusers | Add-ADGroupMember -Members 'global_allemployees'

#For å skru på RDP må du gå inn på GP Management -> Default Domain Policy (velg edit) -> Computer Configuration -> Windows Settings -> Security Settings -> Restricted Groups
#Her velger du "Add Group" -> skriv inn "Remote Desktop Users" 
#Add Member -> Browse -> Skriv inn "local_remotedesktop" i nederste felt -> OK
#(DC1)skriv i cmd eller powershell: "gpupdate /force" for å oppdatere GPO
#Gå på cl1 med administratorbruker og skriv i cmd / ps: "gpupdate /force"
#ferdig

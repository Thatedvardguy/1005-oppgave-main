#Gjøres i dc1
$Userlist = Import-csv PATH_TIL_CSV_FIL -Delimiter ";" #Henter brukerdata fra csv fil 
#Lager brukere
foreach ($User in $Userlist)
{   
    $name = $User.GivenName + " " + $User.Surname
    New-ADUser `
    -SamAccountName $User.Username `
    -UserPrincipalName $User.UserPrincipalName `
    -Name $name `
    -GivenName $user.GivenName `
    -Surname $user.SurName `
    -Enabled $True `
    -ChangePasswordAtLogon $false `
    -DisplayName $user.Displayname `
    -Department $user.Department `
    -Path $user.path `
    -AccountPassword (convertto-securestring $user.Password -AsPlainText -Force)
}

$department=@('dev','sale','finance','it','hr')
#Legger brukerene inn i de gruppene de tilhører
$department | foreach {
    $Userlist = Get-ADUser -Filter * -Properties department | Where-Object department -Like "$_"
    $Userlist | Select-Object name,samaccountname
    $groupename = Get-ADGroup -filter * | Where-object name -like "global_*$_"
    $groupename | Select-Object name
    $groupename | Add-ADGroupMember -Members $UserList.samaccountname
}

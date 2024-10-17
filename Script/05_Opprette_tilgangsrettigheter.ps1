$folders = @('dev','sale','finance','it','hr')

foreach ($folder in $folders) {
$acl = Get-Acl \\On-PremiumIT\files\$folder #Access-Control-List, det som inneholder regler for tilgang

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("On-PremiumIT\local_$folder","Fullcontrol","Allow") #Oppretter en regel der den tilhørende lokalgruppen til filområdet skal ha full tilgang til filene.
$acl.SetAccessRule($AccessRule) #Hekter på reglene
$acl | Set-Acl -Path "\\On-PremiumIT\files\$folder" #Setter reglene som ligger i $acl på filområdet med denne stien

$acl = Get-Acl -Path "\\On-PremiumIT\files\$folder" #Henter reglene
$acl.SetAccessRuleProtection($true,$true) #Gjør det slik at de som ikke har tilgang ikke kommer inn
$acl | Set-Acl -Path "\\On-PremiumIT\files\$folder" 

$acl = Get-Acl -Path "\\On-PremiumIT\files\$folder"
$acl.Access | where {$_.IdentityReference -eq "BUILTIN\Users" } | foreach { $acl.RemoveAccessRuleSpecific($_) } #Fjerner tilgangen brukerene (som ligger i \Users) har til filene.
Set-Acl "\\On-PremiumIT\files\$folder" $acl #Implemeterer reglene
}

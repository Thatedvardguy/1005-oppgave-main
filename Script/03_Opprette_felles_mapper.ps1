#Gjøres på srv1, enten manuelt eller ved bruk av Enter-PSSession Srv1

Install-WindowsFeature -Name FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-Con -IncludeManagementTools
Import-module dfsn

$Folders = ('C:\dfsroots\files','C:\shares\it','C:\shares\dev','C:\shares\finance','C:\shares\sale','C:\shares\hr') #Lager variabel med mappenavn + path

mkdir -path $Folders #Oppretter mappene

$Folders | ForEach-Object {$sharename = (Get-Item $_).name; New-SMBShare -Name $sharename -Path $_ -Fullaccess Everyone} #Gjør mappene tilgjengelige på nettverket / Henter de delte mappene fra maskinen. Foreløpig har alle tilgang til filene

#Følgende kommando må gjøres direkte på srv1, ikke PSSession
New-DfsnRoot -TargetPath \\srv1\files -Path \\On-PremiumIT.sec\files -Type DomainV2 #Lager et DFS Namespace med utgangspunkt fra \\srv1\files, dette nye namespacet kalles \\On-PremiumIT.sec\files

#Kan gå tilbake til PSSession nå
$folders | Where-Object {$_ -like "*shares*"} | ForEach-Object {$name = (Get-Item $_).name; $DfsPath = ('\\On-PremiumIT\files\' + $name); $targetPath = ('\\srv1\' + $name);New-DfsnFolderTarget -Path $dfsPath -TargetPath $targetPath} #Sender alle delte områder fra \\srv1\ til \\On-PremiumIT.sec\files

#Ferdig





#Skript kjøres på mgr

#'\Processor(*)\% Processor Time' %-andel av cpu som blir brukt
#'\Memory\% Committed Bytes In Use' %-andel av total minne som blir brukt 
#'\PhysicalDisk(*)\Avg. Disk Read Queue Length' Antall disk operasjoner som venter, brukes for å finne bottlenecks 
#'\Network Interface(*)\Bytes Total/sec' Total menge bytes som blir enten mottatt eller sent per sekund

#Funksjon som oppretter Powershell Object som inneholder dataen fra get-counter -counter $counters og eksporterer den til en .csv fil 

$script = {
    $counters ='\Processor(*)\% Processor Time', '\Memory\% Committed Bytes In Use','\PhysicalDisk(*)\Avg. Disk Read Queue Length', '\Network Interface(*)\Bytes Total/sec'
    Get-Counter -Counter $counters -Maxsamples 10 |
        Foreach-Object {
        $_.CounterSamples | ForEach-Object {
            [PSCustomobject]@{
                Timestamp = $_.Timestamp
                Path = $_.Path
                Value = $_.CookedValue
            }
        }
    } | Export-Csv -Path "\\On-PremiumIT\files\it\cpu_memory_disk_network_data_$env:computername.csv" -NoTypeInformation
}

#Kjører kommandoen på dc1 og srv1
Invoke-Command -ComputerName dc1,srv1 `
    -ScriptBlock $script

#Dataen blir lagret i \\On-PremiumIT\files\it, altså fellesområdet til IT avdelingen, de har nok mest nytte av denne dataen


#for dc1, gjøres fortsatt på mgr
$script_for_dc1_services ={
    $services ='DNS','DFS Replication','DFS Namespace','Active Directory Domain Services', 'Group Policy Client','Kerberos Key Distribution Center', 'Netlogon', 'Intersite Messaging'
    Get-Service $services | Select-Object Name, Status | ft
}
Invoke-Command -ComputerName dc1 -ScriptBlock $script_for_dc1_services

#DNS: Domain Name System, er vikitg for å holde styr over hvem som er med i domenet, viss denne tjenesten er skrudd av vil andre tjenester som er avhengige av denne slutt å fungere.

#Active Directory Domain Services: er viktig for å opprettholde et domene, viss denne tjenesten er stoppet vil ikke brukere kunne logge seg inn til domenet

#DFS Replication: er viktig for å synkronisere delte mapper på flere servere/maskiner, viss denne tjenesten er stoppet vil ikke de delte mappene oppdatere seg, selv når det skjer endringer.

#DFS Namespace: er viktig for å opprette delte områder, det er ikke kritisk viss denne forsvinner med en gang, men du vil ikke kunne opprette nye namespaces.

#Group Policy Client: er viktig for å utføre endringer som er administerte i GPO, viss denne tjenesten stopper vil ikke nye instillinger bli satt inn hos brukere eller grupper, du kan heller ikke opprette eller slette noe.

#Kerberos Key Distribution Center: er viktig fordi den tillater brukere å logge inn på nettverket gjennom Kerberos Authentication Protocol, viss denne tjenesten er skurdd av vil ikke brukere kunne logge seg inn til nettverket, selv om det er oppe.

#Netlogon: er viktig fordi den opprettholder en sikker forbindelsen mellom brukeren sin maskin og domene kontrolløren, viss denne tjenesten er stoppet vil ikke datamaskinen autentisere brukere eller tjenester og domene kontrolløren kan ikke registrere DNS records

#Intersite Messaging: er viktig for å kunne kommunisere ellom windows server sites, viss denne tjenesten er stoppet vil ikke meldinger bli kommuniserte.

#for srv1, gjøres fortsatt på mgr
$script_for_srv1_services ={
    $services='W3SVC','DFS Namespace','DFS Replication','Group Policy Client','Netlogon'
    Get-Service $services | Select-Object Name, Status | ft
}
Invoke-Command -ComputerName srv1 -ScriptBlock $script_for_srv1_services

#W3SVC: er viktig fordi det er tjenesten som opprettholder Web Serveren (IIS).

#Installering gjøres på srv1
Enter-Pssession srv1
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Exit #Gå ut av Pssession

#Kan nå gå på http://srv1 for å komme til IIS siden
#html siden ligger på srv1 under C:\inetpub\wwwroot

#Eg fant ingen lett måte å sette IIS som default start page ved bruk av Powershell
#Så her er en link som viser hvordan du gjør det manuelt: https://techexpert.tips/windows/gpo-configure-microsoft-edge-home-page/
#Dette er nedlastingslinken til policies: https://www.microsoft.com/en-us/edge/business/download 

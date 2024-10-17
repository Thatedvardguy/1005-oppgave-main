#SKAL GJØRES PÅ DC MASKINEN
Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools #Installerer AD

$Password = 'P@ssW0rD!' | ConvertTo-SecureString -AsPlainText -Force #Setter passord til bruker, passordet krever en viss kompleksitet

Set-LocalUser -Password $Password Administrator #Oppretter bruker

$Parameters = @{ #Definerer parameterene til domenet
    DomainMode = 'WinThreshold'
    DomainName = 'On-PremiumIT.sec'
    DomainNetbiosName = 'On-PremiumIT'
    ForestMode = 'WinThreshold'
    Installdns = $true
    NoRebootOnCompletion = $true
    SafeModeAdministratorPassword = $Password
    Force = $true
}

Install-ADDSForest @Parameters #Oppretter domene med parameterene
Restart-Computer

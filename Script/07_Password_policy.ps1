Set-ADDefaultDomainPasswordPolicy `
-ComplexityEnabled $True ` #Passordet krever nå 3 av de 4 følgende: store bokstaver, små bokstaver, tall, spesialtegn
-LockoutDuration 01:00:00 ` #Hvor lenge du blir låst ut fra maskinen ved for mange forsøk
-LockoutObservationWindow 01:00:00 ` #Hvor lang tid det tar før antall mislykkede forsøk settes tilbake til 0
-LockoutThreshold 10 ` #Hvor mange forsøk du har på å logge inn
-MaxpasswordAge 365.00:00:00 ` #Hvor lenge et passord kan gå uendret
-MinPasswordAge 1.00:00:00 ` #Hvor lenge et passord må gå uendret
-MinPasswordLength 12 ` #Selvforklarende
-PasswordHistoryCount 24 ` #Hvor mange ganger du må endre passordet ditt før du kan gjennbruke ditt opprinnelige
-Identity On-PremiumIT.sec #Hvilket domene endringene skjer for

#Kilde https://docs.microsoft.com/en-us/powershell/module/activedirectory/set-addefaultdomainpasswordpolicy?view=windowsserver2022-ps

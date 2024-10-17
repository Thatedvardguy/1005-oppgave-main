#Må opprette volume på openstack på forhånd
#Attach volume til mgr

#Robocopy:

$source = '\\On-PremiumIT\files\'
$destination = 'D:\backups\' #Oppretter en mappe "backups" automatisk viss den ikke fins

$date = Get-Date -Uformat "%y%m%d" #Henter dato i format yymmdd
$checkday = Get-date -Uformat "%A" #Henter ukedag

$checkdest = -join($destination,$date) #Legger sammen variablene til en enhet (streng i dette tilfelle)

$full = '(-not(Test-Path -Path $checkdest -PathType Container)) ? (New-Item -Path $checkdest -ItemType Directory | Robocopy $source $checkdest /e /copy:DAT) : " "'

$inkr = '(-not(Test-Path -Path $checkdest -PathType Container)) ? (New-Item -Path $checkdest -ItemType Directory | Robocopy $source $checkdest /e /im /copy:DAT) : " "'  #det er /im som gjør at det blir inkrementell, /im (include modified)

$checkday -eq "Sunday" ? (iex $full) : (iex $inkr) #iex = Invoke-Expression

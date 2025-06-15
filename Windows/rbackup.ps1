function find_volume ([string]$folder) {
	#$drive = Get-Volume | Where-Object {$_.DriveType -eq 'removable'}
	$drive = Get-Volume | Where-Object {$_.OperationalStatus -eq 'OK'}
	$volume=""
	foreach ($d in $drive) {
		$f = $d.DriveLetter +':\' + $folder
		#echo "Looking for $f"
		if((Test-Path -PathType Container -Path $f )) {
			$volume=$d.DriveLetter
			break
		}
	}
	return $volume
}

function find_volume_or_die([string]$folder) { 
	$volume=find_volume($folder)
	if ($volume -eq '') {
		echo  "$folder not found. Aborting."
		exit
	}
	$volume=$volume + ':'
	return $volume
}

function run_as_admin() {
	return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}	

function allow_standby([bool]$allow) {
	$ok=run_as_admin
    if (!$ok) {return}

	if ($allow) {
		powercfg -h on
		powercfg -change -standby-timeout-ac 90
		powercfg -change -standby-timeout-dc 90
	} else {
		# empeche hibernation
		powercfg -h off
		powercfg -change -standby-timeout-ac 0
		powercfg -change -standby-timeout-dc 0	
	}
}

function backup([string]$repository,[string[]]$directories) {
    $options='-v'
    $repository='backup-'+ $repository 
    $volume=find_volume_or_die($repository)
    $repo=$volume+'\'+ $repository 
    & restic backup $options --repo $repo $directories 
}

function init([string]$volume, [string]$repository) {
    $options='-v'
    $repository='backup-'+ $repository 
    $repo=$volume+'\'+ $repository 
    & restic init $options --repo $repo 
}

$env:DEBUG_LOG='restic-debug.log'  
$env:RESTIC_PASSWORD='your_password'

$a = @{
"dev" = @("E:\Dev", "C:\Dev", "$env:GOPATH")
"utils"=@("C:\Utils")
"osm"  =@("E:\OSM")
"docs" =@("E:\Docs", "E:\Mes documents",  $env:APPDATA) 
"steam"=@("C:\Program Files (x86)\Steam")  
}


allow_standby($false)

restic cache --cleanup-cache

#$key = Read-Host "Quitter les applications pour permettre la sauvegarde de AppData"

foreach($k in $a.Keys){
    #write-host $a[$k]
    #init "V:" $k
    backup $k $a[$k]
} 

allow_standby($true)
 

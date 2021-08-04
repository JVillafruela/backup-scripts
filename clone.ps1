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

function allow_hibernate([bool]$allow) {
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

function backup([string]$destination,[string[]]$directories,$options) {
    $volume=find_volume_or_die($destination)
    foreach ($folder in $directories) {
        $subfolder=$folder
        if ($subfolder.substring(1,2) = ':\') {
            $subfolder = $subfolder.Substring(3)
        }
        $dest=$volume+'\'+ $destination + '\' + $subfolder 
        $opt=$options.Split(' ')
        echo "rclone sync $folder $dest $options "
        & rclone sync "$folder" "$dest"  $opt
    }
}

function create_dir($folder) {
    if (-not (Test-Path -LiteralPath $folder)) {
        try {
            New-Item -Path $DirectoryToCreate -ItemType Directory -ErrorAction Stop | Out-Null #-Force
        } catch {
            Write-Error -Message "Unable to create directory '$folder'. Error was: $_" -ErrorAction Stop
        }
    }
}


$options='--progress --check-first --track-renames --max-backlog=30000'
$sources = @("P:\Appareils","P:\Smartphones", "P:\Docs", "I:\Softs")

allow_hibernate($false)

$folder='rc-photos'
$volume=find_volume_or_die($folder)
$repo=$volume+'\'+ $folder 
backup $folder $sources $options

allow_hibernate($true)
 





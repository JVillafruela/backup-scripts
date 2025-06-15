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
		echo  "Directory $folder not found. Aborting."
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

function backup([string]$destination,[string[]]$directories) {
    $volume=find_volume_or_die($destination)
    ForEach ($folder in $directories) {
        $subfolder=$folder
        if ($subfolder.substring(1,2) = ':\') {
            $subfolder = $subfolder.Substring(3)
        }
        $dest=$volume+'\'+ $destination + '\' + $subfolder 
        #& rclone sync "$folder" "$dest"  
        & robocopy "$folder" "$dest" /MIR /COPY:DAT /DCOPY:DAT /R:3 /W:10  /XD "System Volume Information" "$RECYCLE.BIN" /XF "pagefile.sys" /NP /LOG+:robocopy.log  /TEE
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



$sources = @("M:\Qobuz", "M:\audio")

allow_hibernate($false)

$folder='rc-music'
$volume=find_volume_or_die($folder)
$repo=$volume+'\'+ $folder 
backup $folder $sources 

allow_hibernate($true)
 





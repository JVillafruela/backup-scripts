# backup-scripts

Powershell scripts to backup local folders to a removable drive.

Translated from [README.fr.md](README.fr.md).


Before the first use the target directory must be created on the removable disk. The script searches for this directory on all volumes, so it must not exist on one of the fixed volumes.

The data to be backed up must not be locked (no use of VSS)

## rbackup.ps1
Script using [restic](https://restic.net/).

Initialize the backup repository with :

```powershell
$env:RESTIC_PASSWORD='your_password'
restic init --repo 'V:\backup-photos'
```
## clone.ps1

Script using [rclone](https://rclone.org/). Can easily be adapted for cloud backup. Does not suit me for local backup because directories are created with the date of the script execution.

## rcopy.ps1

Script using the [Robocopy](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy) tool available on Windows.

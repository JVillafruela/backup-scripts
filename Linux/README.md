# backup-scripts

Translated from [README.fr.md](README.fr.md) using Deepl.com.

Bash scripts for backup to a removable disk.

## Software required

- [restic](https://restic.net/)
- [resticprofile](https://creativeprojects.github.io/resticprofile/)


Before first use, the target directory must be created on the removable disk. 


## backup

Script using [restic](https://restic.net/).


### Configuration

Password must be in file ```~/.config/resticprofile/restic-password.txt```

Initialize backup repository with :

```bash
resticprofile -c red home.init
```
- red: config name ~/.config/resticprofile/red.toml
- home: [home] section of config for $HOME backup

or directly using restic

```bash
export RESTIC_PASSWORD_FILE='~/.config/resticprofile/estic-password.txt'
restic init --repo '/run/media/jerome/BACKUP1-2/backup-home/'
```

### Backup

Total :

```bash
resticprofile -c red home.backup
```

Selective: use one of the following commands:

```bash
resticprofile -c red home.backup # home directory
resticprofile -c red ebooks.backup 
resticprofile -c red music.backup # flac files (ripp CD + Qobuz)
resticprofile -c red ogg.backup # ogg files for smartphone 
resticprofile -c red podcasts.backup # podcasts
resticprofile -c red photos.backup # photos from cameras + smartphones
resticprofile -c red video.backup 
```


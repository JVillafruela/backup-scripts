# backup-scripts

Scripts Bash pour sauvegarde sur un disque amovible.

## Logiciels nécessaires

- [restic](https://restic.net/)
- [resticprofile](https://creativeprojects.github.io/resticprofile/)


Avant la première utilisation le répertoire cible doit être créé sur le disque amovible. 


## backup

Script utilisant [restic](https://restic.net/).


### Configuration

Le mot de passe doit se trouver dans le fichier ```~/.config/resticprofile/restic-password.txt```

Initialiser le dépôt de sauvegarde par :

```bash
resticprofile -c rouge home.init
```
- rouge : nom de la config ~/.config/resticprofile/rouge.toml
- home  : section [home] de la config pour la sauvegarde du $HOME

ou en utilisant directement restic

```bash
export RESTIC_PASSWORD_FILE='~/.config/resticprofile/estic-password.txt'
restic init --repo '/run/media/jerome/BACKUP1-2/backup-home/'
```

### Sauvegarde

Totale :

```bash
resticprofile -c rouge home.backup
```

Sélective : utiliser l'une des commandes :

```bash
resticprofile -c rouge home.backup # home directory
resticprofile -c rouge ebooks.backup  
resticprofile -c rouge music.backup  # musique en flac (ripp CD + achats Qobuz)
resticprofile -c rouge ogg.backup # musique en ogg pour smartphone (peut être recréé à partir des fichiers flacs)
resticprofile -c rouge podcasts.backup # podcasts
resticprofile -c rouge photos.backup # photos appareils + smartphones
resticprofile -c rouge video.backup # vidéos
```


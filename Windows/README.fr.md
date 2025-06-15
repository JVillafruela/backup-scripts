# backup-scripts

Scripts Powershell pour sauvegarde sur un disque amovible.


Avant la première utilisation le répertoire cible doit être créé sur le disque amovible. Le script recherche ce répertoire sur tous les volumes, il ne doit donc pas donc exister sur un des volumes fixes.

Les données à sauvegarder ne doivent pas être verrouillées (pas d'utilisation de VSS)

## rbackup.ps1
Script utilisant [restic](https://restic.net/).

Initialiser le dépôt de sauvegarde par :

```powershell
$env:RESTIC_PASSWORD='your_password'
restic init --repo 'V:\backup-photos'
```

## clone.ps1

Script utilisant [rclone](https://rclone.org/). Peut facilement être adapté pour une sauvegarde dans le cloud. Ne me convient pas pour la sauvegarde en local car les répertoires sont créés avec la date d'exécution du script.

## rcopy.ps1

Script utilisant l'outil [Robocopy](https://docs.microsoft.com/fr-fr/windows-server/administration/windows-commands/robocopy) livré avec Windows.
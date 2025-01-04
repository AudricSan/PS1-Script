# Renommage de fichiers par horodatage EXIF

Ce script PowerShell permet de renommer des fichiers en fonction de leur horodatage EXIF, facilitant ainsi l'organisation de vos fichiers multimédias.

## Fonctionnalités

- Renomme les fichiers en fonction de leur date d'horodatage EXIF.
- Supporte plusieurs extensions de fichiers (ex. : .jpg, .png).
- Utilise ExifTool pour extraire les métadonnées de date.
- Affiche des messages de progression lors du traitement des fichiers.
- Gère les erreurs et avertit si un fichier ne correspond pas à un format valide.

## Prérequis

- PowerShell 5.1 ou supérieur
- [ExifTool](https://exiftool.org/) installé et accessible dans le PATH système

## Utilisation

1. Assurez-vous qu'ExifTool est installé et accessible dans votre PATH système.
2. Ouvrez PowerShell.
3. Naviguez vers le dossier contenant le script.
4. Exécutez le script avec les paramètres souhaités :

```powershell
.\RenameTimestamp.ps1 -targetDir "C:\Chemin\Vers\Vos\Fichiers" -exifToolName "exiftool.exe" -fileExtensions ".jpg" -destinationDir "C:\FichiersRenommes"
```

## Paramètres

- `-targetDir` : Chemin du dossier contenant les fichiers à renommer (obligatoire)
- `-exifToolName` : Nom de l'exécutable ExifTool (facultatif, par défaut : "exiftool.exe")
- `-fileExtensions` : Liste des extensions de fichiers à traiter (facultatif, par défaut : .mp4)
- `-destinationDir` : Chemin du dossier où les fichiers renommés seront enregistrés (facultatif)

## Exemple

```powershell
.\RenameTimestamp.ps1 -targetDir "C:\Images" -fileExtensions ".jpg" -destinationDir "C:\ImagesRenommes"
```

## Remarques

- Le script vérifie automatiquement si ExifTool est présent dans le PATH système.
- Les fichiers sans date d'horodatage EXIF valide ne seront pas renommés.
- Affiche une progression lors du traitement des fichiers.

## Changelog

Pour voir l'historique des modifications apportées à ce script, consultez le fichier [CHANGELOG](CHANGELOG.md) dans ce dossier.

## Auteur

Audric_San

## Licence

Ce script est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.

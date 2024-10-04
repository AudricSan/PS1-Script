# Tri de fichiers par date

Ce script PowerShell permet de trier automatiquement des fichiers image par date de capture dans des dossiers organisés.

## Fonctionnalités

- Trie les fichiers image (CR2, CR3, JPG, JPEG, PNG, TIF, TIFF) par date de capture
- Utilise ExifTool pour extraire les métadonnées de date
- Crée des dossiers au format YYYY_MM_DD
- Affiche une barre de progression avec estimation du temps restant
- Gère les erreurs et les fichiers sans date de capture
- Permet de spécifier un dossier de destination différent du dossier source

## Prérequis

- PowerShell 5.1 ou supérieur
- [ExifTool](https://exiftool.org/) installé et accessible dans le PATH système

## Utilisation

1. Assurez-vous qu'ExifTool est installé et accessible dans votre PATH système
2. Ouvrez PowerShell
3. Naviguez vers le dossier contenant le script
4. Exécutez le script avec les paramètres souhaités :

```powershell
.\trier_par_date.ps1 -targetDir "C:\Chemin\Vers\Vos\Photos"
```

Ou, pour spécifier un dossier de destination différent :

```powershell
.\trier_par_date.ps1 -targetDir "C:\Chemin\Vers\Vos\Photos" -destinationDir "D:\Photos\Triées"
```

## Paramètres

- `-targetDir` : Chemin du dossier contenant les fichiers à trier (obligatoire)
- `-exifToolName` : Nom de l'exécutable ExifTool (facultatif, par défaut : "exiftool.exe")
- `-fileExtensions` : Liste des extensions de fichiers à traiter (facultatif, par défaut : CR2, CR3, JPG, JPEG, PNG, TIF, TIFF)
- `-destinationDir` : Chemin du dossier où les fichiers triés

## Exemple

```powershell
.\trier_par_date.ps1 -targetDir "C:\Mes Photos" -fileExtensions @('JPG', 'PNG')
```

## Remarques

- Le script vérifie automatiquement si ExifTool est présent dans le PATH système
- Les fichiers sont déplacés dans des sous-dossiers nommés selon la date de capture (format : YYYY_MM_DD)
- Les fichiers sans date de capture valide ne sont pas déplacés

## Changelog

Pour voir l'historique des modifications apportées à ce script, consultez le fichier [CHANGELOG](CHANGELOG-trier_par_date.md) dans ce dossier.

## Auteur

Audric_San

## Licence

Ce script est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.
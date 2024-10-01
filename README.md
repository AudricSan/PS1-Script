# Tri de fichiers par date

Ce script PowerShell permet de trier automatiquement des fichiers image par date de capture dans des dossiers organisés.

## Fonctionnalités

- Trie les fichiers image (CR2, CR3, JPG, JPEG, PNG, TIF, TIFF) par date de capture
- Utilise ExifTool pour extraire les métadonnées de date
- Crée des dossiers au format YYYY_MM_DD
- Affiche une barre de progression avec estimation du temps restant
- Gère les erreurs et les fichiers sans date de capture

## Prérequis

- PowerShell 5.1 ou supérieur
- [ExifTool](https://exiftool.org/) installé et accessible dans le PATH système

## Utilisation

1. Assurez-vous qu'ExifTool est installé et accessible dans votre PATH système
2. Ouvrez PowerShell
3. Naviguez vers le dossier contenant le script
4. Exécutez le script avec les paramètres souhaités :

## Paramètres

- `-targetDir` : Chemin du dossier contenant les fichiers à trier (obligatoire)
- `-exifToolName` : Nom de l'exécutable ExifTool (facultatif, par défaut : "exiftool.exe")
- `-fileExtensions` : Liste des extensions de fichiers à traiter (facultatif, par défaut : CR2, CR3, JPG, JPEG, PNG, TIF, TIFF)

## Exemple

```powershell
.\trier_par_date.ps1 -targetDir "C:\Mes Photos" -fileExtensions @('JPG', 'PNG')
```

## Contribution

Ce projet est maintenant public sur GitHub. Les contributions sont les bienvenues ! Si vous souhaitez contribuer, veuillez suivre ces étapes :

1. Forkez le projet
2. Créez votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## Versions

### [1.3.0] - 2023-04-27
- Le projet est maintenant public sur GitHub
- Ajout d'un CHANGELOG global
- Mise à jour de la documentation

Pour plus de détails sur les changements, consultez le fichier [CHANGELOG.md](CHANGELOG.md).

## Licence

Ce projet est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

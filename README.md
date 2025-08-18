# Collection de Scripts PowerShell et Python

Ce dépôt contient une collection de scripts pour l'automatisation de diverses tâches, comprenant des scripts PowerShell et Python pour différentes utilisations.

## Scripts disponibles

1. [Calcul Commuterpass Japon](./Calcul%20Commuterpass%20Japon/README.md) - Calcul des pass de transport au Japon
2. [GeoFolder](./GeoFolder/README.md) - Organisation des photos par géolocalisation
3. [Planning](./Planning/README.md) - Gestion de planning avec intégration Google Calendar
4. [RenameTimestamp](./RenameTimestamp/README.md) - Renommage de fichiers avec horodatage
5. [Sequence Rename](./sequence%20rename/README.md) - Renommage séquentiel de fichiers
6. [Tri de fichiers par date](./trier_par_date/README.md) - Tri automatique des fichiers par date
7. [tsTomp4](./tsTomp4/README.md) - Conversion de fichiers .ts en .mp4

## Prérequis généraux

### Pour les scripts PowerShell
- PowerShell 5.1 ou supérieur
- ExifTool (pour GeoFolder et trier_par_date)
- FFmpeg (pour tsTomp4)

### Pour les scripts Python
- Python 3.8 ou supérieur
- pip pour l'installation des dépendances
- Bibliothèques Python requises (listées dans chaque script)

## Structure du projet

Chaque script est placé dans son propre dossier, contenant :
- Le script PowerShell (.ps1)
- Un README spécifique avec les instructions d'utilisation
- Un CHANGELOG spécifique pour suivre les modifications du script

## Utilisation

Consultez le README de chaque script pour des instructions détaillées sur son utilisation.

## Contribution

Les contributions à ce projet sont les bienvenues. Si vous souhaitez contribuer, veuillez suivre ces étapes :

1. Forkez le projet
2. Créez votre branche de fonctionnalité (`git checkout -b feature/NouveauScript`)
3. Committez vos changements (`git commit -m 'Ajout d'un nouveau script'`)
4. Poussez vers la branche (`git push origin feature/NouveauScript`)
5. Ouvrez une Pull Request

## Licence

Ce projet est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Changelog global

Pour voir l'historique des modifications apportées à ce projet dans son ensemble, consultez le [CHANGELOG.md](CHANGELOG.md).

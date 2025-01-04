# Changelog pour RenameTimestamp.ps1

Toutes les modifications notables apportées à ce script seront documentées dans ce fichier.

## [1.3.0] - 2025-01-04

### Ajouté
- Ajout d'un suivi de progression lors du traitement des fichiers.

## [1.1.0] - 2024-12-31

### Ajouté
- Fonctionnalité de base pour renommer les fichiers en fonction de leur horodatage EXIF.
- Support pour plusieurs extensions de fichiers (ex. : .jpg, .png).
- Utilisation d'ExifTool pour extraire les dates de capture et mettre à jour les métadonnées.

### Modifié
- Mise à jour des paramètres du script pour inclure des descriptions détaillées.
- Amélioration de la gestion des erreurs lors de la vérification des noms de fichiers.
- Changement de la valeur par défaut de `-fileExtensions` de .jpg, .png à .mp4.

### Documentation
- Ajout de la documentation pour les paramètres dans le script.
- Exemples d'utilisation fournis dans la section `.EXAMPLE` du script.

### Sécurité
- Validation des chemins d'entrée pour éviter les erreurs.

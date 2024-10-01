# Changelog pour GeoFolder.ps1

Toutes les modifications notables apportées à ce script seront documentées dans ce fichier.

## [0.0.4] - 2024-04-29

### Corrigé
- Résolution des erreurs d'indexation de tableau null dans la fonction Get-GpsCoordinates en utilisant Select-String
- Amélioration de la robustesse de l'extraction des coordonnées GPS

## [0.0.3] - 2024-04-29

### Corrigé
- Amélioration de la gestion des erreurs pour les fichiers sans coordonnées GPS
- Élimination des erreurs d'indexation de tableau null dans la fonction Get-GpsCoordinates

## [0.0.2] - 2024-04-29

### Ajouté
- Affichage de la version du script au début de l'exécution
- Barre de progression avec estimation du temps restant
- Traitement récursif des fichiers dans les sous-dossiers
- Compteurs pour les fichiers déplacés et les fichiers sans données GPS
- Résumé à la fin du traitement pour chaque extension de fichier

### Modifié
- Amélioration de la vérification de la présence d'ExifTool
- Restructuration du code avec une fonction principale `Sort-FilesByGeoLocation`
- Amélioration de la gestion des erreurs lors du déplacement des fichiers

### À faire
- Ajouter une option pour personnaliser la précision de la géolocalisation (ville, pays, etc.)
- Optimiser les performances pour le traitement de grandes quantités de photos
- Ajouter une interface utilisateur graphique

## [0.0.1] - 2024-04-29

### Ajouté
- Fonctionnalité initiale pour lire les données GPS des photos
- Création de dossiers basés sur les données de géolocalisation
- Déplacement des photos dans les dossiers correspondants
- Utilisation de l'API Nominatim pour obtenir les noms de villes
- Gestion des erreurs pour les photos sans données GPS

## [0.0.3] - 2024-04-29

### Corrigé
- Amélioration de la gestion des erreurs pour les fichiers sans coordonnées GPS
- Élimination des erreurs d'indexation de tableau null dans la fonction Get-GpsCoordinates

## [0.0.4] - 2024-04-29

### Corrigé
- Résolution des erreurs d'indexation de tableau null dans la fonction Get-GpsCoordinates en utilisant Select-String
- Amélioration de la robustesse de l'extraction des coordonnées GPS


# Changelog

Toutes les modifications notables apportées à ce projet seront documentées dans ce fichier.

## [1.3.0] - 2023-04-27

### Ajouté
- Création d'un fichier CHANGELOG global pour le projet
- Le projet est maintenant public sur GitHub

### Modifié
- Renommage du fichier de changelog spécifique au script en CHANGELOG-trier_par_date.md

### Documentation
- Mise à jour du README.md pour inclure des informations sur le projet public
- Ajout d'une section "Contribution" dans le README.md

## [1.2.0] - 2023-04-26

### Ajouté
- Script de tri de fichiers par date (trier_par_date.ps1)
- Vérification de la présence d'ExifTool dans le PATH système
- Affichage de la version du script au démarrage

### Modifié
- Utilisation de la variable PATH de Windows pour localiser ExifTool au lieu d'un chemin fixe
- Remplacement du paramètre `exifToolPath` par `exifToolName`

### Documentation
- Création du fichier README.md avec les instructions d'utilisation
- Création du fichier CHANGELOG-trier_par_date.md pour suivre les modifications du script

## [1.1.0] - 2023-04-25

### Ajouté
- Compteur de fichiers traités dans la barre de progression
- Affichage du nombre total de fichiers à traiter

### Modifié
- Amélioration de l'affichage de la progression avec un pourcentage plus précis
- Mise à jour du format de la barre de progression pour inclure plus d'informations

### Optimisé
- Calcul du temps restant estimé basé sur le temps moyen de traitement par fichier

## [1.0.0] - 2023-04-24

### Ajouté
- Première version du script de tri de fichiers par date
- Support pour plusieurs extensions de fichiers
- Utilisation d'ExifTool pour extraire les dates de capture
- Gestion des erreurs pour les fichiers sans date de capture
- Barre de progression simple

### Configuré
- Paramètres pour le répertoire cible, le chemin d'ExifTool et les extensions de fichiers supportées

### Sécurité
- Validation des chemins d'entrée pour éviter les erreurs

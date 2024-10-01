# Changelog pour trier_par_date.ps1

## [1.2.0] - 2023-04-26

### Modifié
- Utilisation de la variable PATH de Windows pour localiser ExifTool au lieu d'un chemin fixe
- Remplacement du paramètre `exifToolPath` par `exifToolName`
- Mise à jour de la vérification de la présence d'ExifTool dans le PATH

### Ajouté
- Nouvelle vérification pour s'assurer qu'ExifTool est accessible dans le PATH système

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
- Fonctionnalité de base pour trier les fichiers par date
- Support pour plusieurs extensions de fichiers
- Utilisation d'ExifTool pour extraire les dates de capture
- Gestion des erreurs pour les fichiers sans date de capture
- Barre de progression simple

### Configuré
- Paramètres pour le répertoire cible, le chemin d'ExifTool et les extensions de fichiers supportées

### Sécurité
- Validation des chemins d'entrée pour éviter les erreurs
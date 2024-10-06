# Changelog pour trier_par_date.ps1

Toutes les modifications notables apportées à ce script seront documentées dans ce fichier.

## [1.6.2] - 2024-04-11

### Corrigé
- Résolution d'un bug dans la déclaration des paramètres du script causant des erreurs d'affectation

## [1.6.1] - 2024-04-10

### Ajouté
- Extraction automatique de la version du script depuis les notes du script

### Modifié
- La version du script est maintenant affichée dynamiquement au démarrage, en utilisant la version extraite des notes

### Optimisé
- Suppression de la variable $scriptVersion codée en dur, remplacée par l'extraction dynamique

## [1.6.0] - 2023-04-30

### Ajouté
- Nouveau paramètre optionnel `destinationDir` pour spécifier un dossier de destination différent
- Possibilité de trier les fichiers dans un dossier différent du dossier source

### Modifié
- La fonction `Sort-FilesByDate` utilise maintenant le dossier de destination spécifié s'il est fourni
- Le dossier source reste le dossier de destination par défaut si aucun dossier de destination n'est spécifié

### Documentation
- Mise à jour des commentaires dans le script pour expliquer l'utilisation du nouveau paramètre
- Ajout d'exemples d'utilisation avec et sans le nouveau paramètre `destinationDir`

## [1.5.0] - 2023-04-29

### Modifié
- Mise à jour de la version du script à 1.5.0
- Amélioration de la gestion des erreurs lors de l'extraction de la date
- Optimisation de la fonction Get-DateTaken

### Documentation
- Mise à jour des commentaires dans le script pour une meilleure lisibilité

## [1.2.0] - 2023-04-26

### Ajouté
- Nouvelle vérification pour s'assurer qu'ExifTool est accessible dans le PATH système
- Affichage de la version du script au démarrage

### Modifié
- Utilisation de la variable PATH de Windows pour localiser ExifTool au lieu d'un chemin fixe
- Remplacement du paramètre `exifToolPath` par `exifToolName`
- Mise à jour de la vérification de la présence d'ExifTool dans le PATH

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
- Paramètres pour le répertoire cible, le nom de l'exécutable ExifTool et les extensions de fichiers supportées

### Sécurité
- Validation des chemins d'entrée pour éviter les erreurs

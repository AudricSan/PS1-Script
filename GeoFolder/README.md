# Script d'organisation par géolocalisation

Ce script PowerShell utilise les données GPS des photos pour les organiser automatiquement dans des dossiers par lieu.

## Fonctionnalités

- Lecture des métadonnées GPS des photos
- Création de dossiers basés sur les informations de géolocalisation
- Organisation automatique des photos dans les dossiers correspondants

## Utilisation

1. Placez le script `organiser_par_geolocalisation.ps1` dans le dossier contenant vos photos.
2. Ouvrez PowerShell et naviguez jusqu'au dossier contenant le script.
3. Exécutez le script en utilisant la commande suivante :

   ```
   .\organiser_par_geolocalisation.ps1
   ```

4. Le script analysera toutes les photos du dossier et les organisera en fonction de leur géolocalisation.

## Prérequis

- PowerShell 5.1 ou supérieur
- Module PowerShell ExifTool (pour lire les métadonnées GPS)

## Remarque

Assurez-vous que vos photos contiennent des données GPS valides pour obtenir les meilleurs résultats. Les photos sans données GPS seront ignorées ou placées dans un dossier "Non géolocalisé".

## Contributions

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request pour améliorer ce script.
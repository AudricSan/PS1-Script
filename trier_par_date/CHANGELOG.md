# Changelog - Scripts de tri par date

Toutes les modifications notables apportées aux scripts de tri seront documentées dans ce fichier.

## [3.0.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté - FONCTIONNALITÉ MAJEURE
- **Fichier récapitulatif automatique** : Création d'un fichier `Recap_Tri_YYYYMMDD_HHMMSS.txt` à chaque exécution
- Le fichier récapitulatif contient :
  - Date et heure du traitement
  - Mode de tri utilisé (Image/Video/Both)
  - Dossiers source et destination
  - Nombre total de fichiers déplacés
  - Liste détaillée de chaque déplacement (nom, source, destination, type)
- Le fichier est créé dans le dossier de destination (ou source si pas de destination spécifiée)

### Modifié
- Ajout d'un système de journalisation interne pour suivre tous les déplacements
- Chaque déplacement est catégorisé : Normal, Doublon, Date_Introuvable
- Affichage d'un message confirmant la création du fichier récapitulatif

### Amélioré
- Meilleure traçabilité des opérations effectuées
- Possibilité de vérifier après coup tous les fichiers déplacés
- Utile pour l'audit et la résolution de problèmes

## [2.9.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté
- **Pattern 3** : Support des dates avec année sur 2 chiffres au format `YYMMDD`
- Conversion intelligente de l'année sur 2 chiffres en 4 chiffres :
  - Si YY >= 50 : année = 19YY (exemple: 99 → 1999)
  - Si YY < 50 : année = 20YY (exemple: 25 → 2025)
- Gère les dates de 1950 à 2049

### Formats supplémentaires maintenant supportés
- ✅ `250921_031329_sh.mp4` → `2025_09_21` (YYMMDD avec underscore)
- ✅ `991225_party.jpg` → `1999_12_25` (année 1999)
- ✅ `backup-250101.zip` → `2025_01_01` (YYMMDD avec tiret)

### Modifié
- Le Pattern Timestamp Unix est maintenant le Pattern 4 (dernière priorité)
- Ordre de détection optimisé pour éviter les faux positifs

## [2.8.0] - 2026-01-10 - trier_par_date.ps1

### Modifié - CHANGEMENT MAJEUR
- **Gestion des doublons complètement revue** : Les fichiers en doublon sont maintenant déplacés dans un sous-dossier "Doublons" au lieu d'être renommés
- Structure des dossiers : `2025_01_10/` contient les fichiers uniques, `2025_01_10/Doublons/` contient les doublons
- Même logique appliquée au dossier "Date_Introuvable"

### Supprimé
- Fonction `Get-UniqueFileName` qui n'est plus nécessaire avec le nouveau système de gestion des doublons

### Ajouté
- Création automatique de sous-dossiers "Doublons" dans chaque dossier de date lorsqu'un doublon est détecté
- Messages d'avertissement spécifiques indiquant qu'un doublon a été déplacé vers le sous-dossier

### Amélioré
- Organisation plus claire : les fichiers uniques et les doublons sont maintenant séparés dans des dossiers distincts
- Plus facile d'identifier et de gérer les doublons après le tri
- Si plusieurs doublons ont le même nom dans le sous-dossier Doublons, un suffixe numérique est ajouté uniquement dans ce cas

## [2.7.1] - 2026-01-10 - trier_par_date.ps1

### Corrigé
- Pattern 2 amélioré pour détecter les dates `YYYYMMDD` au début du nom de fichier
- Support des fichiers commençant directement par une date (ex: `20251201_131817_95.jpg` → `2025_12_01`)
- Le regex utilise maintenant des délimiteurs pour éviter de matcher au milieu de longues séquences de chiffres

### Ajouté
- Détection des fichiers avec format `YYYYMMDD` suivi d'underscore ou autre séparateur
- Exemples supportés : `20251201_131817_95.jpg`, `20250807_photo.jpg`, etc.

## [2.7.0] - 2026-01-10 - trier_par_date.ps1

### Amélioré
- **Refonte majeure** du système de détection de dates dans les noms de fichiers
- Patterns universels qui détectent automatiquement n'importe quel format de date
- Plus besoin de patterns spécifiques pour chaque type de fichier (Screenshot, IMG, VID, etc.)

### Ajouté
- Pattern universel 1 : `YYYY-MM-DD` ou `YYYY_MM_DD` (fonctionne avec n'importe quel préfixe)
- Pattern universel 2 : `YYYYMMDD` collé après une lettre ou underscore
- Validation des dates pour éviter les faux positifs (années valides entre 1990-2099)
- Vérification que les dates extraites sont valides avant traitement

### Formats maintenant supportés (liste non exhaustive)
- ✅ `Screenshot_2025-05-22-01-02-24-176_com.instagram.android.jpg` → `2025_05_22`
- ✅ `IMG-20250923-WA0010.jpg` → `2025_09_23`
- ✅ `VID_20250807_194316.mp4` → `2025_08_07`
- ✅ `photo_2025_12_25.jpg` → `2025_12_25`
- ✅ `backup-2025-01-10.zip` → `2025_01_10`
- ✅ Et tout autre fichier contenant une date au format YYYY-MM-DD ou YYYYMMDD

### Modifié
- Simplification drastique du code avec seulement 3 patterns au lieu de patterns spécifiques
- Meilleure gestion des erreurs avec des validations de dates

## [2.6.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté
- Nouveau pattern de détection pour les screenshots au format `Screenshot_YYYY-MM-DD`
- Support des screenshots Android/iOS avec séparateurs tirets ou underscores
- Exemple : `Screenshot_2025-05-22-01-02-24-176_com.instagram.android.jpg` → `2025_05_22`

### Modifié
- Réorganisation des patterns de détection : Screenshot en priorité, puis VID/IMG, puis timestamp Unix

## [2.5.1] - 2026-01-10 - trier_par_date.ps1

### Corrigé
- Regex de détection de date dans le nom de fichier pour supporter les tirets `-` en plus des underscores `_`
- Les fichiers au format `IMG-YYYYMMDD-...` et `VID-YYYYMMDD-...` sont maintenant correctement détectés
- Exemple : `IMG-20250923-WA0010.jpg` est maintenant trié dans le dossier `2025_09_23`

### Modifié
- Simplification du regex pour être plus flexible et accepter différents formats de séparateurs

## [2.5.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté
- Nouvelle fonction `Get-UniqueFileName` pour gérer les doublons de fichiers
- Création automatique d'un dossier "Date_Introuvable" pour les fichiers dont la date n'a pas pu être extraite
- Renommage automatique des fichiers en doublon avec suffixe numérique (_1, _2, etc.)
- Les fichiers sans date détectable sont maintenant déplacés au lieu d'être ignorés

### Corrigé
- Bug critique empêchant la détection des fichiers lorsque l'option "Inclure les sous-dossiers" est désactivée
- Ajout du wildcard (`*`) au chemin pour que le paramètre `-Include` fonctionne correctement sans `-Recurse`

### Modifié
- Les fichiers sans date détectable sont maintenant triés dans un dossier spécial au lieu d'être laissés dans le dossier source
- Messages d'avertissement améliorés pour indiquer quand un fichier est renommé pour éviter un doublon

## [2.4.0] - 2026-01-10 - trier_par_date.ps1

### Amélioré
- Le fallback par détection de nom s'active maintenant aussi en cas d'erreur EXIF (pas seulement si EXIF est absent)
- Gestion silencieuse des erreurs EXIF : le script tente automatiquement la détection par nom sans afficher d'avertissement
- Messages d'erreur améliorés pour indiquer clairement les méthodes tentées (EXIF et nom de fichier)
- Suppression du caractère "-" retourné par ExifTool quand aucune donnée n'est disponible

### Corrigé
- Les erreurs ExifTool sont maintenant redirigées vers null (2>$null) pour éviter les messages parasites
- Meilleure gestion des cas où ExifTool retourne une valeur mais ne peut pas être parsée

## [2.3.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté
- Mode interactif pour demander les paramètres optionnels s'ils ne sont pas spécifiés en ligne de commande
- Demande interactive du mode de tri (Image/Video/Both) avec menu numéroté
- Demande interactive pour inclure ou non les sous-dossiers (O/N)
- Demande interactive pour le dossier de destination avec option de création automatique
- Validation et gestion des erreurs pour les entrées utilisateur

### Modifié
- Le paramètre `mode` n'a plus de valeur par défaut et sera demandé interactivement si non spécifié
- Affichage coloré et structuré pour les questions interactives
- Validation du dossier de destination avec proposition de création s'il n'existe pas

### Amélioré
- Expérience utilisateur simplifiée pour les utilisateurs non techniques
- Messages clairs et guidage étape par étape lors de la configuration

## [2.2.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté
- Nouveau paramètre `-IncludeSubfolders` (switch) pour contrôler la recherche dans les sous-dossiers
- Par défaut, le script traite uniquement les fichiers du dossier racine spécifié
- Utilisation de `-IncludeSubfolders` pour activer la recherche récursive dans tous les sous-dossiers

### Modifié
- La fonction `Sort-FilesByDate` utilise maintenant conditionnellement `-Recurse` selon le paramètre
- Amélioration de la flexibilité du script pour différents cas d'usage

## [2.1.0] - 2026-01-10 - trier_par_date.ps1

### Ajouté
- Système de fallback pour extraire la date depuis le nom du fichier si les données EXIF ne sont pas disponibles
- Support du format `VID_YYYYMMDD_HHMMSS` (ex: VID_20250807_194316)
- Support du format `IMG_YYYYMMDD_HHMMSS_XXX` (ex: IMG_20250525_005007_428)
- Support des timestamps Unix en secondes et millisecondes (ex: 1756734789499)

### Modifié
- La fonction `Get-DateFromFilename` détecte maintenant plusieurs formats de dates dans les noms de fichiers
- Pour les images, le script essaie d'abord les données EXIF puis se rabat sur le nom du fichier
- Messages verbeux ajoutés pour indiquer quand la date est extraite du nom du fichier

### Optimisé
- Gestion améliorée des timestamps Unix avec support des millisecondes (extraction des 10 premiers chiffres)

## [2.0.0] - 2026-01-10 - trier_par_date_unifie.ps1

### Ajouté
- Nouveau script unifié combinant `trier_par_date.ps1` et `trier_video_par_date.ps1`
- Nouveau paramètre `mode` avec trois options : "Image", "Video", "Both" (par défaut)
- Paramètre `imageExtensions` pour spécifier les extensions d'images (CR2, CR3, JPG, JPEG, PNG, TIF, TIFF par défaut)
- Paramètre `videoExtensions` pour spécifier les extensions de vidéos (MP4, AVI, MKV, MOV, WMV par défaut)
- Fonction `Get-DateFromFilename` pour extraire les dates depuis les timestamps Unix dans les noms de fichiers
- Traitement séparé et statistiques distinctes pour les images et les vidéos

### Modifié
- La fonction `Sort-FilesByDate` accepte maintenant un paramètre `fileType` pour différencier images et vidéos
- Affichage amélioré avec sections dédiées pour chaque type de fichier traité
- Vérification d'ExifTool uniquement si le mode Image est activé

### Fusionné
- Fusion complète des fonctionnalités de `trier_par_date.ps1` (v1.6.2) et `trier_video_par_date.ps1` (v1.0.0)

---

## Historique - trier_video_par_date.ps1

## [1.0.0] - 2024-08-18

### Ajouté
- Script dédié au tri des fichiers vidéo par date
- Extraction de la date depuis les timestamps Unix dans les noms de fichiers
- Support des formats vidéo : MP4, AVI, MKV, MOV, WMV
- Paramètre `destinationDir` pour spécifier un dossier de destination
- Barre de progression avec temps restant estimé
- Gestion des erreurs pour les fichiers sans timestamp

---

## Historique - trier_par_date.ps1

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

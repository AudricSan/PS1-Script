# TStoMP4

Ce script PowerShell permet de convertir automatiquement des fichiers TS en MP4 en utilisant ffmpeg. Il est particulièrement utile pour le traitement par lot de fichiers vidéo TS.

## Prérequis

- PowerShell 5.1 ou supérieur
- ffmpeg installé et accessible dans le PATH système
- Windows 10/11

## Installation

1. Clonez ce dépôt ou téléchargez le script `tstomp4.ps1`
2. Assurez-vous que ffmpeg est installé et accessible dans votre PATH système

## Utilisation

```powershell
.\tstomp4.ps1 -rootDir "chemin/vers/dossier"
```

### Paramètres

- `-rootDir` (Obligatoire) : Le chemin du dossier racine contenant les fichiers à convertir
- `-ffmpegName` (Optionnel) : Le nom de l'exécutable ffmpeg (par défaut : "ffmpeg.exe")

### Structure attendue des fichiers

Le script s'attend à trouver des fichiers `tsfile.list` dans les sous-dossiers du dossier racine. Chaque fichier `tsfile.list` doit contenir la liste des fichiers TS à concaténer.

```
DossierRacine/
├── Dossier1/
│   ├── tsfile.list
│   ├── video1.ts
│   └── video2.ts
└── Dossier2/
    ├── tsfile.list
    ├── video1.ts
    └── video2.ts
```

## Fonctionnalités

- Conversion automatique des fichiers TS en MP4
- Barre de progression avec estimation du temps restant
- Gestion des erreurs
- Nettoyage automatique des fichiers temporaires
- Support du traitement par lot

## Licence

Distribué sous la licence MIT. Voir le fichier `LICENSE` pour plus d'informations.

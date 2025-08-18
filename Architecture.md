# Architecture du Projet

## Structure des Dossiers

PS1_script/
│  Architecture.md
│  CHANGELOG.md
│  idee.md
│  LICENSE
│  README.md
│
├─Calcul Commuterpass Japon
│      CHANGELOG.md
│      Commuterpass1.0.py
│      Commuterpass1.0.sh
│      comuterpass1.5.py
│      comuterpass1.5.sh
│      README.md
│
├─GeoFolder
│      CHANGELOG.md
│      GeoFolder.ps1
│      README.md
│
├─Planning
│      addgoogle.py
│      calcul selaire.py
│      credentials.json
│      planning_2026.json
│      planning.json
│      PlanningGenerator.py
│      token.json
│
├─RenameTimestamp
│      CHANGELOG.md
│      README.md
│      RenameTimestamp.ps1
│
├─sequence rename
│      CHANGELOG.md
│      README.md
│      sequence.ps1
│
├─trier_par_date
│      CHANGELOG.md
│      README.md
│      trier_par_date.ps1
│
└─tsTomp4
       CHANGELOG.md
       README.md
       tstomp4.ps1

## Description des Fichiers et Dossiers

- `README.md` : Description principale du projet, ses objectifs et son utilisation.
- `CHANGELOG.md` : Historique des modifications apportées au projet dans son ensemble.
- `LICENSE` : Termes de la licence GNU General Public License v3.0.
- `.gitignore` : Liste des fichiers et dossiers à ignorer par Git.
- `.gitattributes` : Définition des attributs pour les fichiers du projet.
- `idee.md` : Liste des idées futures pour le projet.
- `Architecture.md` : Ce fichier, décrivant la structure du projet.

### Dossiers des Scripts

#### Calcul Commuterpass Japon
- Scripts Python et Shell pour calculer les pass de transport au Japon
- Versions 1.0 et 1.5 disponibles

#### GeoFolder
- `GeoFolder.ps1` : Script PowerShell pour organiser les photos par géolocalisation
- Documentation complète et suivi des modifications

#### Planning
- Scripts Python pour la gestion de planning
- Intégration avec Google Calendar
- Calculateur de salaire

#### RenameTimestamp
- Script PowerShell pour renommer les fichiers avec horodatage
- Documentation détaillée

#### sequence rename
- Script PowerShell pour le renommage séquentiel de fichiers
- Documentation et suivi des modifications

#### trier_par_date
- Script PowerShell pour trier les fichiers par date
- Documentation complète

#### tsTomp4
- Script PowerShell pour convertir les fichiers .ts en .mp4
- Documentation détaillée

## Remarques

- Chaque script est placé dans son propre dossier avec sa documentation dédiée
- Le projet inclut des scripts PowerShell et Python pour différentes utilisations
- Documentation standardisée avec README.md et CHANGELOG.md pour chaque composant
- Tous les scripts suivent les meilleures pratiques de leur langage respectif
- Les fichiers de documentation globale sont situés à la racine du projet

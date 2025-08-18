# Changelog Global des Scripts

Ce changelog regroupe toutes les modifications majeures apportées à l'ensemble des scripts de ce dépôt.
Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/).

Pour plus de détails sur chaque projet, consultez leurs CHANGELOG respectifs :
- [Planning](Planning/CHANGELOG.md)
- [Calcul Commuterpass Japon](Calcul%20Commuterpass%20Japon/CHANGELOG.md)
- [GeoFolder](GeoFolder/CHANGELOG.md)
- [RenameTimestamp](RenameTimestamp/CHANGELOG.md)
- [sequence rename](sequence%20rename/CHANGELOG.md)
- [trier_par_date](trier_par_date/CHANGELOG.md)
- [tsTomp4](tsTomp4/CHANGELOG.md)

## Versions Actuelles des Projets

### Gestion de Fichiers et Médias
- 🎬 tsTomp4 v1.0.0
- 📝 sequence rename v1.0.0
- 📅 RenameTimestamp v1.3.0
- 📸 trier_par_date v1.6.2
- 🌍 GeoFolder v0.0.4

### Outils de Planification et Calculs
- 📊 Planning Generator v1.0.0
- 🚂 Calcul Commuterpass Japon v1.5.1

## Historique des Versions Majeures

## [2025 T3] - Version Consolidée 2.0.0 - 2025-08-18

### ✨ Nouvelles Fonctionnalités Majeures
- **Système de Planning Complet** (Planning v1.0.0)
  - Générateur de planning annuel avec export JSON
  - Intégration Google Calendar
  - Calculateur de salaire multidevise (JPY/EUR)

### 🔄 Améliorations Significatives
- **Calcul Commuterpass Japon** (v1.5.1)
  - Support des trajets composés
  - Calculs d'économies avancés
  - Versions Python et Shell disponibles

### 🛠️ Outils de Gestion de Fichiers
- **RenameTimestamp** (v1.3.0)
  - Suivi de progression amélioré
- **tsTomp4** (v1.0.0)
  - Interface CLI complète
  - Système de progression en temps réel

## [2025 T1] - Version 1.5.0 - 2025-01-06

### 🚀 Nouvelles Fonctionnalités
- **sequence rename** (v1.0.0)
  - Système de renommage séquentiel pour fichiers MKV
- **RenameTimestamp** (v1.3.0)
  - Ajout du suivi de progression

### 🔄 Améliorations
- **Commuterpass** (v1.5.1)
  - Support des trajets composés
  - Calculs d'optimisation des coûts

## [2024 T2] - Version 1.0.0 - 2024-04-30

### 📸 Gestion de Photos et Fichiers
- **GeoFolder** (v0.0.4)
  - Organisation des photos par géolocalisation
  - Intégration avec API Nominatim
- **trier_par_date** (v1.6.2)
  - Tri automatique par métadonnées EXIF
  - Support multi-extensions
  - Gestion avancée des erreurs

### 🛠️ Infrastructure
- Standardisation des logs d'erreurs
- Amélioration de la documentation
- Support d'ExifTool intégré

## Notes de Maintenance
- Tous les scripts suivent maintenant un format de versioning sémantique
- Documentation standardisée avec des README.md détaillés
- Tests et validation sur Windows 10/11
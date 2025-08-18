# 🛠️ Collection de Scripts PowerShell et Python

Ce dépôt contient une collection de scripts pour l'automatisation de diverses tâches quotidiennes et professionnelles. Il combine la puissance de PowerShell et Python pour offrir des solutions pratiques et efficaces.

## 🎯 Fonctionnalités Principales

- 📁 Organisation automatique de fichiers et médias
- 📸 Gestion avancée des photos avec métadonnées
- 📅 Planification et synchronisation avec Google Calendar
- 🚂 Outils de calcul pour les transports japonais
- 🎥 Conversion et traitement de fichiers vidéo
- ⚡ Scripts performants et faciles à utiliser
- 📊 Génération de rapports et analyses

## 📑 Vue d'ensemble

### Gestion de Fichiers et Médias
- 🎬 [tsTomp4](./tsTomp4/README.md) - Conversion de fichiers .ts en .mp4
- 📝 [Sequence Rename](./sequence%20rename/README.md) - Renommage séquentiel de fichiers
- 📅 [RenameTimestamp](./RenameTimestamp/README.md) - Renommage de fichiers avec horodatage
- 📸 [Tri de fichiers par date](./trier_par_date/README.md) - Organisation chronologique des fichiers
- 🌍 [GeoFolder](./GeoFolder/README.md) - Classement des photos par géolocalisation

### Outils de Planification et Calculs
- 📊 [Planning](./Planning/README.md) - Gestion de planning avec Google Calendar
- 🚂 [Calcul Commuterpass Japon](./Calcul%20Commuterpass%20Japon/README.md) - Optimisation des abonnements de transport

## ⭐ Points Forts

1. [Calcul Commuterpass Japon](./Calcul%20Commuterpass%20Japon/README.md) - Calcul des pass de transport au Japon
2. [GeoFolder](./GeoFolder/README.md) - Organisation des photos par géolocalisation
3. [Planning](./Planning/README.md) - Gestion de planning avec intégration Google Calendar
4. [RenameTimestamp](./RenameTimestamp/README.md) - Renommage de fichiers avec horodatage
5. [Sequence Rename](./sequence%20rename/README.md) - Renommage séquentiel de fichiers
6. [Tri de fichiers par date](./trier_par_date/README.md) - Tri automatique des fichiers par date
7. [tsTomp4](./tsTomp4/README.md) - Conversion de fichiers .ts en .mp4

## 🔧 Prérequis

### Scripts PowerShell
```powershell
# Vérifier la version de PowerShell
$PSVersionTable.PSVersion  # Doit être ≥ 5.1

# Installation des dépendances (Windows)
winget install ExifTool  # Pour GeoFolder et trier_par_date
winget install FFmpeg    # Pour tsTomp4
```

### Scripts Python
```bash
# Vérifier la version de Python
python --version  # Doit être ≥ 3.8

# Installation des dépendances
pip install -r requirements.txt  # Dans chaque dossier de projet
```

## 🚀 Installation Rapide

1. Clonez le dépôt :
```bash
git clone https://github.com/AudricSan/PS1-Script.git
cd PS1-Script
```

2. Installez les dépendances globales :
```powershell
# PowerShell (Admin)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📁 Structure du Projet

```
PS1-Script/
│
├── 📊 Planning/                  # Gestion de planning
│   ├── PlanningGenerator.py     # Génération du planning
│   └── addgoogle.py            # Intégration Google Calendar
│
├── 🌍 GeoFolder/                # Organisation des photos
│   └── GeoFolder.ps1          # Script principal
│
├── 📸 trier_par_date/           # Tri chronologique
│   └── trier_par_date.ps1     # Script principal
│
└── [...autres scripts]
```

Chaque dossier contient :
- Script principal (`.ps1` ou `.py`)
- `README.md` avec documentation détaillée
- `CHANGELOG.md` pour l'historique des versions

## 📖 Documentation

- Consultez le [Wiki](./wiki) pour la documentation complète
- Voir le [CHANGELOG](./CHANGELOG.md) pour l'historique des mises à jour
- Chaque script a son propre guide détaillé dans son dossier

## 🤝 Contribution

Nous accueillons chaleureusement les contributions ! Voici comment participer :

1. 🍴 Forkez le projet
2. 🌿 Créez votre branche (`git checkout -b feature/MonScript`)
3. ✍️ Committez vos changements (`git commit -m 'Ajout: nouveau script'`)
4. 🚀 Pushez la branche (`git push origin feature/MonScript`)
5. 📫 Ouvrez une Pull Request

### Guides de Contribution
- Suivez les conventions de nommage existantes
- Ajoutez une documentation complète
- Incluez des exemples d'utilisation
- Mettez à jour le CHANGELOG

## 📜 Licence

Ce projet est sous licence GNU General Public License v3.0 - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 💬 Support et Communauté

- 🐛 [Signaler un bug](../../issues)
- 💡 [Proposer une fonctionnalité](../../issues)
- 📧 [Contacter le mainteneur](https://github.com/AudricSan)
- 👥 [Voir les contributeurs](../../graphs/contributors)

## 🔍 Utilisation Rapide

```powershell
# Exemple d'utilisation du script de tri par date
.\trier_par_date\trier_par_date.ps1 -sourceDir "C:\Photos"

# Exemple d'utilisation du convertisseur tsTomp4
.\tsTomp4\tstomp4.ps1 -inputFile "video.ts"

# Exemple de génération de planning
python .\Planning\PlanningGenerator.py
```

## 🔄 Mises à jour

Pour mettre à jour vers la dernière version :

```bash
git pull origin main
```

## 📊 État du Projet

- Version actuelle : 2.0.0
- État : Actif
- Python : ≥ 3.8
- PowerShell : ≥ 5.1

---
📅 Dernière mise à jour : 18 août 2025

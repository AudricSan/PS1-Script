# Planning Management System

Ce système est conçu pour gérer les plannings de travail, les synchroniser avec Google Calendar et calculer les salaires. Il est particulièrement adapté pour les travailleurs au Japon, avec support du fuseau horaire japonais et des calculs en Yen.

## 🌟 Fonctionnalités

### 1. Génération de Planning (`PlanningGenerator.py`)
- Création de planning annuel
- Configuration flexible des jours et horaires de travail
- Export au format JSON
- Paramétrage du salaire horaire et des pauses

### 2. Synchronisation Google Calendar (`addgoogle.py`)
- Synchronisation automatique avec Google Calendar
- Authentification sécurisée
- Barre de progression
- Gestion des erreurs

### 3. Calcul de Salaire (`calcul selaire.py`)
- Calcul détaillé des heures travaillées
- Rapport mensuel et annuel
- Prise en compte des pauses
- Calcul en Yen

## 🚀 Installation

1. Clonez le dépôt :
```bash
git clone https://github.com/AudricSan/PS1-Script.git
cd PS1-Script/Planning
```

2. Installez les dépendances :
```bash
pip install google-auth-oauthlib google-auth-httplib2 google-api-python-client
```

3. Configurez l'authentification Google Calendar :
- Créez un projet dans la Google Cloud Console
- Activez l'API Google Calendar
- Téléchargez le fichier `credentials.json`
- Placez-le dans le dossier du projet

## 📝 Configuration

### PlanningGenerator.py
Modifiez les variables en haut du script :
```python
ANNEE = 2026
TIMEZONE = "Asia/Tokyo"
JOURS_TRAVAIL = ["Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
MONEY_HORAIRE = 1078  # yens/heure
BREAK_HEURES = 1     # pause en heures
```

## 🔨 Utilisation

1. Générez votre planning :
```bash
python PlanningGenerator.py
```

2. Synchronisez avec Google Calendar :
```bash
python addgoogle.py
```

3. Calculez votre salaire :
```bash
python "calcul selaire.py"
```

## 📁 Structure des fichiers

- `PlanningGenerator.py` : Génération du planning
- `addgoogle.py` : Synchronisation Google Calendar
- `calcul selaire.py` : Calcul des salaires
- `planning_XXXX.json` : Fichier de planning généré
- `credentials.json` : Identifiants Google Calendar
- `token.json` : Token d'authentification Google

## 🔐 Sécurité

- Les fichiers `credentials.json` et `token.json` contiennent des informations sensibles
- Ne partagez jamais ces fichiers
- Ajoutez-les à votre `.gitignore`

## 📋 Prérequis

- Python 3.x
- Connexion Internet pour la synchronisation Google Calendar
- Compte Google avec accès à Google Calendar API

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des améliorations
- Soumettre des pull requests

## 📜 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## ✉️ Contact

Audric - [@AudricSan](https://github.com/AudricSan)

Lien du projet : [https://github.com/AudricSan/PS1-Script](https://github.com/AudricSan/PS1-Script)

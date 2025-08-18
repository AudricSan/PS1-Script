# Changelog

Tous les changements notables de ce projet seront documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-18

### Ajouté
- Script `PlanningGenerator.py` pour générer un planning annuel au format JSON
  - Configuration des jours travaillés
  - Définition des horaires par jour
  - Configuration du salaire horaire et des pauses
  - Support du fuseau horaire
  - Export au format JSON

- Script `addgoogle.py` pour synchroniser le planning avec Google Calendar
  - Authentification OAuth2 avec Google Calendar
  - Création automatique des événements
  - Gestion des erreurs
  - Barre de progression
  - Support multilingue (français/japonais)

- Script `calcul selaire.py` pour calculer les salaires
  - Calcul des heures travaillées par mois
  - Calcul du salaire mensuel et annuel
  - Prise en compte des pauses
  - Affichage détaillé par mois
  - Support de la monnaie en Yen

### Caractéristiques techniques
- Support des fuseaux horaires
- Format JSON pour le stockage des données
- Gestion des authentifications Google
- Support multilingue
- Calculs précis des heures et salaires

### Configuration requise
- Python 3.x
- Bibliothèques Google Calendar API
- Fichiers de configuration (credentials.json, token.json)
- Fichier de planning au format JSON

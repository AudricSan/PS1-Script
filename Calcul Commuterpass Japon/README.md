# Calcul Commuterpass Japon

Ce dossier contient des scripts pour calculer les économies potentielles réalisées en utilisant des abonnements de transport au Japon.

## Scripts disponibles

1. **Commuterpass1.0.sh** : Script Bash pour calculer les économies et comparer les coûts avec ou sans abonnement.
2. **Commuterpass1.0.py** : Script Python pour effectuer les calculs et afficher les comparaisons.
3. **comuterpass1.5.py** : Version améliorée du script Python avec support pour plusieurs trajets.
4. **comuterpass1.5.sh** : Version Bash améliorée avec support pour plusieurs trajets et calcul du trajet composé.

## Fonctionnalités

- Calcul des coûts sans abonnement et avec différents types d'abonnements (1 mois, 3 mois, 6 mois).
- Comparaison des économies potentielles.
- Affichage des seuils de rentabilité (nombre de trajets nécessaires pour rentabiliser un abonnement).
- Support pour plusieurs trajets.
- **Nouveau** : Calcul des coûts pour un trajet composé (somme de deux trajets).

## Prérequis

- **Bash** : Pour les scripts `.sh`, un environnement Unix/Linux avec Bash.
- **Python** : Pour les scripts `.py`, Python 3.6 ou supérieur.

## Utilisation

### Bash (Commuterpass1.0.sh ou comuterpass1.5.sh)
1. Ouvrez un terminal Unix/Linux.
2. Rendez le script exécutable :
   ```bash
   chmod +x Commuterpass1.0.sh
   chmod +x comuterpass1.5.sh
   ```
3. Exécutez le script :
   ```bash
   ./Commuterpass1.0.sh
   ```
   ou
   ```bash
   ./comuterpass1.5.sh
   ```

### Python (Commuterpass1.0.py ou comuterpass1.5.py)
1. Assurez-vous que Python est installé.
2. Exécutez le script avec :
   ```bash
   python Commuterpass1.0.py
   ```
   ou
   ```bash
   python comuterpass1.5.py
   ```

## Exemple de sortie

Le script affiche une comparaison des coûts mensuels, des économies potentielles et des seuils de rentabilité pour chaque type d'abonnement. Pour `comuterpass1.5.sh`, il inclut également une comparaison pour un trajet composé.

## Changelog

Pour voir l'historique des modifications apportées à ces scripts, consultez le fichier [CHANGELOG](CHANGELOG.md).

## Auteur

Audric_San

## Licence

Ce projet est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.

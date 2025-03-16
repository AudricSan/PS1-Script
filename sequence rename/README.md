# Renommage de fichiers MKV en séquence

Ce script PowerShell permet de renommer des fichiers MKV en séquence, en ajoutant un numéro d'épisode à chaque fichier.

## Fonctionnalités

- Renomme les fichiers MKV en ajoutant un numéro d'épisode séquentiel.
- Supporte les fichiers MKV dans les sous-dossiers.
- Crée le dossier de destination si celui-ci n'existe pas.

## Utilisation

1. Ouvrez PowerShell.
2. Naviguez vers le dossier contenant le script.
3. Exécutez le script en utilisant la commande suivante :

```powershell
.\sequence.ps1
```

4. Suivez les instructions à l'écran pour entrer le chemin du dossier source, le chemin du dossier de destination et le numéro de départ.

## Exemple

```powershell
.\sequence.ps1
```

## Paramètres

- `sourceFolder` : Chemin du dossier contenant les fichiers MKV à renommer.
- `destinationFolder` : Chemin du dossier où sauvegarder les fichiers renommés.
- `startNumber` : Numéro de départ pour la séquence des épisodes.

## Remarques

- Le script vérifie automatiquement si le dossier source et le dossier de destination existent.
- Les fichiers MKV dans les sous-dossiers du dossier source seront également renommés.
- Le script affiche un message de progression pour chaque fichier renommé.

## Auteur

Audric_San

## Licence

Ce script est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.
#!/usr/bin/env python3
"""
.SYNOPSIS
    Ajoute des événements à Google Calendar à partir d'un fichier de planning JSON.

.DESCRIPTION
    Ce script lit un fichier de planning au format JSON et crée les événements correspondants
    dans Google Calendar en utilisant l'API Google Calendar.

.PARAMETERS
    CALENDAR_ID : str
        L'ID de l'agenda Google Calendar où ajouter les événements
    PLANNING_FILE : str
        Le chemin vers le fichier JSON contenant le planning
    CREDENTIALS : str
        Le chemin vers le fichier de credentials Google
    TOKEN : str
        Le chemin vers le fichier token pour l'authentification

.EXAMPLE
    python addgoogle.py

.NOTES
    Version : 1.0.0
    Auteur  : Audric_San
    Date    : 2025/08/18
"""

import datetime
import json
import os.path
import re
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# Configuration des constantes
SCOPES = ['https://www.googleapis.com/auth/calendar']
CALENDAR_ID = "ng6nuk1co4agbpq32eivq1lh90@group.calendar.google.com"
PLANNING_FILE = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\planning.json"
CREDENTIALS = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\credentials.json"
TOKEN = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\token.json"

def get_version():
    """Extrait la version depuis la documentation du script."""
    with open(__file__, 'r', encoding='utf-8') as f:
        content = f.read()
        version_match = re.search(r'Version\s*:\s*([\d\.]+)', content)
        return version_match.group(1) if version_match else "Version inconnue"

def verify_files():
    """Vérifie la présence des fichiers nécessaires."""
    required_files = {
        'Planning': PLANNING_FILE,
        'Credentials': CREDENTIALS,
    }
    
    for name, path in required_files.items():
        if not os.path.exists(path):
            raise FileNotFoundError(f"Le fichier {name} n'a pas été trouvé : {path}")

def connecter_google_calendar():
    """
    Établit la connexion avec Google Calendar.
    
    Returns:
        service: L'objet service Google Calendar authentifié
    """
    creds = None
    if os.path.exists(TOKEN):
        creds = Credentials.from_authorized_user_file(TOKEN, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS, SCOPES)
            creds = flow.run_local_server(port=0)
        with open(TOKEN, 'w') as token:
            token.write(creds.to_json())
    
    try:
        service = build('calendar', 'v3', credentials=creds)
        return service
    except Exception as e:
        raise ConnectionError(f"Erreur lors de la connexion à Google Calendar : {str(e)}")

def creer_evenement(service, summary, start_datetime, end_datetime, timezone, calendar_id=CALENDAR_ID):
    """
    Crée un événement dans Google Calendar.
    
    Args:
        service: L'objet service Google Calendar
        summary (str): Le titre de l'événement
        start_datetime (datetime): Date et heure de début
        end_datetime (datetime): Date et heure de fin
        timezone (str): Le fuseau horaire
        calendar_id (str): L'ID du calendrier
    """
    event = {
        'summary': summary,
        'start': {
            'dateTime': start_datetime.isoformat(),
            'timeZone': timezone,
        },
        'end': {
            'dateTime': end_datetime.isoformat(),
            'timeZone': timezone,
        }
    }
    try:
        event = service.events().insert(calendarId=calendar_id, body=event).execute()
        print(f"Événement créé : {event.get('summary')} "
              f"({event.get('start')['dateTime']} - {event.get('end')['dateTime']})")
    except Exception as e:
        print(f"Erreur lors de la création de l'événement : {str(e)}")

def ajouter_evenements_depuis_planning(planning_json, service, calendar_id=CALENDAR_ID):
    """
    Ajoute les événements depuis le fichier de planning.
    
    Args:
        planning_json (dict): Les données du planning
        service: L'objet service Google Calendar
        calendar_id (str): L'ID du calendrier
    """
    total_events = sum(len(jours) for mois in planning_json[str(planning_json["info"]["année"])].values() 
                      for semaine in mois.values() for jours in semaine.values())
    processed_events = 0
    
    annee = str(planning_json["info"]["année"])
    mois_data = planning_json[annee]
    timezone = planning_json["info"].get("timezone", "Asia/Tokyo")
    nom_evenement = planning_json["info"].get("name", "Travail")

    for mois, semaines in mois_data.items():
        for semaine, jours in semaines.items():
            for jour_fr, horaires in jours.items():
                if horaires.get("Travail", True) is None:
                    continue

                try:
                    date_str = horaires["Date"]
                    dt_date = datetime.datetime.strptime(date_str, "%Y/%m/%d").date()

                    debut_str = horaires["Début"]
                    fin_str = horaires["Fin"]
                    heure_debut, minute_debut = map(int, debut_str.split(":"))
                    heure_fin, minute_fin = map(int, fin_str.split(":"))

                    dt_debut = datetime.datetime.combine(dt_date, datetime.time(heure_debut, minute_debut))
                    dt_fin = datetime.datetime.combine(dt_date, datetime.time(heure_fin, minute_fin))

                    creer_evenement(service, nom_evenement, dt_debut, dt_fin, timezone, calendar_id)
                    
                    processed_events += 1
                    progress = (processed_events / total_events) * 100
                    print(f"\rProgression : {progress:.2f}% - Événements traités : {processed_events}/{total_events}", 
                          end="", flush=True)
                    
                except Exception as e:
                    print(f"\nErreur lors du traitement de l'événement du {date_str}: {str(e)}")

    print("\nTraitement terminé.")

def main():
    """Fonction principale du script."""
    print(f"Exécution du script d'ajout d'événements Google Calendar (version {get_version()})")
    
    try:
        verify_files()
        
        with open(PLANNING_FILE, "r", encoding="utf-8") as f:
            planning = json.load(f)

        service = connecter_google_calendar()
        ajouter_evenements_depuis_planning(planning, service)
        
    except Exception as e:
        print(f"Erreur : {str(e)}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
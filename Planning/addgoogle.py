import datetime
import json
import os.path
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# Autorisations Google Calendar : read/write
SCOPES = ['https://www.googleapis.com/auth/calendar']

# ID de l'agenda Google Calendar (modifiable ici)
CALENDAR_ID = "ng6nuk1co4agbpq32eivq1lh90@group.calendar.google.com"
PLANNING_FILE = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\planning.json"
CREDENTIALS = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\credentials.json"
TOKEN = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\token.json"

def connecter_google_calendar():
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
    service = build('calendar', 'v3', credentials=creds)
    return service

def creer_evenement(service, summary, start_datetime, end_datetime, timezone, calendar_id=CALENDAR_ID):
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
    event = service.events().insert(calendarId=calendar_id, body=event).execute()
    print(f"Événement créé : {event.get('summary')} ({event.get('start')['dateTime']} - {event.get('end')['dateTime']})")

def ajouter_evenements_depuis_planning(planning_json, service, calendar_id=CALENDAR_ID):
    annee = str(planning_json["info"]["année"])
    mois_data = planning_json[annee]
    timezone = planning_json["info"].get("timezone", "Asia/Tokyo")
    nom_evenement = planning_json["info"].get("name", "Travail")

    for mois, semaines in mois_data.items():
        for semaine, jours in semaines.items():
            annee_int = int(annee)
            mois_int = int(mois)

            for jour_fr, horaires in jours.items():
                if horaires.get("Travail", True) is None:
                    continue

                date_str = horaires["Date"]
                dt_date = datetime.datetime.strptime(date_str, "%Y/%m/%d").date()

                debut_str = horaires["Début"]
                fin_str = horaires["Fin"]
                heure_debut, minute_debut = map(int, debut_str.split(":"))
                heure_fin, minute_fin = map(int, fin_str.split(":"))

                dt_debut = datetime.datetime.combine(dt_date, datetime.time(heure_debut, minute_debut))
                dt_fin = datetime.datetime.combine(dt_date, datetime.time(heure_fin, minute_fin))

                summary = nom_evenement  # Nom global pour tous les événements

                creer_evenement(service, summary, dt_debut, dt_fin, timezone, calendar_id)

if __name__ == "__main__":
    nom_fichier = PLANNING_FILE
    with open(nom_fichier, "r", encoding="utf-8") as f:
        planning = json.load(f)

    service = connecter_google_calendar()
    ajouter_evenements_depuis_planning(planning, service)
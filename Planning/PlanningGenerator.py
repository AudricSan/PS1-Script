import datetime
import calendar
import json

# ======= PARAMÈTRES MODIFIABLES =======
ANNEE = 2026
TIMEZONE = "Asia/Tokyo"
MONEY_UNIT = "yens"
BREAK_UNIT = "heures"
NAME = "ファミリーマート"

# Jours travaillés (en français)
JOURS_TRAVAIL = ["Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]

# Horaires par jour (début, fin)
HORAIRES = {
    "Mardi":    ("09:00", "18:00"),
    "Mercredi": ("09:00", "18:00"),
    "Jeudi":    ("09:00", "18:00"),
    "Vendredi": ("07:00", "18:00"),
    "Samedi":   ("09:00", "18:00"),
}

MONEY_HORAIRE = 1078  # yens / heure
BREAK_HEURES = 1        # pause quotidienne en heures

# Mapping jours français vers numéro ISO (lundi=1 ... dimanche=7)
JOURS_FR_NUM = {
    "Lundi": 1,
    "Mardi": 2,
    "Mercredi": 3,
    "Jeudi": 4,
    "Vendredi": 5,
    "Samedi": 6,
    "Dimanche": 7
}

# ======= FIN DES PARAMÈTRES =======

def generate_planning(annee, jours_travail, horaires):
    planning = {}

    # Info générales
    planning["info"] = {
        "année": annee,
        "salaire_horaire": MONEY_HORAIRE,
        "pause_heures": BREAK_HEURES,
        "unité_salaire": MONEY_UNIT,
        "unité_pause": BREAK_UNIT,
        "timezone": TIMEZONE,
        "name": NAME
    }

    planning[str(annee)] = {}

    for mois in range(1, 13):
        planning[str(annee)][f"{mois:02d}"] = {}
        premier_jour = datetime.date(annee, mois, 1)
        dernier_jour = datetime.date(annee, mois, calendar.monthrange(annee, mois)[1])

        jour_courant = premier_jour
        semaines_temp = {}

        while jour_courant <= dernier_jour:
            semaine_num = jour_courant.isocalendar()[1]

            semaine_cle = f"Semaine {semaine_num}"
            if semaine_cle not in semaines_temp:
                semaines_temp[semaine_cle] = {}

            jour_fr = jour_courant.strftime("%A")
            mapping_jour_fr = {
                "Monday": "Lundi",
                "Tuesday": "Mardi",
                "Wednesday": "Mercredi",
                "Thursday": "Jeudi",
                "Friday": "Vendredi",
                "Saturday": "Samedi",
                "Sunday": "Dimanche"
            }
            jour_fr = mapping_jour_fr[jour_fr]

            date_str = jour_courant.strftime("%Y/%m/%d")

            if jour_fr in jours_travail:
                debut, fin = horaires.get(jour_fr, ("09:00", "18:00"))
                semaines_temp[semaine_cle][jour_fr] = {
                    "Date": date_str,
                    "Début": debut,
                    "Fin": fin
                }
            else:
                semaines_temp[semaine_cle][jour_fr] = {
                    "Date": date_str,
                    "Travail": None
                }

            jour_courant += datetime.timedelta(days=1)

        # Filtrer jours hors mois dans chaque semaine
        for semaine_cle, jours in semaines_temp.items():
            jours_filtrés = {}
            for jour_fr, data_jour in jours.items():
                # retrouver date du jour via isocalendar (année, semaine, jour_iso)
                # on peut retrouver date comme lundi + (jour_num -1) jours
                semaine_num = int(semaine_cle.split()[1])
                lundi_semaine = datetime.date.fromisocalendar(annee, semaine_num, 1)
                # ici on ne calcule plus jour_num, on utilise date_str déjà présente
                date_jour = datetime.datetime.strptime(data_jour["Date"], "%Y/%m/%d").date()
                if date_jour.month == mois:
                    jours_filtrés[jour_fr] = data_jour
            if jours_filtrés:
                planning[str(annee)][f"{mois:02d}"][semaine_cle] = jours_filtrés

    return planning

if __name__ == "__main__":
    planning = generate_planning(ANNEE, JOURS_TRAVAIL, HORAIRES)
    nom_fichier = f"planning_{ANNEE}.json"
    with open(nom_fichier, "w", encoding="utf-8") as f:
        json.dump(planning, f, ensure_ascii=False, indent=2)
    print(f"Planning sauvegardé dans '{nom_fichier}'.")

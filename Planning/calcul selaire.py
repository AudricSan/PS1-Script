import json
import datetime

def heures_travaillees(debut_str, fin_str, pause_heures):
    fmt = "%H:%M"
    debut = datetime.datetime.strptime(debut_str, fmt)
    fin = datetime.datetime.strptime(fin_str, fmt)
    delta = fin - debut
    heures = delta.total_seconds() / 3600
    heures_net = heures - pause_heures
    return max(0, heures_net)

def calcul_salaire(planning_json):
    info = planning_json["info"]
    salaire_horaire = info["salaire_horaire"]
    pause = info["pause_heures"]
    annee = str(info["année"])

    mois_data = planning_json[annee]

    heures_par_mois = {}
    salaire_par_mois = {}
    for mois, semaines in mois_data.items():
        total_heures_mois = 0
        for semaine, jours in semaines.items():
            for jour, horaires in jours.items():
                # Vérifie que horaires est bien un dict avec les clés "Début" et "Fin"
                if not isinstance(horaires, dict) or "Début" not in horaires or "Fin" not in horaires:
                    continue  # Ignore les jours non travaillés ou mal formatés
                h = heures_travaillees(horaires["Début"], horaires["Fin"], pause)
                total_heures_mois += h
        heures_par_mois[mois] = total_heures_mois
        salaire_par_mois[mois] = total_heures_mois * salaire_horaire

    total_annee = sum(heures_par_mois.values())
    salaire_annee = total_annee * salaire_horaire

    salaire_moyen_mensuel = salaire_annee / 12

    return {
        "heures_par_mois": heures_par_mois,
        "salaire_par_mois": salaire_par_mois,
        "heures_totales": total_annee,
        "salaire_annuel": salaire_annee,
        "salaire_moyen_mensuel": salaire_moyen_mensuel
    }

if __name__ == "__main__":
    nom_fichier = "D:\\audri\\Documents\\AudricDev\\PS1_script\\Planning\\planning.json"
    with open(nom_fichier, "r", encoding="utf-8") as f:
        planning = json.load(f)

    resultats = calcul_salaire(planning)

    mois_fr = {
        "01": "Janvier",
        "02": "Février",
        "03": "Mars",
        "04": "Avril",
        "05": "Mai",
        "06": "Juin",
        "07": "Juillet",
        "08": "Août",
        "09": "Septembre",
        "10": "Octobre",
        "11": "Novembre",
        "12": "Décembre"
    }

    print("=== Estimation du salaire ===")
    for mois_num in sorted(resultats["salaire_par_mois"].keys()):
        salaire = resultats["salaire_par_mois"][mois_num]
        print(f"{mois_fr[mois_num]} = {salaire:.2f} Yen // {resultats['heures_par_mois'][mois_num]:.2f} h" )

    print("=====================")
    print(f"Heures totales dans l'année : {resultats['heures_totales']:.2f} h")
    print(f"Salaire annuel estimé : {resultats['salaire_annuel']:.2f} yens")
    print(f"Salaire mensuel moyen : {resultats['salaire_moyen_mensuel']:.2f} yens")

def calcul_economies(n_j=2, n_jours_travail=None, abonnements=None):
    """
    Calcule les coûts sans abonnement et les coûts des abonnements.
    Retourne également les économies potentielles.
    pour une seule ligne A-B / B-A.
    """
    S_m = 4.33  # Nombre moyen de semaines par mois, utilisé pour des calculs d'abonnements sur plusieurs mois

    # Calcul du nombre de trajets par mois
    if n_jours_travail is not None:
        n_m = n_j * n_jours_travail
    else:
        n_m = n_j * 30  # Par défaut, tous les jours du mois (30 jours)

    # Calcul des coûts des abonnements pour chaque type d'abonnement
    couts_abo = {}
    c_sans_abo = {}
    if abonnements:
        for nom, details in abonnements.items():
            pt = details["pt"]
            c_sans_abo[nom] = pt * n_m  # Coût sans abonnement pour cet abonnement
            couts_abo[nom] = {
                "1 mois": details.get("1 mois"),
                "3 mois": details.get("3 mois"),
                "6 mois": details.get("6 mois"),
            }

    return c_sans_abo, couts_abo

def afficher_comparaison(c_sans_abo, couts_abo, n_jours_travail):
    """
    Affiche une comparaison des coûts avec et sans abonnement,
    ainsi que le seuil de rentabilité (le nombre de trajets à partir duquel un abonnement est rentable).
    """
    print("\nComparaison des coûts mensuels :")
    print(f"Nombre de jours de travail par mois : {n_jours_travail if n_jours_travail else 'Tous les jours'}")
    print("-" * 101)
    print(f"| {'Type':<15} | {'Prix abo (¥)':>15} | {'Coût trajet (¥)':>15} | {'Économie (¥)':>15} | {'Seuil (trajets)':>15} | {'Jours travaillés':>15} |")
    print("-" * 101)
    
    for nom, tarifs in couts_abo.items():
        # Ajout du coût par trajet unique à côté du nom de l'abonnement
        cout_trajet_unique = abonnements[nom]["pt"]
        print(f"Abonnement : {nom} (Coût trajet unique : {cout_trajet_unique:.2f} ¥)")
        print(f"| {'Sans abo':<15} | {'-':>15} | {c_sans_abo[nom]:>15.2f} | {'-':>15} | {'-':>15} | {n_jours_travail if n_jours_travail else 'Tous':>15} |")
        for duree, cout in tarifs.items():
            if cout is None:
                continue
            if duree == "1 mois":
                total_jours = n_jours_travail
            elif duree == "3 mois":
                total_jours = n_jours_travail * 3 if n_jours_travail else 'Tous'
            elif duree == "6 mois":
                total_jours = n_jours_travail * 6 if n_jours_travail else 'Tous'
            else:
                total_jours = '-'

            economie = c_sans_abo[nom] - (cout / (1 if duree == "1 mois" else (3 if duree == "3 mois" else 6)))
            economie_str = f"\033[92m{economie:>15.2f}\033[0m" if economie > 0 else f"\033[91m{economie:>15.2f}\033[0m"
            
            # Correction : Calcul du coût par trajet
            if n_jours_travail:
                total_trajets = n_jours_travail * 2 * (1 if duree == "1 mois" else (3 if duree == "3 mois" else 6))
            else:
                total_trajets = 30 * 2 * (1 if duree == "1 mois" else (3 if duree == "3 mois" else 6))
            cout_par_trajet = cout / total_trajets
            cout_par_trajet_str = f"{cout_par_trajet:>15.2f}"

            if n_jours_travail:
                seuil_rentabilite = cout / (abonnements[nom]["pt"] * 2)
            else:
                seuil_rentabilite = cout / (abonnements[nom]["pt"] * 2)

            seuil_str = f"{seuil_rentabilite:>15.2f}"
            
            print(f"| {duree:<15} | {cout:>15.2f} | {cout_par_trajet_str} | {economie_str} | {seuil_str} | {total_jours:>15} |")
        print("-" * 101)

if __name__ == "__main__":
    # Demande des valeurs à l'utilisateur
    try:
        n_jours_travail = input("Nombre de jours de travail par mois (laisser vide pour tous les jours) : ")
        n_jours_travail = int(n_jours_travail) if n_jours_travail else None
        
        abonnements = {}
        while True:
            nom = input("Nom de l'abonnement (laisser vide pour terminer) : ")
            if not nom:
                break
            pt = float(input("Prix d'un trajet (¥) : "))
            a1 = float(input(f"Prix de l'abonnement {nom} 1 mois (¥) : "))
            a3 = float(input(f"Prix de l'abonnement {nom} 3 mois (¥) : "))
            a6 = float(input(f"Prix de l'abonnement {nom} 6 mois (¥) : "))
            abonnements[nom] = {'pt': pt, "1 mois": a1, "3 mois": a3, "6 mois": a6}

        # Calcul et affichage des résultats
        c_sans_abo, couts_abo = calcul_economies(2, n_jours_travail, abonnements)
        afficher_comparaison(c_sans_abo, couts_abo, n_jours_travail)

    except ValueError:
        print("Erreur : Veuillez entrer des valeurs numériques valides.")

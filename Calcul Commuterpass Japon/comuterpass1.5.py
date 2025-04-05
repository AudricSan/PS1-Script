def calcul_economies(pt, n_j=2, n_jours_travel=None, a1=None, a3=None, a6=None):
    S_m = 4.33

    if n_jours_travel is not None:
        # Si un nombre de jours de travail est spécifié, on calcule les trajets sur ces jours
        n_m = n_j * n_jours_travel
    else:
        # Si aucun nombre de jours n'est spécifié, on suppose qu'on prend le train tous les jours du mois
        n_m = n_j * 30  # Par défaut, tous les jours du mois (30 jours)

    # Coût sans abonnement : coût du trajet multiplié par le nombre de trajets mensuels
    c_sans_abo = pt * n_m

    # Calcul des coûts des abonnements (sur 1, 3 et 6 mois)
    couts_abo = {}
    if a1 is not None:
        couts_abo["1 mois"] = a1  # Si l'abonnement de 1 mois est spécifié, on l'ajoute au dictionnaire
    if a3 is not None:
        couts_abo["3 mois"] = a3  # Si l'abonnement de 3 mois est spécifié, on l'ajoute
    if a6 is not None:
        couts_abo["6 mois"] = a6  # Si l'abonnement de 6 mois est spécifié, on l'ajoute

    return c_sans_abo, couts_abo

def afficher_comparaison(c_sans_abo, couts_abo, n_jours_travel, trajet_label, pt):
    print(f"\nComparaison des coûts mensuels pour le {trajet_label} :")
    print("-" * 101)
    print(f"| {'Type':<15} | {'Prix abo (¥)':>15} | {'Coût trajet (¥)':>15} | {'Économie (¥)':>15} | {'Seuil (trajets)':>15} | {'Jours travaillés':>15} |")
    print("-" * 101)
    print(f"| {'Sans abo':<15} | {'-':>15} | {c_sans_abo:>15.2f} | {'-':>15} | {'-':>15} | {n_jours_travel if n_jours_travel else 'Tous les jours'} |")

    for duree, cout in couts_abo.items():
        if duree == "1 mois":
            total_jours = n_jours_travel
        elif duree == "3 mois":
            total_jours = n_jours_travel * 3 if n_jours_travel else 'Tous les jours'
        elif duree == "6 mois":
            total_jours = n_jours_travel * 6 if n_jours_travel else 'Tous les jours'
        else:
            total_jours = '-'

        economie = c_sans_abo - (cout / (1 if duree == "1 mois" else (3 if duree == "3 mois" else 6)))
        economie_str = f"\033[92m{economie:>15.2f}\033[0m" if economie > 0 else f"\033[91m{economie:>15.2f}\033[0m"

        cout_par_trajet = cout / (n_jours_travel * 2 * (1 if duree == "1 mois" else (3 if duree == "3 mois" else 6)))
        cout_par_trajet_str = f"{cout_par_trajet:>15.2f}"

        seuil = cout / (pt * 2)
        print(f"| {duree:<15} | {cout:>15.2f} | {cout_par_trajet_str} | {economie_str} | {seuil:>15.2f} | {total_jours if total_jours else 'Tous les jours'} |")

    print("-" * 101)

def main():
    try:
        # Demande du nombre de jours de travail par mois
        n_jours_travel = input("Nombre de jours de travail par mois (laisser vide pour tous les jours) : ")
        n_jours_travel = int(n_jours_travel) if n_jours_travel else None

        # Demande des prix des trajets et abonnements pour les deux trajets
        print("\n=== Trajet 1 ===")
        pt1 = float(input("Prix d'un trajet (¥) : "))
        a1_1 = float(input("Prix de l'abonnement 1 mois (¥) : "))
        a3_1 = float(input("Prix de l'abonnement 3 mois (¥) : "))
        a6_1 = float(input("Prix de l'abonnement 6 mois (¥) : "))

        print("\n=== Trajet 2 ===")
        pt2 = float(input("Prix d'un trajet (¥) : "))
        a1_2 = float(input("Prix de l'abonnement 1 mois (¥) : "))
        a3_2 = float(input("Prix de l'abonnement 3 mois (¥) : "))
        a6_2 = float(input("Prix de l'abonnement 6 mois (¥) : "))

        # Calcul et affichage des résultats pour le premier trajet
        c_sans_abo1, couts_abo1 = calcul_economies(pt1, 2, n_jours_travel, a1_1, a3_1, a6_1)
        print("\nComparaison du trajet 1")
        afficher_comparaison(c_sans_abo1, couts_abo1, n_jours_travel, "Trajet 1", pt1)

        # Calcul et affichage des résultats pour le deuxième trajet
        c_sans_abo2, couts_abo2 = calcul_economies(pt2, 2, n_jours_travel, a1_2, a3_2, a6_2)
        print("\nComparaison du trajet 2")
        afficher_comparaison(c_sans_abo2, couts_abo2, n_jours_travel, "Trajet 2", pt2)

        # Calcul et affichage des résultats pour le trajet Special
        if n_jours_travel is not None:
            afficher_special = input("\nVoulez-vous Calculer le trajet composé ? (oui/non) : ").strip().lower()
            if afficher_special == "oui":
                c_sans_abo3 = (pt1 + pt2) * n_jours_travel
                print("\nComparaison du trajet Composé")
                print(f"Coût total sans abonnement pour le trajet composé : {c_sans_abo3:.2f} ¥")

    except ValueError:
        print("Erreur : Veuillez entrer des valeurs numériques valides.")

if __name__ == "__main__":
    main()
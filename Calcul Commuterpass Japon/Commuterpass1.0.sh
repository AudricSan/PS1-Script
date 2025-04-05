#!/bin/bash

calcul_economies() {
    local n_j=${1:-2}
    local n_jours_travail=$2
    declare -A abonnements=("${!3}")
    local S_m=4.33
    local n_m
    local -A c_sans_abo couts_abo

    if [[ -n "$n_jours_travail" ]]; then
        n_m=$((n_j * n_jours_travail))
    else
        n_m=$((n_j * 30))
    fi

    echo "DEBUG: Nombre total de trajets par mois : $n_m"

    for nom in "${!abonnements[@]}"; do
        IFS=";" read -r pt a1 a3 a6 <<<"${abonnements[$nom]}"
        if [[ -z "$pt" || -z "$a1" || -z "$a3" || -z "$a6" ]]; then
            echo "Erreur : Données manquantes pour l'abonnement $nom."
            continue
        fi
        c_sans_abo[$nom]=$(echo "$pt * $n_m" | bc)
        couts_abo[$nom]="$a1;$a3;$a6"
        echo "DEBUG: $nom - Coût sans abonnement : ${c_sans_abo[$nom]}, Coûts abonnements : ${couts_abo[$nom]}"
    done

    declare -p c_sans_abo couts_abo
}

afficher_comparaison() {
    declare -A c_sans_abo=("${!1}")
    declare -A couts_abo=("${!2}")
    local n_jours_travail=$3
    local n_m=$((n_jours_travail ? n_jours_travail * 2 : 30 * 2)) # Calculer n_m ici

    echo -e "\nComparaison des coûts mensuels :"
    echo "Nombre de jours de travail par mois : ${n_jours_travail:-Tous les jours}"
    printf "%-15s %15s %15s %15s %15s %15s\n" "Type" "Prix abo (¥)" "Coût trajet (¥)" "Économie (¥)" "Seuil (trajets)" "Jours travaillés"
    echo "-----------------------------------------------------------------------------------------------------"

    for nom in "${!couts_abo[@]}"; do
        IFS=";" read -r a1 a3 a6 <<<"${couts_abo[$nom]}"
        if [[ -z "${c_sans_abo[$nom]}" || -z "$a1" || -z "$a3" || -z "$a6" ]]; then
            echo "Erreur : Données manquantes pour l'abonnement $nom."
            continue
        fi
        pt=$(echo "scale=2; ${c_sans_abo[$nom]} / $n_m" | bc)
        echo "DEBUG: $nom - Coût trajet unique : $pt"
        echo "Abonnement : $nom (Coût trajet unique : $pt ¥)"
        # ...existing code for printing details...
    done
}

# Main
declare -A abonnements
read -p "Nombre de jours de travail par mois (laisser vide pour tous les jours) : " n_jours_travail
n_jours_travail=${n_jours_travail//[^0-9]/} # Convert to integer or empty if invalid

while :; do
    read -p "Nom de l'abonnement (laisser vide pour terminer) : " nom
    [[ -z "$nom" ]] && break

    read -p "Prix d'un trajet (¥) : " pt
    if ! [[ "$pt" =~ ^[0-9]+$ ]]; then
        echo "Erreur : Veuillez entrer une valeur numérique valide pour le prix d'un trajet."
        continue
    fi

    read -p "Prix de l'abonnement $nom 1 mois (¥) : " a1
    if ! [[ "$a1" =~ ^[0-9]+$ ]]; then
        echo "Erreur : Veuillez entrer une valeur numérique valide pour le prix de l'abonnement 1 mois."
        continue
    fi

    read -p "Prix de l'abonnement $nom 3 mois (¥) : " a3
    if ! [[ "$a3" =~ ^[0-9]+$ ]]; then
        echo "Erreur : Veuillez entrer une valeur numérique valide pour le prix de l'abonnement 3 mois."
        continue
    fi

    read -p "Prix de l'abonnement $nom 6 mois (¥) : " a6
    if ! [[ "$a6" =~ ^[0-9]+$ ]]; then
        echo "Erreur : Veuillez entrer une valeur numérique valide pour le prix de l'abonnement 6 mois."
        continue
    fi

    abonnements[$nom]="$pt;$a1;$a3;$a6"
done

results=$(calcul_economies 2 "$n_jours_travail" abonnements)
eval "$results"
afficher_comparaison c_sans_abo couts_abo "$n_jours_travail"

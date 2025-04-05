#!/bin/bash

calcul_economies() {
    local pt=$1
    local n_j=$2
    local n_jours_travel=$3
    local a1=$4
    local a3=$5
    local a6=$6

    local S_m=4.33
    local n_m

    if [[ -z $n_jours_travel || $n_jours_travel -le 0 ]]; then
        echo "Erreur : Nombre de jours de travail invalide." >&2
        exit 1
    fi

    if [[ -n $n_jours_travel ]]; then
        n_m=$(echo "$n_j * $n_jours_travel" | bc)
    else
        n_m=$(echo "$n_j * 30" | bc)
    fi

    local c_sans_abo=$(echo "$pt * $n_m" | bc)
    declare -A couts_abo

    [[ -n $a1 ]] && couts_abo["1 mois"]=$a1
    [[ -n $a3 ]] && couts_abo["3 mois"]=$a3
    [[ -n $a6 ]] && couts_abo["6 mois"]=$a6

    echo "$c_sans_abo"
    for key in "${!couts_abo[@]}"; do
        echo "$key:${couts_abo[$key]}"
    done
}

afficher_comparaison() {
    local c_sans_abo=$1
    shift
    declare -A couts_abo
    while [[ $# -gt 0 ]]; do
        IFS=":" read -r key value <<< "$1"
        couts_abo["$key"]=$value
        shift
    done
    local n_jours_travel=$2
    local trajet_label=$3
    local pt=$4

    if [[ -z $c_sans_abo || $(echo "$c_sans_abo <= 0" | bc) -eq 1 ]]; then
        echo "Erreur : Coût sans abonnement invalide." >&2
        exit 1
    fi

    echo -e "\nComparaison des coûts mensuels pour le $trajet_label :"
    echo "-----------------------------------------------------------------------------------------------------"
    printf "| %-15s | %-15s | %-15s | %-15s | %-15s | %-15s |\n" "Type" "Prix abo (¥)" "Coût trajet (¥)" "Économie (¥)" "Seuil (trajets)" "Jours travaillés"
    echo "-----------------------------------------------------------------------------------------------------"
    printf "| %-15s | %-15s | %-15.2f | %-15s | %-15s | %-15s |\n" "Sans abo" "-" "$c_sans_abo" "-" "-" "${n_jours_travel:-Tous les jours}"

    for duree in "${!couts_abo[@]}"; do
        local cout=${couts_abo[$duree]}
        local total_jours
        case $duree in
            "1 mois") total_jours=$n_jours_travel ;;
            "3 mois") total_jours=$(echo "$n_jours_travel * 3" | bc) ;;
            "6 mois") total_jours=$(echo "$n_jours_travel * 6" | bc) ;;
            *) total_jours="-" ;;
        esac

        local economie=$(echo "$c_sans_abo - ($cout / (${duree:0:1}))" | bc)
        local cout_par_trajet=$(echo "$cout / ($n_jours_travel * 2 * (${duree:0:1}))" | bc)
        local seuil=$(echo "$cout / ($pt * 2)" | bc)

        printf "| %-15s | %-15.2f | %-15.2f | %-15.2f | %-15.2f | %-15s |\n" "$duree" "$cout" "$cout_par_trajet" "$economie" "$seuil" "${total_jours:-Tous les jours}"
    done
    echo "-----------------------------------------------------------------------------------------------------"
}

main() {
    echo -n "Nombre de jours de travail par mois (laisser vide pour tous les jours) : "
    read n_jours_travel

    echo -e "\n=== Trajet 1 ==="
    echo -n "Prix d'un trajet (¥) : "
    read pt1
    echo -n "Prix de l'abonnement 1 mois (¥) : "
    read a1_1
    echo -n "Prix de l'abonnement 3 mois (¥) : "
    read a3_1
    echo -n "Prix de l'abonnement 6 mois (¥) : "
    read a6_1

    if [[ -z $pt1 || -z $a1_1 || -z $a3_1 || -z $a6_1 || $(echo "$pt1 <= 0" | bc) -eq 1 ]]; then
        echo "Erreur : Valeurs invalides pour le Trajet 1." >&2
        exit 1
    fi

    echo -e "\n=== Trajet 2 ==="
    echo -n "Prix d'un trajet (¥) : "
    read pt2
    echo -n "Prix de l'abonnement 1 mois (¥) : "
    read a1_2
    echo -n "Prix de l'abonnement 3 mois (¥) : "
    read a3_2
    echo -n "Prix de l'abonnement 6 mois (¥) : "
    read a6_2

    if [[ -z $pt2 || -z $a1_2 || -z $a3_2 || -z $a6_2 || $(echo "$pt2 <= 0" | bc) -eq 1 ]]; then
        echo "Erreur : Valeurs invalides pour le Trajet 2." >&2
        exit 1
    fi

    c_sans_abo1=$(calcul_economies "$pt1" 2 "$n_jours_travel" "$a1_1" "$a3_1" "$a6_1")
    afficher_comparaison "$c_sans_abo1" "1 mois:$a1_1" "3 mois:$a3_1" "6 mois:$a6_1" "$n_jours_travel" "Trajet 1" "$pt1"

    c_sans_abo2=$(calcul_economies "$pt2" 2 "$n_jours_travel" "$a1_2" "$a3_2" "$a6_2")
    afficher_comparaison "$c_sans_abo2" "1 mois:$a1_2" "3 mois:$a3_2" "6 mois:$a6_2" "$n_jours_travel" "Trajet 2" "$pt2"

    if [[ -n $n_jours_travel ]]; then
        echo -n "Voulez-vous Calculer le trajet composé ? (oui/non) : "
        read afficher_special
        if [[ $afficher_special == "oui" && -z $n_jours_travel ]]; then
            echo "Erreur : Nombre de jours de travail requis pour le trajet composé." >&2
            exit 1
        fi
        if [[ $afficher_special == "oui" ]]; then
            c_sans_abo3=$(echo "($pt1 + $pt2) * $n_jours_travel" | bc)
            echo -e "\nComparaison du trajet Composé"
            echo "Coût total sans abonnement pour le trajet composé : $c_sans_abo3 ¥"
        fi
    fi
}

main

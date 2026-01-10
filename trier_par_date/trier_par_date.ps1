<#
.SYNOPSIS
    Trie les fichiers image et vidéo par date.
.DESCRIPTION
    Ce script trie les fichiers image (via métadonnées EXIF) et vidéo (via timestamp dans le nom)
    dans des dossiers organisés par date.
.PARAMETER targetDir
    Le chemin du dossier contenant les fichiers à trier.
.PARAMETER mode
    Le mode de tri : "Image", "Video", ou "Both" (par défaut : "Both").
.PARAMETER exifToolName
    Le nom de l'exécutable ExifTool (par défaut : "exiftool.exe"). Requis uniquement pour le mode Image.
.PARAMETER imageExtensions
    Liste des extensions de fichiers image à traiter (par défaut : CR2, CR3, JPG, JPEG, PNG, TIF, TIFF).
.PARAMETER videoExtensions
    Liste des extensions de fichiers vidéo à traiter (par défaut : MP4, AVI, MKV, MOV, WMV).
.PARAMETER destinationDir
    Le chemin du dossier de destination (par défaut : le dossier source).
.PARAMETER IncludeSubfolders
    Inclure les sous-dossiers lors de la recherche de fichiers (par défaut : non).
.EXAMPLE
    .\trier_par_date.ps1 -targetDir "C:\Mes Fichiers"
    Le script demandera interactivement le mode, les sous-dossiers et la destination.
.EXAMPLE
    .\trier_par_date.ps1 -targetDir "C:\Mes Photos" -mode "Image" -IncludeSubfolders
    Trie uniquement les images avec recherche dans les sous-dossiers.
.EXAMPLE
    .\trier_par_date.ps1 -targetDir "C:\Mes Videos" -mode "Video"
    Trie uniquement les vidéos, demande interactivement les autres paramètres.
.EXAMPLE
    .\trier_par_date.ps1 -targetDir "C:\Source" -destinationDir "D:\Triés" -mode "Both" -IncludeSubfolders
    Spécifie tous les paramètres en ligne de commande (pas de mode interactif).
.NOTES
    Version : 3.0.0
    Auteur  : Audric_San
    Date    : 2026/01/10

    Changelog :
    - v3.0.0 : Ajout d'un fichier récapitulatif automatique en fin de traitement
               Création du fichier Recap_Tri_YYYYMMDD_HHMMSS.txt
               Enregistrement de chaque déplacement (source → destination)
               Statistiques complètes et détails de tous les fichiers traités
    - v2.9.0 : Ajout du support pour les dates avec année sur 2 chiffres (YYMMDD)
               Conversion automatique : YY >= 50 → 19YY, YY < 50 → 20YY
               Support des formats comme 250921_031329_sh.mp4 → 2025_09_21
    - v2.8.0 : CHANGEMENT MAJEUR - Les doublons sont maintenant déplacés dans un sous-dossier "Doublons"
               au lieu d'être renommés avec un suffixe
               Création automatique du sous-dossier "Doublons" dans chaque dossier de date
               Suppression de la fonction Get-UniqueFileName
    - v2.7.1 : Amélioration du Pattern 2 pour détecter YYYYMMDD au début du nom
               Support des fichiers commençant directement par une date (ex: 20251201_131817_95.jpg)
    - v2.7.0 : Refonte complète du système de détection de date dans les noms de fichiers
               Pattern universel qui détecte YYYY-MM-DD ou YYYYMMDD peu importe le préfixe
               Validation des dates pour éviter les faux positifs (années entre 1990-2099)
               Supporte tous les formats : Screenshot, IMG, VID, photo, etc.
    - v2.6.0 : Ajout du support pour les screenshots au format Screenshot_YYYY-MM-DD
               Détection des formats Screenshot avec tirets ou underscores comme séparateurs
    - v2.5.1 : Correction du regex pour supporter les formats avec tirets (IMG-20250923-WA0010)
               Le regex accepte maintenant _ et - comme séparateurs
    - v2.5.0 : Correction du bug de détection des fichiers sans sous-dossiers
               Gestion des doublons avec renommage automatique (suffixe _1, _2, etc.)
               Création d'un dossier "Date_Introuvable" pour fichiers sans date détectable
    - v2.4.0 : Amélioration du fallback : active aussi la détection par nom en cas d'erreur EXIF
               Gestion silencieuse des erreurs EXIF avec fallback automatique
               Messages d'erreur améliorés indiquant clairement les méthodes testées
    - v2.3.0 : Ajout du mode interactif pour demander les paramètres non spécifiés (mode, destinationDir, IncludeSubfolders)
    - v2.2.0 : Ajout du paramètre -IncludeSubfolders pour contrôler la recherche dans les sous-dossiers
    - v2.1.0 : Ajout du fallback pour extraire la date depuis le nom du fichier si EXIF non disponible
               Support des formats : VID_YYYYMMDD, IMG_YYYYMMDD, et timestamps Unix
    - v2.0.0 : Fusion des scripts image et vidéo en un script unifié
#>

# Définition des paramètres du script
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$targetDir,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Image", "Video", "Both")]
    [string]$mode,

    [string]$exifToolName = "exiftool.exe",

    [Parameter(Mandatory = $false)]
    [string[]]$imageExtensions = @('CR2', 'CR3', 'JPG', 'JPEG', 'PNG', 'TIF', 'TIFF', 'dng', 'webp', 'gif'),

    [Parameter(Mandatory = $false)]
    [string[]]$videoExtensions = @('MP4', 'AVI', 'MKV', 'MOV', 'WMV', 'gif'),

    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$destinationDir,

    [Parameter(Mandatory = $false)]
    [switch]$IncludeSubfolders
)

# Demander les paramètres manquants à l'utilisateur de manière interactive
# Si le script est exécuté sans les paramètres optionnels, les demander interactivement

# Demander le mode si non spécifié
if (-not $mode) {
    Write-Host "`n=== Configuration du mode de tri ===" -ForegroundColor Cyan
    Write-Host "1. Image  - Trier uniquement les fichiers image (avec EXIF)"
    Write-Host "2. Video  - Trier uniquement les fichiers vidéo"
    Write-Host "3. Both   - Trier les images et les vidéos (par défaut)"

    do {
        $modeChoice = Read-Host "`nChoisissez le mode (1/2/3) [3]"
        if ([string]::IsNullOrWhiteSpace($modeChoice)) {
            $modeChoice = "3"
        }
    } while ($modeChoice -notin @("1", "2", "3"))

    $mode = switch ($modeChoice) {
        "1" { "Image" }
        "2" { "Video" }
        "3" { "Both" }
    }
    Write-Host "Mode sélectionné : $mode" -ForegroundColor Green
}

# Demander si l'utilisateur veut inclure les sous-dossiers
if (-not $PSBoundParameters.ContainsKey('IncludeSubfolders')) {
    Write-Host "`n=== Recherche dans les sous-dossiers ===" -ForegroundColor Cyan
    $includeChoice = Read-Host "Voulez-vous inclure les sous-dossiers ? (O/N) [N]"
    if ($includeChoice -eq "O" -or $includeChoice -eq "o" -or $includeChoice -eq "Oui" -or $includeChoice -eq "oui") {
        $IncludeSubfolders = $true
    }
    Write-Host "Sous-dossiers : $(if ($IncludeSubfolders) { 'Oui' } else { 'Non' })" -ForegroundColor Green
}

# Demander le dossier de destination si non spécifié
if (-not $destinationDir) {
    Write-Host "`n=== Dossier de destination ===" -ForegroundColor Cyan
    Write-Host "Dossier source : $targetDir"
    $destChoice = Read-Host "Voulez-vous spécifier un dossier de destination différent ? (O/N) [N]"

    if ($destChoice -eq "O" -or $destChoice -eq "o" -or $destChoice -eq "Oui" -or $destChoice -eq "oui") {
        do {
            $destinationDir = Read-Host "Entrez le chemin du dossier de destination"
            if ([string]::IsNullOrWhiteSpace($destinationDir)) {
                Write-Host "Le chemin ne peut pas être vide." -ForegroundColor Red
            } elseif (-not (Test-Path $destinationDir -PathType 'Container')) {
                Write-Host "Le dossier n'existe pas. Voulez-vous le créer ? (O/N)" -ForegroundColor Yellow
                $createChoice = Read-Host
                if ($createChoice -eq "O" -or $createChoice -eq "o") {
                    try {
                        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
                        Write-Host "Dossier créé avec succès." -ForegroundColor Green
                        break
                    } catch {
                        Write-Host "Erreur lors de la création du dossier : $_" -ForegroundColor Red
                        $destinationDir = $null
                    }
                } else {
                    $destinationDir = $null
                }
            }
        } while (-not $destinationDir -or -not (Test-Path $destinationDir -PathType 'Container'))

        Write-Host "Dossier de destination : $destinationDir" -ForegroundColor Green
    } else {
        Write-Host "Les fichiers seront triés dans le dossier source." -ForegroundColor Green
    }
}

Write-Host ""

# Extraction de la version depuis les notes
$scriptContent = Get-Content $MyInvocation.MyCommand.Path -Raw
$versionMatch = [regex]::Match($scriptContent, '(?<=Version\s*:\s*)([\d\.]+)')
if ($versionMatch.Success) {
    $scriptVersion = $versionMatch.Value
} else {
    $scriptVersion = "Version inconnue"
}

# Affichage de la version du script
Write-Host "Exécution du script de tri de fichiers par date (version $scriptVersion)"
Write-Host "Mode de tri : $mode"
Write-Host "Recherche dans les sous-dossiers : $(if ($IncludeSubfolders) { 'Oui' } else { 'Non' })"

# Vérification de la présence d'ExifTool si le mode Image est activé
if ($mode -eq "Image" -or $mode -eq "Both") {
    $exifToolPath = Get-Command $exifToolName -ErrorAction SilentlyContinue

    if (-not $exifToolPath) {
        Write-Error "ExifTool n'a pas été trouvé dans le PATH. Veuillez l'installer et l'ajouter au PATH de Windows."
        exit 1
    }
}

# Variable globale pour stocker le journal des déplacements
$script:moveLog = [System.Collections.ArrayList]::new()

# Fonction pour extraire la date de capture avec ExifTool (pour les images)
function Get-DateTaken {
    param ([string]$filePath)

    try {
        # Exécution d'ExifTool pour obtenir la date de capture
        $exifOutput = & $exifToolName -DateTimeOriginal -T -d "%Y:%m:%d %H:%M:%S" $filePath 2>$null
        if ($exifOutput -and $exifOutput -ne "-") {
            try {
                # Conversion de la chaîne de date en objet DateTime
                return [datetime]::ParseExact($exifOutput, "yyyy:MM:dd HH:mm:ss", $null)
            }
            catch {
                # Erreur de parsing, retourner null pour utiliser le fallback
                return $null
            }
        }
    }
    catch {
        # Erreur lors de l'exécution d'ExifTool, retourner null pour utiliser le fallback
        return $null
    }
    return $null
}

# Fonction pour extraire la date depuis le nom du fichier
function Get-DateFromFilename {
    param ([string]$fileName)

    # Pattern 1: Date au format YYYY-MM-DD ou YYYY_MM_DD (peu importe le préfixe)
    # Exemple: Screenshot_2025-05-22, IMG-2025-05-22, photo_2025_05_22, etc.
    if ($fileName -match '(\d{4})[-_](\d{2})[-_](\d{2})') {
        try {
            $year = $matches[1]
            $month = $matches[2]
            $day = $matches[3]
            # Vérifier que c'est une date valide
            $date = [datetime]::ParseExact("$year$month$day", "yyyyMMdd", $null)
            # Vérifier que l'année est raisonnable (entre 1990 et 2099)
            if ($date.Year -ge 1990 -and $date.Year -le 2099) {
                return $date
            }
        }
        catch {
            # Pas une date valide, continuer avec les autres patterns
        }
    }

    # Pattern 2: Date au format YYYYMMDD collé au début ou après un séparateur
    # Exemple: 20251201_131817.jpg, backup_20251201.zip, IMG20250923.jpg
    if ($fileName -match '(?:^|[^0-9])(\d{4})(\d{2})(\d{2})(?:[^0-9]|$)') {
        try {
            $year = $matches[1]
            $month = $matches[2]
            $day = $matches[3]
            # Vérifier que c'est une date valide
            $date = [datetime]::ParseExact("$year$month$day", "yyyyMMdd", $null)
            # Vérifier que l'année est raisonnable (entre 1990 et 2099)
            if ($date.Year -ge 1990 -and $date.Year -le 2099) {
                return $date
            }
        }
        catch {
            # Pas une date valide, continuer avec les autres patterns
        }
    }

    # Pattern 3: Date au format YYMMDD (année sur 2 chiffres) au début ou après un séparateur
    # Exemple: 250921_031329_sh.mp4 → 2025-09-21
    if ($fileName -match '(?:^|[^0-9])(\d{2})(\d{2})(\d{2})(?:[^0-9]|$)') {
        try {
            $yy = [int]$matches[1]
            $month = $matches[2]
            $day = $matches[3]

            # Convertir l'année sur 2 chiffres en 4 chiffres
            # Si >= 50 : 19xx, sinon 20xx (gère les dates de 1950 à 2049)
            $year = if ($yy -ge 50) { 1900 + $yy } else { 2000 + $yy }

            # Vérifier que c'est une date valide
            $date = [datetime]::ParseExact("$year$month$day", "yyyyMMdd", $null)
            # Vérifier que l'année est raisonnable (entre 1990 et 2099)
            if ($date.Year -ge 1990 -and $date.Year -le 2099) {
                return $date
            }
        }
        catch {
            # Pas une date valide, continuer avec les autres patterns
        }
    }

    # Pattern 4: Timestamp Unix (10 chiffres ou plus)
    # Utilisé en dernier recours car peut créer des faux positifs
    if ($fileName -match '(\d{10,})') {
        try {
            # Prendre les 10 premiers chiffres (secondes depuis epoch)
            $timestampStr = $matches[1].Substring(0, 10)
            $timestamp = [long]$timestampStr
            $date = (Get-Date -Date "1970-01-01 00:00:00Z").AddSeconds($timestamp)
            # Vérifier que le timestamp correspond à une date raisonnable (entre 1990 et 2099)
            if ($date.Year -ge 1990 -and $date.Year -le 2099) {
                return $date
            }
        }
        catch {
            # Pas un timestamp valide
        }
    }

    return $null
}

# Fonction pour trier les fichiers par date
function Sort-FilesByDate {
    param (
        [string[]]$fileExtensions,
        [string]$fileType
    )

    # Récupération de tous les fichiers avec les extensions spécifiées
    if ($IncludeSubfolders) {
        $files = Get-ChildItem -Path $targetDir -Include ($fileExtensions | ForEach-Object { "*.$_" }) -File -Recurse
    } else {
        # Ajout de \* au chemin pour que -Include fonctionne correctement sans -Recurse
        $files = Get-ChildItem -Path (Join-Path $targetDir "*") -Include ($fileExtensions | ForEach-Object { "*.$_" }) -File
    }
    $totalFiles = $files.Count

    if ($totalFiles -eq 0) {
        Write-Host "Aucun fichier $fileType trouvé."
        return
    }

    $processedFiles = 0
    $startTime = Get-Date

    # Création d'un tableau de hachage pour stocker les dossiers de destination
    $destDirs = @{}

    Write-Host "Traitement de $totalFiles fichier(s) $fileType..."

    foreach ($file in $files) {
        # Obtention de la date selon le type de fichier
        $dateSource = $null

        if ($fileType -eq "image") {
            # Essayer d'abord les données EXIF
            $dateTaken = Get-DateTaken -filePath $file.FullName

            # Si pas de données EXIF ou erreur EXIF, essayer d'extraire la date du nom du fichier
            if (-not $dateTaken) {
                $dateTaken = Get-DateFromFilename -fileName $file.BaseName
                if ($dateTaken) {
                    $dateSource = "nom de fichier"
                }
            } else {
                $dateSource = "EXIF"
            }
        } else {
            # Pour les vidéos, extraire directement du nom du fichier
            $dateTaken = Get-DateFromFilename -fileName $file.BaseName
            if ($dateTaken) {
                $dateSource = "nom de fichier"
            }
        }

        if ($dateTaken) {
            # Création du nom du dossier de destination basé sur la date
            $folderName = $dateTaken.ToString('yyyy_MM_dd')

            # Utilisation du dossier de destination spécifié ou du dossier par défaut
            $baseDestDir = if ($destinationDir) { $destinationDir } else { $targetDir }

            # Vérification si le dossier de destination existe déjà dans le tableau de hachage
            if (-not $destDirs.ContainsKey($folderName)) {
                $destDir = Join-Path $baseDestDir $folderName
                # Création du dossier de destination s'il n'existe pas
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir | Out-Null
                }
                $destDirs[$folderName] = $destDir
            }
            try {
                # Vérifier si le fichier existe déjà dans le dossier de destination
                $finalDestination = Join-Path $destDirs[$folderName] $file.Name

                if (Test-Path $finalDestination) {
                    # Le fichier existe déjà, créer un sous-dossier "Doublons"
                    $doublonsFolderKey = "$folderName\Doublons"
                    if (-not $destDirs.ContainsKey($doublonsFolderKey)) {
                        $doublonsDir = Join-Path $destDirs[$folderName] "Doublons"
                        if (-not (Test-Path $doublonsDir)) {
                            New-Item -ItemType Directory -Path $doublonsDir | Out-Null
                        }
                        $destDirs[$doublonsFolderKey] = $doublonsDir
                    }
                    # Déplacer le doublon dans le sous-dossier "Doublons"
                    $finalDestination = Join-Path $destDirs[$doublonsFolderKey] $file.Name

                    # Si le fichier existe aussi dans Doublons, ajouter un suffixe
                    if (Test-Path $finalDestination) {
                        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        $extension = [System.IO.Path]::GetExtension($file.Name)
                        $counter = 1
                        do {
                            $newFileName = "${baseName}_${counter}${extension}"
                            $finalDestination = Join-Path $destDirs[$doublonsFolderKey] $newFileName
                            $counter++
                        } while (Test-Path $finalDestination)
                    }

                    Move-Item -Path $file.FullName -Destination $finalDestination -ErrorAction Stop
                    Write-Warning "Doublon détecté : $($file.Name) déplacé vers $folderName\Doublons"
                    # Enregistrement dans le journal
                    $script:moveLog.Add([PSCustomObject]@{
                        Source = $file.FullName
                        Destination = $finalDestination
                        Type = "Doublon"
                    }) | Out-Null
                } else {
                    # Pas de doublon, déplacement normal
                    Move-Item -Path $file.FullName -Destination $finalDestination -ErrorAction Stop
                    # Enregistrement dans le journal
                    $script:moveLog.Add([PSCustomObject]@{
                        Source = $file.FullName
                        Destination = $finalDestination
                        Type = "Normal"
                    }) | Out-Null
                }

                $processedFiles++

                # Calcul et affichage de la progression
                $elapsedTime = (Get-Date) - $startTime
                $averageTimePerFile = $elapsedTime.TotalSeconds / $processedFiles
                $estimatedRemainingTime = [TimeSpan]::FromSeconds($averageTimePerFile * ($totalFiles - $processedFiles))

                $status = "Progression : {0:N2}% - Fichiers traités : {1}/{2} - Temps restant estimé : {3:hh\:mm\:ss}" -f
                    (($processedFiles / $totalFiles) * 100),
                $processedFiles,
                $totalFiles,
                $estimatedRemainingTime
                Write-Progress -Activity "Tri des fichiers $fileType" -Status $status -PercentComplete (($processedFiles / $totalFiles) * 100)
            }
            catch {
                Write-Warning "Impossible de déplacer $($file.FullName) : $_"
            }
        }
        else {
            # Si aucune date n'a pu être récupérée, déplacer vers un dossier "Date_Introuvable"
            $folderName = "Date_Introuvable"

            # Utilisation du dossier de destination spécifié ou du dossier par défaut
            $baseDestDir = if ($destinationDir) { $destinationDir } else { $targetDir }

            # Vérification si le dossier de destination existe déjà dans le tableau de hachage
            if (-not $destDirs.ContainsKey($folderName)) {
                $destDir = Join-Path $baseDestDir $folderName
                # Création du dossier de destination s'il n'existe pas
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir | Out-Null
                }
                $destDirs[$folderName] = $destDir
            }

            try {
                # Vérifier si le fichier existe déjà dans le dossier "Date_Introuvable"
                $finalDestination = Join-Path $destDirs[$folderName] $file.Name

                if (Test-Path $finalDestination) {
                    # Le fichier existe déjà, créer un sous-dossier "Doublons"
                    $doublonsFolderKey = "$folderName\Doublons"
                    if (-not $destDirs.ContainsKey($doublonsFolderKey)) {
                        $doublonsDir = Join-Path $destDirs[$folderName] "Doublons"
                        if (-not (Test-Path $doublonsDir)) {
                            New-Item -ItemType Directory -Path $doublonsDir | Out-Null
                        }
                        $destDirs[$doublonsFolderKey] = $doublonsDir
                    }
                    # Déplacer le doublon dans le sous-dossier "Doublons"
                    $finalDestination = Join-Path $destDirs[$doublonsFolderKey] $file.Name

                    # Si le fichier existe aussi dans Doublons, ajouter un suffixe
                    if (Test-Path $finalDestination) {
                        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        $extension = [System.IO.Path]::GetExtension($file.Name)
                        $counter = 1
                        do {
                            $newFileName = "${baseName}_${counter}${extension}"
                            $finalDestination = Join-Path $destDirs[$doublonsFolderKey] $newFileName
                            $counter++
                        } while (Test-Path $finalDestination)
                    }

                    Move-Item -Path $file.FullName -Destination $finalDestination -ErrorAction Stop
                    Write-Warning "Doublon détecté dans Date_Introuvable : $($file.Name) déplacé vers Doublons"
                    # Enregistrement dans le journal
                    $script:moveLog.Add([PSCustomObject]@{
                        Source = $file.FullName
                        Destination = $finalDestination
                        Type = "Date_Introuvable (Doublon)"
                    }) | Out-Null
                } else {
                    # Pas de doublon, déplacement normal
                    Move-Item -Path $file.FullName -Destination $finalDestination -ErrorAction Stop

                    if ($fileType -eq "image") {
                        Write-Warning "Date introuvable pour $($file.Name) (ni EXIF ni nom de fichier) - Déplacé vers $folderName"
                    } else {
                        Write-Warning "Date introuvable dans le nom du fichier $($file.Name) - Déplacé vers $folderName"
                    }
                    # Enregistrement dans le journal
                    $script:moveLog.Add([PSCustomObject]@{
                        Source = $file.FullName
                        Destination = $finalDestination
                        Type = "Date_Introuvable"
                    }) | Out-Null
                }

                $processedFiles++
            }
            catch {
                Write-Warning "Impossible de déplacer $($file.FullName) vers $folderName : $_"
            }
        }
    }

    Write-Host "`nTous les fichiers $fileType ont été traités. $processedFiles sur $totalFiles ont été triés avec succès."
}

# Exécution du tri selon le mode choisi
if ($mode -eq "Image" -or $mode -eq "Both") {
    Write-Host "`n=== Traitement des fichiers image ==="
    Sort-FilesByDate -fileExtensions $imageExtensions -fileType "image"
}

if ($mode -eq "Video" -or $mode -eq "Both") {
    Write-Host "`n=== Traitement des fichiers vidéo ==="
    Sort-FilesByDate -fileExtensions $videoExtensions -fileType "vidéo"
}

Write-Host "`nOpération terminée."

# Création du fichier récapitulatif
if ($script:moveLog.Count -gt 0) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $baseDestDir = if ($destinationDir) { $destinationDir } else { $targetDir }
    $logFilePath = Join-Path $baseDestDir "Recap_Tri_$timestamp.txt"

    try {
        $logContent = @()
        $logContent += "=" * 80
        $logContent += "RÉCAPITULATIF DU TRI DES FICHIERS"
        $logContent += "Date : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
        $logContent += "Mode : $mode"
        $logContent += "Dossier source : $targetDir"
        if ($destinationDir) {
            $logContent += "Dossier destination : $destinationDir"
        }
        $logContent += "Sous-dossiers inclus : $(if ($IncludeSubfolders) { 'Oui' } else { 'Non' })"
        $logContent += "=" * 80
        $logContent += ""
        $logContent += "TOTAL DE FICHIERS DÉPLACÉS : $($script:moveLog.Count)"
        $logContent += ""
        $logContent += "DÉTAIL DES DÉPLACEMENTS :"
        $logContent += "-" * 80
        $logContent += ""

        foreach ($entry in $script:moveLog) {
            $fileName = [System.IO.Path]::GetFileName($entry.Source)
            $relativeDest = $entry.Destination.Replace($baseDestDir, "").TrimStart('\')

            $logContent += "Fichier    : $fileName"
            $logContent += "Source     : $($entry.Source)"
            $logContent += "Destination: $relativeDest"
            $logContent += "Type       : $($entry.Type)"
            $logContent += ""
        }

        $logContent += "=" * 80
        $logContent += "FIN DU RÉCAPITULATIF"
        $logContent += "=" * 80

        # Écriture du fichier
        $logContent | Out-File -FilePath $logFilePath -Encoding UTF8

        Write-Host "`nFichier récapitulatif créé : $logFilePath" -ForegroundColor Green
    }
    catch {
        Write-Warning "Impossible de créer le fichier récapitulatif : $_"
    }
}

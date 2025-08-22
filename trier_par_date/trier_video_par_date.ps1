<#
.SYNOPSIS
    Trie les fichiers vidéo par date basée sur le timestamp dans le nom du fichier.
.DESCRIPTION
    Ce script trie les fichiers vidéo dans des dossiers organisés par date en se basant sur le timestamp présent dans le nom du fichier.
.PARAMETER targetDir
    Le chemin du dossier contenant les fichiers à trier.
.PARAMETER fileExtensions
    Liste des extensions de fichiers à traiter (par défaut : MP4, AVI, MKV, MOV, WMV).
.PARAMETER destinationDir
    Le chemin du dossier de destination (par défaut : le dossier source).
.EXAMPLE
    .\trier_video_par_date.ps1 -targetDir "C:\Mes Videos"
.EXAMPLE
    .\trier_video_par_date.ps1 -targetDir "C:\Mes Videos" -fileExtensions "MP4", "MKV"
.NOTES
    Version : 1.0.0
    Auteur  : Audric_San
    Date    : 2024/08/18
#>

# Définition des paramètres du script
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$targetDir,

    [Parameter(Mandatory = $false)]
    [string[]]$fileExtensions = @('MP4', 'AVI', 'MKV', 'MOV', 'WMV'),

    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$destinationDir
)

# Extraction de la version depuis les notes
$scriptContent = Get-Content $MyInvocation.MyCommand.Path -Raw
$versionMatch = [regex]::Match($scriptContent, '(?<=Version\s*:\s*)([\d\.]+)')
if ($versionMatch.Success) {
    $scriptVersion = $versionMatch.Value
}
else {
    $scriptVersion = "Version inconnue"
}

# Affichage de la version du script
Write-Host "Exécution du script de tri de fichiers vidéo par date (version $scriptVersion)"

# Fonction pour extraire la date depuis le timestamp dans le nom du fichier
function Get-DateFromFilename {
    param ([string]$fileName)

    # Recherche d'un motif timestamp suivi éventuellement de _1
    if ($fileName -match '(\d{10})_?\d?') {
        try {
            # Conversion du timestamp Unix en DateTime
            $timestamp = [long]$matches[1]
            return (Get-Date -Date "1970-01-01 00:00:00Z").AddSeconds($timestamp)
        }
        catch {
            Write-Warning "Erreur lors de la conversion du timestamp pour $fileName"
            return $null
        }
    }
    return $null
}

# Fonction pour trier les fichiers par date
function Sort-FilesByDate {
    param (
        [string[]]$fileExtensions
    )

    # Récupération de tous les fichiers avec les extensions spécifiées
    $files = Get-ChildItem -Path $targetDir -Include ($fileExtensions | ForEach-Object { "*.$_" }) -File -Recurse
    $totalFiles = $files.Count
    $processedFiles = 0
    $startTime = Get-Date

    # Création d'un tableau de hachage pour stocker les dossiers de destination
    $destDirs = @{}

    foreach ($file in $files) {
        # Obtention de la date depuis le nom du fichier
        $dateTaken = Get-DateFromFilename -fileName $file.BaseName
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
                # Déplacement du fichier vers le dossier de destination
                Move-Item -Path $file.FullName -Destination $destDirs[$folderName] -ErrorAction Stop
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
                Write-Progress -Activity "Tri des fichiers vidéo" -Status $status -PercentComplete (($processedFiles / $totalFiles) * 100)
            }
            catch {
                Write-Warning "Impossible de déplacer $($file.FullName) : $_"
            }
        }
        else {
            Write-Warning "Impossible de récupérer la date depuis le nom du fichier $($file.Name)"
        }
    }

    # Ajout d'une nouvelle ligne à la fin du traitement
    Write-Host "`n`nTous les fichiers ont été traités. $processedFiles sur $totalFiles ont été triés avec succès."
}

# Appel de la fonction avec toutes les extensions
Sort-FilesByDate -fileExtensions $fileExtensions

Write-Host "`nOpération terminée."
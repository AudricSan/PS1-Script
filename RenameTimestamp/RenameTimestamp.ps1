<#
.SYNOPSIS
    Renomme les fichiers en fonction de leur horodatage dans leur nom.
.DESCRIPTION
    Ce script vérifie si le nom de fichier contient un timestamp Unix valide (en secondes ou millisecondes) et renomme le fichier en fonction de cet horodatage.
.PARAMETER targetDir
    Le répertoire contenant les fichiers à renommer.
.PARAMETER destinationDir
    Le répertoire où les fichiers renommés seront enregistrés.
.PARAMETER fileExtensions
    Les extensions de fichiers à traiter (ex. : .mp4, .ts).
.PARAMETER DryRun
    Permet de simuler l'exécution sans effectuer de modifications réelles.
.EXAMPLE
    .\RenameFiles.ps1 -targetDir "C:\Fichiers" -destinationDir "C:\Renommés" -fileExtensions ".mp4", ".ts" -DryRun
.NOTES
    Version : 1.3.0
    Auteur  : Audric_San
    Date    : 2025/01/04
#>

param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$targetDir,

    [Parameter(Mandatory = $true)]
    [string]$destinationDir,

    [Parameter(Mandatory = $false)]
    [string[]]$fileExtensions = @(".mp4", ".ts"),

    [switch]$DryRun
)

# Vérification et création du répertoire de destination
if (-not (Test-Path $destinationDir)) {
    Write-Host "Création du répertoire de destination : $destinationDir"
    New-Item -ItemType Directory -Path $destinationDir | Out-Null
}

# Récupération des fichiers avec les extensions spécifiées
$fileExtensionsHash = $fileExtensions.ForEach({ $_.ToLower() })
$fileList = Get-ChildItem -Path $targetDir -Recurse | Where-Object { $fileExtensionsHash -contains $_.Extension.ToLower() }

if ($fileList.Count -eq 0) {
    Write-Host "Aucun fichier trouvé avec les extensions spécifiées : $($fileExtensions -join ', ')"
    return
}

Write-Host "Nombre total de fichiers à traiter : $($fileList.Count)"

# Traitement des fichiers
foreach ($file in $fileList) {
    $fileName = $file.BaseName
    $filePath = $file.FullName
    $totalFiles = $fileList.Count
    $processedFiles = 0

    # Vérifier si le nom de fichier contient un timestamp valide (10 à 13 chiffres)
    if ($fileName -match "\b(\d{10,13})\b") {
        $timestamp = [int64]$matches[1]

        try {
            # Conversion du timestamp
            $epochTimestamp = if ($timestamp -gt 9999999999) { $timestamp / 1000 } else { $timestamp }
            $dateTimeOffset = [System.DateTimeOffset]::FromUnixTimeSeconds([int64]$epochTimestamp).ToLocalTime()
            $formattedDate = $dateTimeOffset.ToString("yyyy-MM-dd_HH-mm-ss")

            # Création du nouveau nom de fichier
            $newFileName = "$formattedDate$file"
            $newFilePath = Join-Path -Path $destinationDir -ChildPath $newFileName

            # Ajouter un suffixe si le fichier existe déjà
            $counter = 1
            while (Test-Path $newFilePath) {
                $newFileName = "$formattedDate-$counter$file"
                $newFilePath = Join-Path -Path $destinationDir -ChildPath $newFileName
                $counter++
            }

            # Renommer ou simuler le renommage
            if ($DryRun) {
                Write-Host "Dry Run : '$filePath' serait renommé en '$newFilePath'"
            } else {
                Copy-Item -Path $filePath -Destination $newFilePath
                # Suppression de l'affichage de la progression dans le terminal
                # Write-Host "Fichier '$filePath' renommé en '$newFilePath'"  # Cette ligne est commentée
            }
        } catch {
            Write-Warning "Erreur lors du traitement du fichier '$filePath' : $_"
        }
    } else {
        Write-Warning "Le fichier '$fileName' ne contient pas de timestamp valide."
    }

    # Suivi de progression
    $processedFiles++
    $status = "Progression : {0:N2}% - Fichiers traites : {1}/{2}" -f 
        (($processedFiles / $totalFiles) * 100), 
        $processedFiles, 
        $totalFiles
    Write-Progress -Activity "Traitement des fichiers" -Status $status -PercentComplete (($processedFiles / $totalFiles) * 100)
}

Write-Host "Traitement terminé."

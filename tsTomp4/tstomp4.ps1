<#
.SYNOPSIS
    Convertit les fichiers TS en MP4 en utilisant ffmpeg.
.DESCRIPTION
    Ce script parcourt les dossiers à la recherche de fichiers tsfile.list, crée une liste de concaténation
    et convertit les fichiers TS en un seul fichier MP4 par dossier.
.PARAMETER rootDir
    Le chemin du dossier racine contenant les fichiers à convertir.
.PARAMETER ffmpegName
    Le nom de l'exécutable ffmpeg (par défaut : "ffmpeg.exe").
.EXAMPLE
    .\tstomp4.ps1 -rootDir "E:\20250817"
.NOTES
    Version : 1.0.0
    Auteur  : Audric_San
    Date    : 2024/08/18
#>

# Définition des paramètres du script
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$rootDir,

    [string]$ffmpegName = "ffmpeg.exe"
)

# Extraction de la version depuis les notes
$scriptContent = Get-Content $MyInvocation.MyCommand.Path -Raw
$versionMatch = [regex]::Match($scriptContent, '(?<=Version\s*:\s*)([\d\.]+)')
if ($versionMatch.Success) {
    $scriptVersion = $versionMatch.Value
} else {
    $scriptVersion = "Version inconnue"
}

# Affichage de la version du script
Write-Host "Exécution du script de conversion TS vers MP4 (version $scriptVersion)"

# Vérification de la présence de ffmpeg dans le PATH
$ffmpegPath = Get-Command $ffmpegName -ErrorAction SilentlyContinue

if (-not $ffmpegPath) {
    Write-Error "ffmpeg n'a pas été trouvé dans le PATH. Veuillez l'installer et l'ajouter au PATH de Windows."
    exit 1
}

# Fonction principale de conversion
function Convert-TsToMp4 {
    # Récupération de tous les fichiers tsfile.list
    $tsListFiles = Get-ChildItem -Path $rootDir -Recurse -Filter "tsfile.list"
    $totalFiles = $tsListFiles.Count
    $processedFiles = 0
    $startTime = Get-Date

    foreach ($tsListFile in $tsListFiles) {
        $folder = $tsListFile.DirectoryName
        $tslist = $tsListFile.FullName
        $concatlist = Join-Path $folder "concat.list"
        $output = Join-Path $folder ($tsListFile.Directory.Name + ".mp4")

        try {
            # Création du fichier de concaténation
            Get-Content $tslist | ForEach-Object {
                $tsfile = ($_ -split ":")[0].Trim()
                "file '$folder\$tsfile'"
            } | Set-Content $concatlist -Encoding UTF8

            # Conversion avec ffmpeg
            ffmpeg -f concat -safe 0 -i $concatlist -c copy $output -y -hide_banner -loglevel error

            $processedFiles++

            # Calcul et affichage de la progression
            $elapsedTime = (Get-Date) - $startTime
            $averageTimePerFile = $elapsedTime.TotalSeconds / $processedFiles
            $estimatedRemainingTime = [TimeSpan]::FromSeconds($averageTimePerFile * ($totalFiles - $processedFiles))

            $status = "Progression : {0:N2}% - Dossiers traités : {1}/{2} - Temps restant estimé : {3:hh\:mm\:ss}" -f 
                (($processedFiles / $totalFiles) * 100),
                $processedFiles,
                $totalFiles,
                $estimatedRemainingTime

            Write-Progress -Activity "Conversion TS vers MP4" -Status $status -PercentComplete (($processedFiles / $totalFiles) * 100)

            # Nettoyage du fichier de concaténation temporaire
            Remove-Item $concatlist -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "Erreur lors du traitement de $folder : $_"
        }
    }

    Write-Host "Conversion terminée. $processedFiles sur $totalFiles dossiers ont été traités avec succès."
}

# Lancement de la conversion
Convert-TsToMp4

Write-Host "Opération terminée."

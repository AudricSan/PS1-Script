<#
.SYNOPSIS
    Trie les fichiers image par date de capture.
.DESCRIPTION
    Ce script trie les fichiers image dans des dossiers organisés par date de capture.
.PARAMETER targetDir
    Le chemin du dossier contenant les fichiers à trier.
.PARAMETER exifToolName
    Le nom de l'exécutable ExifTool (par défaut : "exiftool.exe").
.PARAMETER fileExtensions
    Liste des extensions de fichiers à traiter (par défaut : CR2, CR3, JPG, JPEG, PNG, TIF, TIFF).
.EXAMPLE
    .\trier_par_date.ps1 -targetDir "C:\Mes Photos"
.NOTES
    Version : 1.5.0
    Auteur  : Audric_San
    Date    : 29/04/2024
#>

# Définition des paramètres du script
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$targetDir,
    
    [string]$exifToolName = "exiftool.exe",

    [Parameter(Mandatory = $false)]
    [string[]]$fileExtensions = @('CR2', 'CR3', 'JPG', 'JPEG', 'PNG', 'TIF', 'TIFF')
)

# Affichage de la version du script
$scriptVersion = "1.2.0"
Write-Host "Exécution du script de tri de fichiers par date (version $scriptVersion)"

# Vérification de la présence d'ExifTool dans le PATH
$exifToolPath = Get-Command $exifToolName -ErrorAction SilentlyContinue

if (-not $exifToolPath) {
    Write-Error "ExifTool n'a pas été trouvé dans le PATH. Veuillez l'installer et l'ajouter au PATH de Windows."
    exit 1
}

# Fonction pour extraire la date de capture avec ExifTool
function Get-DateTaken {
    param ([string]$filePath)
    
    # Exécution d'ExifTool pour obtenir la date de capture
    $exifOutput = & $exifToolName -DateTimeOriginal -T -d "%Y:%m:%d %H:%M:%S" $filePath
    if ($exifOutput) {
        try {
            # Conversion de la chaîne de date en objet DateTime
            return [datetime]::ParseExact($exifOutput, "yyyy:MM:dd HH:mm:ss", $null)
        }
        catch {
            Write-Warning "Erreur lors de l'extraction de la date pour $filePath"
            return $null
        }
    }
    return $null
}

# Fonction pour trier les fichiers par date
function Sort-FilesByDate {
    param (
        [string]$fileExtension
    )
    
    # Récupération de tous les fichiers avec l'extension spécifiée
    $files = Get-ChildItem -Path $targetDir -Filter *.$fileExtension -File
    $totalFiles = $files.Count
    $processedFiles = 0
    $startTime = Get-Date
    
    foreach ($file in $files) {
        # Obtention de la date de capture pour chaque fichier
        $dateTaken = Get-DateTaken -filePath $file.FullName
        if ($dateTaken) {
            # Création du nom du dossier de destination basé sur la date
            $folderName = $dateTaken.ToString('yyyy_MM_dd')
            $destDir = Join-Path $targetDir $folderName
            
            # Création du dossier de destination s'il n'existe pas
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir | Out-Null
            }
            
            try {
                # Déplacement du fichier vers le dossier de destination
                Move-Item -Path $file.FullName -Destination $destDir -ErrorAction Stop
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
                Write-Progress -Activity "Tri des fichiers $fileExtension" -Status $status -PercentComplete (($processedFiles / $totalFiles) * 100)
            }
            catch {
                Write-Warning "Impossible de déplacer $($file.FullName) : $_"
            }
        }
        else {
            Write-Warning "Impossible de récupérer la date de capture pour $($file.FullName)"
        }
    }
    
    Write-Host "Tous les fichiers $fileExtension ont été traités. $processedFiles sur $totalFiles ont été triés avec succès."
}

# Boucle sur toutes les extensions de fichiers spécifiées
$fileExtensions | ForEach-Object {
    Sort-FilesByDate -fileExtension $_
}

Write-Host "Opération terminée."
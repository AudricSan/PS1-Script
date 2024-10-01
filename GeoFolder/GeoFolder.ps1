<#
.SYNOPSIS
    Trie les fichiers image par géolocalisation.
.DESCRIPTION
    Ce script trie les fichiers image dans des dossiers organisés par géolocalisation.
.PARAMETER targetDir
    Le chemin du dossier contenant les fichiers à trier.
.PARAMETER exifToolName
    Le nom de l'exécutable ExifTool (par défaut : "exiftool.exe").
.PARAMETER fileExtensions
    Liste des extensions de fichiers à traiter (par défaut : CR2, CR3, JPG, JPEG, PNG, TIF, TIFF).
.EXAMPLE
    .\GeoFolder.ps1 -targetDir "C:\Mes Photos"
.NOTES
    Version : 0.0.2
    Auteur  : Audric_San
    Date    : 29/04/2024
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$targetDir,
    [string]$exifToolName = "exiftool.exe",
    [string[]]$fileExtensions = @("CR2", "CR3", "JPG", "JPEG", "PNG", "TIF", "TIFF")
)

# Affichage de la version du script
$scriptVersion = "0.0.2"
Write-Host "Exécution du script de tri de fichiers par géolocalisation (version $scriptVersion)"

# Vérifier si ExifTool est installé
$exifToolPath = Get-Command $exifToolName -ErrorAction SilentlyContinue
if (-not $exifToolPath) {
    Write-Error "ExifTool n'a pas été trouvé dans le PATH. Veuillez l'installer et l'ajouter au PATH de Windows."
    exit 1
}

# Fonction pour obtenir les coordonnées GPS d'un fichier
function Get-GpsCoordinates {
    param (
        [string]$filePath
    )
    
    $latitude = $null
    $longitude = $null
    
    $exifData = & $exifToolName -c "%+.6f" -GPSLatitude -GPSLongitude -n $filePath
    
    $latitudeMatch = $exifData | Select-String -Pattern "GPS Latitude\s*:\s*([-]?\d+\.\d+)"
    $longitudeMatch = $exifData | Select-String -Pattern "GPS Longitude\s*:\s*([-]?\d+\.\d+)"
    
    if ($latitudeMatch) {
        $latitude = $latitudeMatch.Matches.Groups[1].Value
    }
    if ($longitudeMatch) {
        $longitude = $longitudeMatch.Matches.Groups[1].Value
    }
    
    if ($null -eq $latitude -or $null -eq $longitude) {
        Write-Verbose "Coordonnées GPS non trouvées pour le fichier : $filePath"
    }
    
    return @{Latitude = $latitude; Longitude = $longitude}
}

# Fonction pour obtenir le nom de la ville à partir des coordonnées GPS
function Get-CityName {
    param (
        [double]$latitude,
        [double]$longitude
    )
    
    $url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10"
    $response = Invoke-RestMethod -Uri $url -UseBasicParsing
    
    if ($response.address.city) {
        return $response.address.city
    } elseif ($response.address.town) {
        return $response.address.town
    } elseif ($response.address.village) {
        return $response.address.village
    } else {
        return "Inconnu"
    }
}

# Fonction pour trier les fichiers par géolocalisation
function Sort-FilesByGeoLocation {
    param (
        [string]$fileExtension
    )
    
    $files = Get-ChildItem -Path $targetDir -Filter *.$fileExtension -File -Recurse
    $totalFiles = $files.Count
    $processedFiles = 0
    $fichiersDeplaces = 0
    $fichiersSansGPS = 0
    $startTime = Get-Date

    foreach ($file in $files) {
        $coordinates = Get-GpsCoordinates -filePath $file.FullName
        
        if ($null -ne $coordinates.Latitude -and $null -ne $coordinates.Longitude) {
            $cityName = Get-CityName -latitude $coordinates.Latitude -longitude $coordinates.Longitude
            $destinationFolder = Join-Path -Path $targetDir -ChildPath $cityName
            
            if (-not (Test-Path $destinationFolder)) {
                New-Item -Path $destinationFolder -ItemType Directory | Out-Null
            }
            
            try {
                Move-Item -Path $file.FullName -Destination $destinationFolder -Force -ErrorAction Stop
                $fichiersDeplaces++
            }
            catch {
                Write-Warning "Impossible de déplacer $($file.FullName) : $_"
            }
        } else {
            Write-Verbose "Pas de coordonnées GPS pour le fichier : $($file.FullName)"
            $fichiersSansGPS++
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
        Write-Progress -Activity "Tri des fichiers $fileExtension" -Status $status -PercentComplete (($processedFiles / $totalFiles) * 100)
    }
    
    Write-Host "Tous les fichiers $fileExtension ont été traités."
    Write-Host "Fichiers déplacés : $fichiersDeplaces"
    Write-Host "Fichiers sans données GPS : $fichiersSansGPS"
}

# Boucle sur toutes les extensions de fichiers spécifiées
$fileExtensions | ForEach-Object {
    Sort-FilesByGeoLocation -fileExtension $_
}

Write-Host "Opération terminée."
# Demande à l'utilisateur le dossier source contenant les fichiers MKV
$sourceFolder = Read-Host "Entrez le chemin du dossier contenant les fichiers MKV"

# Vérifie si le dossier source existe
if (-Not (Test-Path $sourceFolder)) {
    Write-Host "Le dossier source n'existe pas. Vérifiez le chemin et réessayez." -ForegroundColor Red
    exit
}

# Demande à l'utilisateur le dossier de destination
$destinationFolder = Read-Host "Entrez le chemin du dossier où sauvegarder les fichiers renommés"

# Vérifie si le dossier destination existe, sinon le crée
if (-Not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
    Write-Host "Le dossier de destination a été créé : $destinationFolder" -ForegroundColor Cyan
}

# Demande à l'utilisateur le numéro de départ
$startNumber = Read-Host "Entrez le numéro de départ"
$startNumber = [int]$startNumber  # Convertit en nombre

# Configuration du format du nom
$baseName = "Dr Slump S01E"  # Nom de base des fichiers
$padding = 2  # Nombre de chiffres pour l'épisode (01, 02, ...)

# Récupérer tous les fichiers MKV (y compris les sous-dossiers)
$files = Get-ChildItem -Path $sourceFolder -Filter "*.mkv" -Recurse | Sort-Object FullName

# Vérifie s'il y a des fichiers MKV dans le dossier et ses sous-dossiers
if ($files.Count -eq 0) {
    Write-Host "Aucun fichier MKV trouvé dans le dossier ou ses sous-dossiers." -ForegroundColor Yellow
    exit
}

# Renommage et déplacement
$index = $startNumber
foreach ($file in $files) {
    $newName = "{0}{1:D$padding}.mkv" -f $baseName, $index
    $newPath = Join-Path -Path $destinationFolder -ChildPath $newName

    # Déplacer et renommer le fichier
    Move-Item -Path $file.FullName -Destination $newPath

    Write-Host "Fichier déplacé : $newName" -ForegroundColor Green
    $index++
}

Write-Host "Renommage et déplacement terminés avec succès !" -ForegroundColor Magenta

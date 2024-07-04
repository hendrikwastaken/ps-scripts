# Installiert Standardanwendungen

$apps = @("Google.Chrome", "Adobe.Acrobat.Reader.64-bit", "Mozilla.Firefox", "7zip.7zip")

foreach ($app in $apps) {
    Write-Host "Installiere $app..."
    winget install $app
    if ($?) {
        Write-Host "$app wurde erfolgreich installiert." -ForegroundColor Green
    } else {
        Write-Host "Fehler bei der Installation von $app." -ForegroundColor Red
    }
}

Write-Host "Installation abgeschlossen." -ForegroundColor Cyan
# Skript zum Einstellen der Aktion beim Zuklappen des Laptops auf "Nichts unternehmen"

try {
    # Setze die Aktion für Akkubetrieb
    powercfg /setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
    
    # Setze die Aktion für Netzbetrieb
    powercfg /setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

    # Aktiviere die Änderungen
    powercfg /S SCHEME_CURRENT

    Write-Host "Einstellungen erfolgreich geändert."
}
catch {
    Write-Host "Fehler: $($_.Exception.Message)"
}
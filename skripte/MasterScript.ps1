# Skript ruft alle anderen Skripte auf. (WIP)

# Master-Skript für Windows-Einrichtung

# Funktion zum Setzen der Ausführungsrichtlinie
function Set-ExecutionPolicyForSetup {
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "Ausführungsrichtlinie erfolgreich auf RemoteSigned gesetzt."
    }
    catch {
        Write-Error "Fehler beim Setzen der Ausführungsrichtlinie: $_"
        exit
    }
}

# Funktion zum Ausführen eines Skripts
function Invoke-SetupScript {
    param (
        [string]$ScriptPath
    )
    try {
        if (Test-Path $ScriptPath) {
            & $ScriptPath
        } else {
            Write-Warning "Skript nicht gefunden: $ScriptPath"
        }
    }
    catch {
        Write-Error "Fehler beim Ausführen von $ScriptPath: $_"
    }
}

# Hauptfunktion
function Start-CompleteSetup {
    # Setze Ausführungsrichtlinie
    Set-ExecutionPolicyForSetup

    # Liste aller Setup-Skripte
    $setupScripts = @(
        ".\Fastboot.ps1",
        ".\InstallApps.ps"
        # Fügen Sie hier weitere Skripte hinzu
    )

    # Führe jedes Skript aus
    foreach ($script in $setupScripts) {
        Write-Host "Führe aus: $script"
        Invoke-SetupScript -ScriptPath $script
    }

    Write-Host "Setup abgeschlossen."
}

# Starte das komplette Setup
Start-CompleteSetup

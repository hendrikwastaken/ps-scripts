# OneDrive-Prozess beenden
taskkill /f /im OneDrive.exe

# OneDrive deinstallieren
if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
    & "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
} elseif (Test-Path "$env:SystemRoot\System32\OneDriveSetup.exe") {
    & "$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
} else {
    Write-Warning "OneDriveSetup.exe wurde nicht gefunden. Möglicherweise ist OneDrive bereits deinstalliert."
}

# Warten, bis die Deinstallation abgeschlossen ist
Start-Sleep -Seconds 30

# Reste entfernen
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue

# Registry-Einträge entfernen
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive" -ErrorAction SilentlyContinue

Write-Output "OneDrive wurde deinstalliert und Überreste wurden entfernt."
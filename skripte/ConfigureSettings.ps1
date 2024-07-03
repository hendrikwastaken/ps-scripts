# Erfordert Administratorrechte
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
    Write-Warning "Bitte führen Sie dieses Skript als Administrator aus!"
    Break
}

# Fastboot (Schnellstart) deaktivieren
Write-Host "Deaktiviere Fastboot..."
powercfg /h off
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0

# Windows-Updates auf "Benachrichtigen, aber nicht automatisch herunterladen" setzen
Write-Host "Ändere Windows Update-Einstellungen..."
$AutoUpdatePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
If (!(Test-Path $AutoUpdatePath)) {
    New-Item -Path $AutoUpdatePath -Force | Out-Null
}
Set-ItemProperty -Path $AutoUpdatePath -Name "AUOptions" -Value 2

# Energiesparplan auf "Höchstleistung" setzen
Write-Host "Setze Energiesparplan auf Höchstleistung..."
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Visuelle Effekte auf "Beste Leistung" setzen
Write-Host "Optimiere visuelle Effekte für beste Leistung..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2

# Speicherbereinigung automatisieren
Write-Host "Aktiviere automatische Speicherbereinigung..."
Enable-ComputerRestore -Drive "C:\"
schtasks /Create /TN "AutomaticDiskCleanup" /TR "cleanmgr /sagerun:1" /SC DAILY /ST 02:00

# Deaktiviere unnötige Windows-Features
Write-Host "Deaktiviere unnötige Windows-Features..."
Disable-WindowsOptionalFeature -Online -FeatureName "Internet-Explorer-Optional-amd64" -NoRestart
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart

Write-Host "Änderungen abgeschlossen. Ein Neustart wird empfohlen, um alle Änderungen zu übernehmen."
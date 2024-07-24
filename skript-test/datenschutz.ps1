# Funktion zum Setzen von Registrywerten (WIP)
function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [string]$Type = "DWord"
    )
    
    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
}

# Werbungs-ID deaktivieren
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

# SmartScreen-Filter für Apps deaktivieren
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0

# Feedback-Häufigkeit auf "Nie" setzen
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0

# Standortverfolgung deaktivieren
Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Value 0

# Telemetrie auf das Minimum setzen (nur für Enterprise und Education Editionen möglich)
Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0

# Cortana deaktivieren
Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0

# Automatisches Sammeln von Sprachproben deaktivieren
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Name "HasAccepted" -Value 0

# Anzeige von Online-Inhalten in der Startmenüsuche deaktivieren
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0

Write-Output "Datenschutzeinstellungen wurden angepasst. Ein Neustart könnte erforderlich sein, um alle Änderungen zu übernehmen."
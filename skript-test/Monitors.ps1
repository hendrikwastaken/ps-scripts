# Funktion zum Speichern der aktuellen Monitoreinstellungen
function Save-MonitorConfig {
    param (
        [string]$ConfigName
    )
    
    $monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi
    $settings = @{}
    
    foreach ($monitor in $monitors) {
        $id = $monitor.InstanceName
        $position = Get-ItemProperty "HKCU:\System\CurrentControlSet\Control\GraphicsDrivers\Configuration\$id\00"
        $settings[$id] = @{
            PelsWidth = $position.PelsWidth
            PelsHeight = $position.PelsHeight
            PositionX = $position.PositionX
            PositionY = $position.PositionY
        }
    }
    
    $settings | ConvertTo-Json | Set-Content "$env:USERPROFILE\$ConfigName.json"
    Write-Host "Konfiguration gespeichert als $ConfigName"
}

# Funktion zum Wiederherstellen einer gespeicherten Konfiguration
function Restore-MonitorConfig {
    param (
        [string]$ConfigName
    )
    
    $configPath = "$env:USERPROFILE\$ConfigName.json"
    if (!(Test-Path $configPath)) {
        Write-Host "Konfiguration $ConfigName nicht gefunden"
        return
    }
    
    $settings = Get-Content $configPath | ConvertFrom-Json
    
    foreach ($id in $settings.PSObject.Properties.Name) {
        $config = $settings.$id
        Set-ItemProperty "HKCU:\System\CurrentControlSet\Control\GraphicsDrivers\Configuration\$id\00" -Name PelsWidth -Value $config.PelsWidth
        Set-ItemProperty "HKCU:\System\CurrentControlSet\Control\GraphicsDrivers\Configuration\$id\00" -Name PelsHeight -Value $config.PelsHeight
        Set-ItemProperty "HKCU:\System\CurrentControlSet\Control\GraphicsDrivers\Configuration\$id\00" -Name PositionX -Value $config.PositionX
        Set-ItemProperty "HKCU:\System\CurrentControlSet\Control\GraphicsDrivers\Configuration\$id\00" -Name PositionY -Value $config.PositionY
    }
    
    Write-Host "Konfiguration $ConfigName wiederhergestellt"
}

# Beispielaufrufe
# Save-MonitorConfig -ConfigName "HomeOffice"
# Restore-MonitorConfig -ConfigName "HomeOffice"
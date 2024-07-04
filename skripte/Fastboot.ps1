# Fastboot (Schnellstart) deaktivieren
Write-Host "Deaktiviere Fastboot..."
powercfg /h off
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0

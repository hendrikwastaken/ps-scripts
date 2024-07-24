# Neue Outlook-App deinstallieren (WIP)
Get-AppxPackage *Microsoft.OutlookForWindows* | Remove-AppxPackage

Write-Output "Neue Outlook-App wurde deinstalliert."
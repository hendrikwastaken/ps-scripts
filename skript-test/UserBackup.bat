@echo off
setlocal enabledelayedexpansion

:: Setze Quell- und Ziellaufwerk
set "SOURCE_USER=%USERPROFILE%"
set /p "DESTINATION_DRIVE=Bitte geben Sie den Ziellaufwerksbuchstaben ein (z.B. E): "

:: Erstelle Backup-Verzeichnis mit Datum
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set "datetime=%%G"
set "BACKUP_FOLDER=User_Backup_%datetime:~0,8%"
set "DESTINATION=%DESTINATION_DRIVE%:\%BACKUP_FOLDER%"

:: Erstelle Zielverzeichnis
mkdir "%DESTINATION%"

:: Liste der zu sichernden Verzeichnisse
set "FOLDERS_TO_BACKUP=Desktop Documents Pictures Downloads Music Videos"

:: Logging aktivieren
set "LOGFILE=%DESTINATION%\backup_log.txt"

echo Backup gestartet am %date% %time% > "%LOGFILE%"
echo Quelle: %SOURCE_USER% >> "%LOGFILE%"
echo Ziel: %DESTINATION% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

:: Durchführung des Backups für jedes Verzeichnis
for %%F in (%FOLDERS_TO_BACKUP%) do (
    echo Sichere %%F...
    echo Sichere %%F... >> "%LOGFILE%"
    
    robocopy "%SOURCE_USER%\%%F" "%DESTINATION%\%%F" /MIR /R:3 /W:10 /MT:8 /NP /LOG+:"%LOGFILE%" /TEE
)

echo.
echo Backup abgeschlossen!
echo.
echo Backup abgeschlossen am %date% %time% >> "%LOGFILE%"

:: Zeige Zusammenfassung
echo ========================================
echo Backup-Zusammenfassung:
echo Quelle: %SOURCE_USER%
echo Ziel: %DESTINATION%
echo Logdatei: %LOGFILE%
echo ========================================

pause
endlocal

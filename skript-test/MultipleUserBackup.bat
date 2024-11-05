@echo off
setlocal enabledelayedexpansion

:: Setze Ziellaufwerk
set /p "DESTINATION_DRIVE=Bitte geben Sie den Ziellaufwerksbuchstaben ein (z.B. E): "

:: Erstelle Backup-Verzeichnis mit Datum
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set "datetime=%%G"
set "BACKUP_FOLDER=Users_Backup_%datetime:~0,8%"
set "DESTINATION=%DESTINATION_DRIVE%:\%BACKUP_FOLDER%"

:: Erstelle Zielverzeichnis
mkdir "%DESTINATION%"

:: Logging aktivieren
set "LOGFILE=%DESTINATION%\backup_log.txt"

echo Backup gestartet am %date% %time% > "%LOGFILE%"
echo Ziel: %DESTINATION% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

:: Liste alle Benutzerprofile auf
echo Verfuegbare Benutzerprofile:
set "COUNT=0"
for /d %%U in (C:\Users\*) do (
    set /a "COUNT+=1"
    set "USER[!COUNT!]=%%~nxU"
    echo !COUNT!: %%~nxU
)

:: Benutzerauswahl
set /p "USER_CHOICE=Bitte Nummer des zu sichernden Benutzers eingeben (0 fuer alle Benutzer): "

:: Ordnerauswahl
echo.
echo Bitte geben Sie die zu sichernden Ordner an (getrennt durch Leerzeichen)
echo Beispiel: Desktop Documents Pictures Downloads "Eigene Dateien" Programme
echo Druecken Sie Enter fuer Standardordner (Desktop Documents Pictures Downloads Music Videos)
set /p "CUSTOM_FOLDERS="

if "!CUSTOM_FOLDERS!"=="" (
    set "FOLDERS_TO_BACKUP=Desktop Documents Pictures Downloads Music Videos"
) else (
    set "FOLDERS_TO_BACKUP=!CUSTOM_FOLDERS!"
)

:: Debug-Ausgabe der gewählten Ordner
echo.
echo Gewaehlte Ordner zum Backup:
for %%F in (%FOLDERS_TO_BACKUP%) do (
    echo - %%F
)
echo.

:: Hauptlogik für Benutzerauswahl
if "%USER_CHOICE%"=="0" (
    :: Alle Benutzer sichern
    for /L %%i in (1,1,%COUNT%) do (
        set "CURRENT_USER=!USER[%%i]!"
        call :backup_user "!CURRENT_USER!"
    )
) else (
    :: Einzelnen Benutzer sichern
    if %USER_CHOICE% leq %COUNT% (
        set "CURRENT_USER=!USER[%USER_CHOICE%]!"
        call :backup_user "!CURRENT_USER!"
    ) else (
        echo Ungültige Benutzerauswahl!
        echo Ungültige Benutzerauswahl! >> "%LOGFILE%"
        goto end
    )
)
goto end

:: Backup-Funktion für einen einzelnen Benutzer
:backup_user
set "username=%~1"
echo.
echo Sichere Benutzer: %username%
echo Sichere Benutzer: %username% >> "%LOGFILE%"

:: Debug-Information zum Benutzerverzeichnis
set "USER_DIR=C:\Users\%username%"
echo Benutzerverzeichnis: %USER_DIR%
echo Benutzerverzeichnis: %USER_DIR% >> "%LOGFILE%"

for %%F in (%FOLDERS_TO_BACKUP%) do (
    set "SOURCE_PATH=!USER_DIR!\%%~F"
    
    :: Debug-Ausgabe des vollständigen Pfads
    echo Prüfe Pfad: !SOURCE_PATH!
    echo Prüfe Pfad: !SOURCE_PATH! >> "%LOGFILE%"
    
    if exist "!SOURCE_PATH!" (
        echo Ordner gefunden: !SOURCE_PATH!
        echo Ordner gefunden: !SOURCE_PATH! >> "%LOGFILE%"
        echo Sichere %%~F...
        
        robocopy "!SOURCE_PATH!" "%DESTINATION%\%username%\%%~F" /MIR /R:3 /W:10 /MT:8 /NP /LOG+:"%LOGFILE%" /TEE
        
        :: Überprüfe robocopy Exitcode
        if errorlevel 8 (
            echo Fehler beim Kopieren von %%~F
            echo Fehler beim Kopieren von %%~F >> "%LOGFILE%"
        ) else (
            echo Backup von %%~F abgeschlossen
            echo Backup von %%~F abgeschlossen >> "%LOGFILE%"
        )
    ) else (
        echo Ordner nicht gefunden: !SOURCE_PATH!
        echo Ordner nicht gefunden: !SOURCE_PATH! >> "%LOGFILE%"
    )
    echo.
)
exit /b 0

:end
echo.
echo Backup abgeschlossen!
echo.
echo Backup abgeschlossen am %date% %time% >> "%LOGFILE%"

:: Zeige Zusammenfassung
echo ========================================
echo Backup-Zusammenfassung:
echo Ziel: %DESTINATION%
echo Gesicherte Ordner: %FOLDERS_TO_BACKUP%
echo Logdatei: %LOGFILE%
echo ========================================

pause
endlocal
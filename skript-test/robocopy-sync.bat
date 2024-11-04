:: Bitte nochmal auf Syntax prüfen
@echo off 
set "source=C:\Pfad\zur\Datei"
set "destination=E:\Backup"
set "file=MeineFile.datei"
set "backupPrefix=Backup_"
set "backup=%destination%\%backupPrefix%%file%"

if exist "%destination%\%file%" (
    copy "%destination%\%file%" "%backup%"
)

robocopy "%source%" "%destination%" "%file%" /Z /R:5 /W:15 /XO

if %ERRORLEVEL% EQU 1 (
    echo Die Datei wurde erfolgreich aktualisiert.
    echo Eine Sicherungskopie der vorherigen Version wurde erstellt: %backup%
) else if %ERRORLEVEL% GEQ 2 (
    echo Fehler beim kopieren. Errorlevel: %ERRORLEVEL%
    pause
) else (
    echo Keine Änderung festgestellt. Die Backup-Datei ist aktuell.
    if exist "%backup%" del "%backup%"
)

exit /b %ERRORLEVEL%
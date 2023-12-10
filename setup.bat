@echo off
REM Variables
set "Java=https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
set "Dest=C:\Users\%USERNAME%\Documents\jdk-21_windows-x64_bin.exe"

REM Comprobación de privilegios
ver | find "6." > nul
if %errorlevel% neq 0 goto NotAdmin

:Admin
echo.
pause
cls
REM Comprobación de Java
java -version > nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "& { Invoke-WebRequest -Uri '%Java%' -OutFile '%Dest%' }"
    if %errorlevel% neq 0 (
        color 0c
        echo "ERROR: Ejecución del comando fallida"
        exit /b 1
    ) else (
        start "" "%Dest%"
    )
)

goto End

REM Solicitud de privilegios
:NotAdmin
powershell Start-Process -Verb RunAs -FilePath "%0" -WindowStyle Hidden
goto Admin

:End

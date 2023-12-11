@echo off
REM Variables
set "Java=https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
set "Dest=C:\Users\%USERNAME%\Documents\jdk-21_windows-x64_bin.exe"

REM Comprobación de Java
java -version > nul 2>&1
if %errorlevel% neq 0 (
    echo Descargando JDK 21...
    echo %CMDCMDLINE% | find /i "powershell.exe" > nul
    if %errorlevel% neq 0 (
        powershell -Command "& { Invoke-WebRequest -Uri '%Java%' -OutFile '%Dest%' }"
        %Dest%
    ) else (
        Invoke-WebRequest -Uri '%Java%' -OutFile '%Dest%'
        %Dest%
    )
)

REM Instalación servidor
cls
echo Instalando servidor...
echo.
echo Elige la opcion Server
for /f "delims=" %%i in ('dir /b C:\Users\%USERNAME%\Documents\minecraft ^| findstr /r "\.jar$"') do (
    set "Installer=C:\Users\%USERNAME%\Documents\minecraft\%%i"
)
%Installer%
cls
echo Instalacion terminada

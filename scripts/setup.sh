#!/bin/sh
# @author: rxfatalslash

# Variables de color
CRE=$(tput setaf 1)
CGR=$(tput setaf 2)
CYE=$(tput setaf 3)
BLD=$(tput bold)
CNC=$(tput sgr0)

# Variables
modpack=$1
dir="/opt/minecraft"

# Función para versiones antiguas
old_install() {
    clear
    logo "Instalando servidor..."
    cd $dir
    java -jar $dir/forge-*-installer.jar --installServer 2>/dev/null # Instalación del servidor
    rm $dir/forge-*-installer.jar $dir/forge-*-installer.jar.log
    clear
    read -rp "[+] ¿Cúanta memoria RAM en GB quieres que tenga tu servidor? [2-8] " ram # RAM máxima del servidor
    read -rp "[+] ¿Quieres cambiar la dificultad? [s/N] " dif
    while true; do
        case $dif in
            [sS]*)
                printf '%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
                printf "0) %s%sPacífico%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                printf "1) %s%sFácil%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                printf "2) %s%sNormal%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                printf "3) %s%sDifícil%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                read -rp "[+] ¿Qué dificultad quieres? [0-3] " d
                while true; do
                    case $d in
                        [0123]*)
                            echo "difficulty=$d\n" > $dir/server.properties
                            break
                        ;;
                        *) printf "%s%sERROR:%s Introduce solo una de las opciones anteriores\n" "${BLD}" "${CRE}" "${CNC}";;
                    esac
                done
                break
            ;;
            [nN]*) break;;
            *) printf "%s%sERROR:%s Introduce solo 's' o 'n'\n" "${BLD}" "${CRE}" "${CNC}";;
        esac
    done
    read -rp "[+] ¿Quieres cambiar el puerto del servidor? [s/N] " port
    while true; do
        case $port in
            [sS]*)
                read -rp "[+] ¿Qué puerto quieres utilizar? [1025-65535] " p
                echo "server-port=$p\n" >> $dir/server.properties
                break
            ;;
            [nN]*) break;;
            *) printf "%s%sERROR:%s Introduce solo 's' o 'n'\n" "${BLD}" "${CRE}" "${CNC}";;
        esac
    done
    clear
    logo "Configurando servidor..."
    sleep 3
    java -Xmx"$ram"G -jar $dir/minecraft_server.*.jar nogui
    echo "eula=true" > $dir/eula.txt # Aceptar EULA
    if [ $modpack ]; then
        if [ ! -d $dir/mods ]; then
            mkdir -p $dir/mods
        fi
        cp -r $modpack/* $dir/mods
    fi
    read -rp "[+] ¿Quieres poner una semilla personalizada? [s/N] " seed
    while true; do
        case $seed in
            [sS]*)
                read -rp "[+] Introduce la semilla: " s
                echo "level-seed=$s\n" >> $dir/server.properties
                break
            ;;
            [nN]*) break;;
            *) printf "%s%sERROR:%s Introduce solo 's' o 'n'\n" "${BLD}" "${CRE}" "${CNC}";;
        esac
    done
    logo "Iniciando servidor..."
    java -Xmx"$ram"G -jar $dir/minecraft_server*.jar nogui
}

# Función para versiones nuevas
new_install() {
    clear
    logo "Instalando servidor..."
    cd $dir
    java -jar $dir/forge-*-installer.jar --installServer 2>/dev/null # Instalación del servidor
    rm $dir/forge-*-installer.jar $dir/forge-*-installer.jar.log
    clear
    read -rp "[+] ¿Cúanta memoria RAM en GB quieres que tenga tu servidor? [2-8] " ram
    read -rp "[+] ¿Quieres cambiar la dificultad? [s/N] " dif
    while true; do
        case $dif in
            [sS]*)
                printf '%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
                printf "0) %s%sPacífico%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                printf "1) %s%sFácil%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                printf "2) %s%sNormal%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                printf "3) %s%sDifícil%s\n\n" "${BLD}" "${CGR}" "${CNC}"
                read -rp "[+] ¿Qué dificultad quieres? [0-3] " d
                echo "difficulty=$d\n" > $dir/server.properties
                break
            ;;
            [nN]*) break;;
            *) printf "%s%sERROR:%s Introduce solo 's' o 'n'\n" "${BLD}" "${CRE}" "${CNC}";;
        esac
    done
    read -rp "[+] ¿Quieres cambiar el puerto del servidor? [s/N] " port
    while true; do
        case $port in
            [sS]*)
                read -rp "[+] ¿Qué puerto quieres utilizar? [1025-65535] " p
                echo "server-port=$p\n" >> $dir/server.properties
                break
            ;;
            [nN]*) break;;
            *) printf "%s%sERROR:%s Introduce solo 's' o 'n'\n" "${BLD}" "${CRE}" "${CNC}";;
        esac
    done
    clear
    logo "Configurando servidor..."
    echo "-Xmx"$ram"G" > $dir/user_jvm_args.txt # RAM máxima del servidor
    echo "eula=true" > $dir/eula.txt # Aceptar EULA
    if [ $modpack ]; then
        if [ ! -d $dir/mods ]; then
            mkdir -p $dir/mods
        fi
        cp -r $modpack/* $dir/mods
    fi
    read -rp "[+] ¿Quieres poner una semilla personalizada? [s/N] " seed
    while true; do
        clear
        case $seed in
            [sS]*)
                read -rp "[+] Introduce la semilla: " s
                echo "level-seed=$s" >> $dir/server.properties
                break
            ;;
            [nN]*) break;;
            *) printf "%s%sERROR:%s Introduce solo 's' o 'n'\n" "${BLD}" "${CRE}" "${CNC}";;
        esac
    done
    clear
    logo "Iniciando servidor..."
    sh $dir/run.sh
}

# Logo
logo () {

    local text="${1:?}"
    echo -en "
    WOdddddxk0KNW                                            WNK0kxdddddOW 
     Wo........',:lx0N                                    N0xl:,'........oW 
      Xc.,clcc:;'....;lON                              NOl;....';:cclc,.cX  
       Kc'cdodlc::ccc;..:kN                          Nk:..;ccc::cldodc'cK   
        Xo;:loooooooool:,'cK                        Kc',:loooooooool:;oX    
         WKxolccclllllllc;';OW                    WO;';clllllllcccloxKW     
            WNKOOOOkkkOkkkdokN                    NkodkkkOkkkOOOOKNW       
    \n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

logo "rxfatalslash"

# Root
if [[ $EUID -ne 0 ]]; then
    printf "%s%sERROR:%s Ejecuta el script como root\n" "${BLD}" "${CRE}" "${CNC}"
    exit 1
fi

printf "%s%sEste script automatiza la instalación de un servidor de Minecraft con mods%s\n\n" "${BLD}" "${CGR}" "${CNC}"

# Confirmación
while true; do
    read -rp "[+] ¿Quieres continuar? [s/N] " confirm
    clear
    case $confirm in
        [sS]*) break;;
        [nN]*) exit 1;;
        *) printf "%s%sError:%s Escribe solo 's' o 'n'\n\n" "${BLD}" "${CRE}" "${CNC}";;
    esac
done
clear

# Distro
distro="$(cat /etc/os-release | cut -d '=' -f2 | sed -e 's/"//g' | awk 'NR==1 {print $1}')"
case "$distro" in
    ["Arch Linux""Arch"]*)
        printf "%s%sSistema Arch Linux detectado%s\n\n" "${BLD}" "${CGR}" "${CNC}"
        jdk="$(pacman -Qs jdk*-openjdk)"
        wget="$(pacman -Qs wget)"
        mkdir -p $dir

        # JDK check
        if [[ -z $jdk ]]; then
            pacman -S jdk-openjdk --noconfirm
        fi

        # Wget check
        if [[ -z $wget ]]; then
            pacman -S wget --noconfirm
        fi
    ;;
    ["Ubuntu""Debian"]*)
        printf "%s%sSistema Ubuntu detectado%s\n\n" "${BLD}" "${CGR}" "${CNC}"
        jdk="$(dpkg -l | grep openjdk)"
        wget="$(dpkg -l | grep wget)"
        mkdir -p $dir
        
        # JDK check
        if [[ -z $jdk ]]; then
            apt-get install -y openjdk-17-jdk
        fi

        # Wget check
        if [[ -z $wget ]]; then
            apt-get install -y wget
        fi
    ;;
    *)
        printf "%s%sERROR:%s No existe soporte para esta versión de Linux\n\n" "${BLD}" "${CRE}" "${CNC}"
        exit 1
    ;;
esac

# Comprobar versión
file="$(basename $dir/forge-*-installer.jar | cut -d '-' -f2 | cut -d '.' -f2)"

if [ $file <= 16 ]; then
    old_install
else
    new_install
fi
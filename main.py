#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author: rxfatalslash

import requests
import numpy as np
from tqdm.auto import tqdm
import re
import subprocess
import os
import sys
import platform

url = "https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json"
response = requests.get(url)

if platform.system() == "Linux" and os.geteuid() != 0:
    print("\033[031m\033[1mERROR:\033[0m Este script se debe ejecutar como usuario root")
    sys.exit(1)

while True:
    r = input("¿Quieres instalar mods? [s/N] ")
    match r.lower():
        case "s":
            if len(sys.argv) < 2:
                if platform.system() == "Windows":
                    os.system('cls')
                else:
                    os.system('clear')
                print("\033[31m\033[1mERROR:\033[0m Pasa la carpeta con los mods deseados como argumento")
                sys.exit(1)
            else:
                if os.path.exists(sys.argv[1]):
                    if os.path.isdir(sys.argv[1]):
                        break
                    else:
                        if platform.system() == "Windows":
                            os.system('cls')
                        else:
                            os.system('clear')
                        print("\033[31m\033[1mERROR:\033[0m El elemento no es una carpeta")
                        sys.exit(1)
                else:
                    if platform.system() == "Windows":
                        os.system('cls')
                    else:
                        os.system('clear')
                    print("\033[31m\033[1mERROR:\033[0m El elemento no existe")
                    sys.exit(1)
        case "n":
            break
        case _:
            print("\033[31m\033[1mERROR:\033[0m Introduce solo 's' o 'n'")

if response.status_code == 200:
    data = response.json()
    promos = data['promos']
    last_version = np.array(list(promos.items())[-1])

    if promos:
        while True:
            if platform.system() == "Windows":
                os.system('cls')
            else:
                os.system('clear')
            r = input("¿Qué versión quieres? [Recommended/Latest] ")
            if platform.system() == "Windows":
                os.system('cls')
            else:
                os.system('clear')
            match r.lower():
                case "recommended":
                    break
                case "latest":
                    break
                case _:
                    print("\033[31m\033[1mERROR:\033[0m Introduce uno de los valores indicados")

        for version, id in promos.items():
            if r.lower() in version:
                print(f"\033[32m\033[1mVersion:\033[0m {version}, id: {id}")

        while True:
            ve = input("\n¿Qué número de versión quieres? [1.1-1.20.4] ")
            v = ve.split("-")[0]
            os.system('clear')
            if re.search("^[1-9]{1}\.[0-9]{1,2}\.[0-9]{1,2}$", v):
                break
            else:
                print("\033[31m\033[1mERROR:\033[0m Introduce uno de los valores indicados")   

        for version, id in promos.items():
            if v in version and isinstance(r, str) and r.lower() in version:
                print(f"\033[32m\033[1mVersión:\033[0m {version}\n")
                
                url = f"https://maven.minecraftforge.net/net/minecraftforge/forge/{v}-{id}/forge-{v}-{id}-installer.jar"
                response = requests.get(url, stream=True)

                match platform.system():
                    case "Linux":
                        path = "/opt/minecraft"
                        if not os.path.exists(path):
                            os.mkdir(path)
                            with open(f"{path}/forge-{v}-installer.jar", "wb") as r:
                                with tqdm(
                                    unit='B', unit_scale=True, unit_divisor=1024, miniters=1,
                                    desc="\033[32m\033[1mEstado de descarga\033[0m", total=int(response.headers.get('content-length', 0))
                                ) as pbar:
                                    for chunk in response.iter_content(chunk_size=4096):
                                        r.write(chunk)
                                        pbar.update(len(chunk))
                        else:
                            with open(f"{path}/forge-{v}-installer.jar", "wb") as r:
                                with tqdm(
                                    unit='B', unit_scale=True, unit_divisor=1024, miniters=1,
                                    desc="\033[32m\033[1mEstado de descarga\033[0m", total=int(response.headers.get('content-length', 0))
                                ) as pbar:
                                    for chunk in response.iter_content(chunk_size=4096):
                                        r.write(chunk)
                                        pbar.update(len(chunk))
                    case "Windows":
                        path = f"C:/Users/{os.environ['USERNAME']}/Documents/minecraft"
                        if not os.path.exists(path):
                            os.mkdir(path)
                            with open(f"{path}/forge-{v}-installer.jar", "wb") as r:
                                with tqdm(
                                    unit='B', unit_scale=True, unit_divisor=1024, miniters=1,
                                    desc="\033[32m\033[1mEstado de descarga\033[0m", total=int(response.headers.get('content-length', 0))
                                ) as pbar:
                                    for chunk in response.iter_content(chunk_size=4096):
                                        r.write(chunk)
                                        pbar.update(len(chunk))
                        else:
                            with open(f"{path}/forge-{v}-installer.jar", "wb") as r:
                                with tqdm(
                                    unit='B', unit_scale=True, unit_divisor=1024, miniters=1,
                                    desc="\033[32m\033[1mEstado de descarga\033[0m", total=int(response.headers.get('content-length', 0))
                                ) as pbar:
                                    for chunk in response.iter_content(chunk_size=4096):
                                        r.write(chunk)
                                        pbar.update(len(chunk))
                    case _:
                        print("\033[31m\033[1mERROR:\033[0m Esta plataforma no tiene soporte")
                        sys.exit(1)


        match platform.system():
            case "Linux":
                try:
                    os.system('clear')
                    subprocess.run(['chmod', '+x', './scripts/setup.sh'])
                    if len(sys.argv) < 2:
                        subprocess.run('./scripts/setup.sh')
                    else:
                        subprocess.run(['./scripts/setup.sh', sys.argv[1]])
                except Exception:
                    print("\033[31m\033[1mERROR:\033[0m El fichero no existe")
                    sys.exit(1)
            case "Windows":
                try:
                    os.system('cls')
                    if len(sys.argv) < 2:
                        subprocess.run('.\scripts\setup.bat')
                    else:
                        subprocess.run(['.\scripts\setup.bat', sys.argv[1]])
                except Exception:
                    print("\033[31m\033[1mERROR:\033[0m El fichero no existe")
                    sys.exit(1)
            case _:
                print("\033[31m\033[1mERROR:\033[0m Esta plataforma no tiene soporte")
                sys.exit(1)
else:
    print("\033[31m\033[1mERROR\033[0m Código de estado:", response.status_code)
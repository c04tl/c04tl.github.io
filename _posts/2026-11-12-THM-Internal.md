---
title: Resolución de máquina Internal - TryHackMe
date: 2026-11-12 20:00:00 +/-TTTT
categories: [CTF, TryHackMe]
tags: [hydra, wordpress, nmap, reverse shell, find, reverse proxy]
---

# Introducción

Bienvenidos a mi página y a este post donde veremos el recorrido sobre como solucionar la máquina Internal de TryHackMe.
La resolución de esta máquina la realizamos con la comunidad de **[Twitch](https://www.twitch.tv/c04tl)** y de acuerdo con el room, se recomienda crear un reporte de Pentesting.

Nosotros hicimos uno muy, muy sencillo pero aquí pongo el repositorio de github para que lo puedan consultar: [Reporte](https://github.com/c04tl/Pentest-Report-TryHackMe-Internal)

Para comenzar, tenemos que agregar la dirección IP de la máquina en nuestro archivo `/etc/hosts` con el nombre internal.thm.

# Resolución

Comenznado con la fase de reconocimiento a nivel de red, ejecutamos un escaneo de puertos y servicios utilizando la siguiente linea de comandos:
```shell
sudo nmap -Pn -n -p- --open -sSVC --min-rate 4000 internal.thm
```

Y aquí hacemos un desgloce de las opciones usadas:
- `Pn` omite un ping inicial para comprobar el estado del servidor
- `n` Omite consultar los DNS para hacer la traducción correspondiente
- `-p-` escaneo todos los puertos 0-65535
- `open` muestra solo los puertos abiertos en el resultado
- `sSVC` comprende 3 opciones en una "abreviación":
    - `sS` escaneo stealth o sigiloso (necesita permisos sudo)
    - `sV` Muestra las versiones de los servicios detectados
    - `sC` ejecuta una serie de scripts para descubrimiento
- `min-rate 4000` envia paquetes a una velocidad no menor a 4000 paquetes por segundo



Como resultado obtuvimos lo siguiente:

```shell
nmap
```


Comenzando por el puerto `80` vamos explorando la aplicación para **Enumerar** detectar su tecnología


---
title: Personalización de blackarch
date: 2023-01-04 23:00:00 +/-TTTT
categories: [Tutorial, DIY]
tags: [python, bash, curl]
---

# Introducción

En este primer articulo del año 2023 veremos como instalar y personalizar un entorno de hacking profesional comenzando por la instalación del sistema operativo [Arch Linux](https://archlinux.org/) y toda la configuración necesaria como el idioma, la distribución de teclado, el gestor de paquetes [Paru](https://aur.archlinux.org/packages/paru) y un gestor de ventanas que hará que nuestra máquina no consuma tantos recursos además de ser súper personalizable. Después convertiremos nuestro sistema en un [Black Arch](https://www.blackarch.org/) con ayuda del script oficial de esta distribución y finalmente instalaremos algunos paquetes "escenciales" para poder realizar un pentest o hackeo ético en las plataformas [Hack The Box](https://www.hackthebox.com/), [Try Hack Me](https://tryhackme.com/) o en cualquier entorno "real". Es importatne mencionar que partiremos este tutorial tomando en cuenta que ya debemos tener instalado [VirtualBox](https://www.virtualbox.org/) o [VMWare](https://www.vmware.com/) según sea nuestra preferencia ya que solo hacen falta unas pequeñas modificaciones para que funcione correctamente.

## Descarga de arch Linux y creación de máquina virtual
Comenzamos este tutorial descargando desde la [página oficial de Arch](https://archlinux.org/download/) la imagen iso para la instalación, una vez descargada crearemos nuestra máquina virtual con las siguientes especificaciones:

- 20 GB de disco duro (se puede modificar de acuerdo al uso que le daremos)
- 2 GB de memoria RAM
- Firmware EFI

### Para VirtualBox
Crearemos la máquina seleccionando el botón añadir (1), asiganmos el nombre (2), seleccionamos la carpeta donde se guardará la máquina (3), seleccionamos la ruta de la imagen ISO (4) y damos click en `Next`.

![Añadir](/assets/img/7-BlackArch-custom/1.png)


Asignamos memoria RAM (1), procesadores (2) y activamos el Firmware EFI (3)

![Recursos](/assets/img/7-BlackArch-custom/2.png)

Asignamos el tamaño del disco y con esto finalizamos la creación de la máquina

![Disco](/assets/img/7-BlackArch-custom/3.png)


### Para VMware

Crearemos la máquina normalmente y después iremos a la carpeta donde se crearon los archivos de la máquina virtual, en mi caso están en `Documentos/Virtual Machines/BlackArch`, aquí abriremos el archivo con extensión `.vmx`

![archivo.vmx](/assets/img/7-BlackArch-custom/4.png)

Abrimos  este archivo con cualquier editor de texto y añadimos la siguiente línea: `firmware="efi"`

![firmware EFI](/assets/img/7-BlackArch-custom/5.png)

Guardamos y listo.

## Particionado de disco
Después de hacer las modificaciones anteriores encenderemos la máquina virtual, a continuación, tomaremos en cuenta 3 particiones: `sda1` como la partición de arranque, `sda2`  será la partición donde se instalará nuestro sistema y herramientas por lo que si asignamos más de 20GB a nuestra máquina esta partición será de mayor tamaño, finalmente la partición `sda3` se habilitará como memoria de intercambio por lo que cambiará de acuerdo a sus preferencias.

Para crear las particiones utilizaremos `cfdisk` y el siguiente esquema:

- sda1 300M
- sda2 18.5G o el espacio de su elección
- sda3 1.2G

Ahora solo ejecutamos `cfdisk` en la terminal y seleccionamos la opción `gpt` :

![cfdisk](/assets/img/7-BlackArch-custom/6.png)

Después nos aparecerá la siguiente pantalla donde seleccionaremos la opción `New`

![Primera partición](/assets/img/7-BlackArch-custom/7.png)

En la parte inferior escribimos `300m`, damos enter y con esto se creará la partición `sda1`, ahora con las flechas del teclado seleccionamos `Free space`(1) y de nuevo seleccionamos `New`(2)

![Segunda partición](/assets/img/7-BlackArch-custom/8.png)

Asignamos `18.5G` o el tamaño que deseemos y con esto habremos creado la partición `sda2`. Finalmente seleccionamos `Free space`(1) y `New`(2).

![Tercera partición](/assets/img/7-BlackArch-custom/9.png)

Para esta última parición asignamos el espacio restante (en mi caso 1.2GB), después de crear esta partición seleccionamos `/dev/sda1`(1) y seleccionamos la opción `Type`(2) del menú inferior.

![Tipo de la primera partición](/assets/img/7-BlackArch-custom/10.png)

En el siguiente menú seleccionamos la opción `EFI System`.

![EFI system](/assets/img/7-BlackArch-custom/11.png)

Ahora seleccionamos la partición `/dev/sda3`(1) y seleccionamos la opción `Type`(2)

![Tipo de la tercera partición](/assets/img/7-BlackArch-custom/12.png)

Para esta partición seleccionamos `Linux swap`

![Linux swap](/assets/img/7-BlackArch-custom/13.png)

Seleccionamos la opción `Write`(1) en la parte inferior para escribir los cambios en las particiones.

![Write partitions](/assets/img/7-BlackArch-custom/14.png)

Escribimos `yes` para confirmar.

![Claro que yes](/assets/img/7-BlackArch-custom/15.png)

Finalmente seleccionamos `Quit` para salir de `cfdisk`.

![Quit cfdisk](/assets/img/7-BlackArch-custom/16.png)

Podemos ejecutar `fdisk -l` para mostrar las particiones y revisar que todo esté correcto.

![fdisk](/assets/img/7-BlackArch-custom/17.png)

## Instalación
Después de particionar el disco podemos realizar una instalación automatica a través de un script que escribí o a través de una instalación manual siguiendo todos los comandos dentro del script.

### Instalación automática
Para la instalación automática clonaremos mi [repositorio de github](https://github.com/c04tl/Entorno-BlackArch), es importante aclarar que todos los comandos utilizados en mi script están basados en la [guía de instalación de Arch](https://wiki.archlinux.org/title/Installation_guide_(Espa%C3%B1ol)) y en la zona horaria y servidores de México. Una vez clonado, podemos cambiar cualquier archivo de configuración y los wallpapers.

Ahora levantaremos un servidor http con python en la carpeta descargada, modificaremos las lineas 36, 37 y 38 con el nombre de nuestro usuario, el nombre de nuestra máquina y la ip y puerto de nuestro servidor.

![usr, maquina, ip](/assets/img/7-BlackArch-custom/18.png)

En la línea 45 y 46 escribiremos la contraseña del usuario estándar y del usuario root después de los 2 puntos.

![Contraseñas](/assets/img/7-BlackArch-custom/19.png)

> IMPORTANTE:
> Si estamos usando VirtualBox necesitaremos descomentar las líneas  65 y 66 y comentar las lineas 70 - 72.
> Si estamos usando VMWare necesitaremos descomentar las líneas 70 - 72 y comentar las lineas 65 y 66.

Después de hacer estas modificaciones solo hace falta ejecutar la siguiente línea de comandos que descargará el script y se lo pasará a bash para ejecutarlo (recuerden cambiar la ip por la de su servidor).

```shell
curl 192.168.0.2:8000/BlackArch.sh | bash
```

Una vez que empiece el proceso de descarga e instalación debemos dejar el servidor python arriba para que el script pueda descargar todos los archivos de configuración del repositorio que clonamos así que ahora podemos ir a tomar un café o levantarnos por unos minutos. Después de que regresemos comenzará la instalación de `Paru`, para esto debemos introducir la contraseña del usuario estándar.

![Paru](/assets/img/7-BlackArch-custom/20.png)


Después comenzará la instalación de la `powerlevel10k`, nuestras herramientas de hacking y finalmente se instalará [NvChad](https://github.com/NvChad/NvChad#what-is-it) para [neovim](https://neovim.io/), esto con el fin de facilitar la escritura de scripts :).


Cuando NVCHAD termine de instalarse aparecerá una pantalla como la siguiente:


![NVCHAD](/assets/img/7-BlackArch-custom/21.png)


Solo debemos ejecutar el comando `:q` de vim para regresar a la terminal, despues reiniciamos la máquina con el comando `reboot`, después de reiniciar ya estará listo nuestro de hacking profesional montado en un BlackArch personalizado.



# Conclusiones

La instalación y configuración de nuestro entorno de hacking es realmente sencilla con el script y los archivos que he agregado al repositorio, además de ser completamente personalizable a través de los archivos de configuración.

Espero les haya sido útil esta publicación para aprender más sobre los entornos Linux, sus archivos de configuración, rutas, tipos de sistemas de archivos, etc. nos vemos hasta otra publicación ;)

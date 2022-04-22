---
title: Como obtener una shell interactiva a partir de una dumbshell
date: 2021-03-16 12:00:00 +/-TTTT
categories: [Tutorial, DIY]
tags: [bash, reverse shell, dumb shell, full interactive shell, python]
---

# Introducción

Generalmente cuando obtenemos acceso a través de una conexión inversa o `Reverse Shell` nos encontramos con el problema que no podemos usar el autocompletado de la consola, a veces el contenido se muestra con dimensiones incorrectas o se visualiza con identados extraños, sin embargo, en este post veremos como obtener una `Full Interactive shell` a partir de una `Dumb Shell` en unos sencillos pasos.


# Procedimiento

En mi canal de youtube tengo un vídeo explicando el procedimiento, les dejo aquí el enlace si les gusta más el formato vídeo ;) [Obtener interactive shell](https://www.youtube.com/watch?v=3jTIJgSpkbs)


Partiremos este tutorial tomando en cuenta que en nuestro `netcat` ya hemos recibido una conexión, explicaremos como obtener nuestra `Full Interactive Shell` con `bash` y con `Python`.

![netcat](/assets/img/3_Shell-Interactiva/1.png)

## Bash

Para realizarlo con bash escribimos la siguiente línea de comandos:

```shell
script -q /dev/null -c bash
```

## Python
Para python utilizaremos la siguiente línea de comandos:

```shell
python3 -c "import pty; pty.spawn('/bin/bash')"
```

# Procedimiento (Continuación)

***Con cualquiera de los dos métodos veremos el prompt de bash después de dar enter:***

![prompt](/assets/img/3_Shell-Interactiva/2.png)

Ahora enviaremos este proceso al `background` o segundo plano con la combinacion de teclas `Ctrl+Z` y después escribiremos la siguiente línea de comandos:

```shell
stty raw -echo; fg
```

Estas instrucciones le dicen a bash que imprima nuestra shell actual en modo raw y enseguida le indicamos que regrese al `foreground` (fg) la tarea enviada al `background`. Despues de dar enter veremos un mensaje donde escribiremos reset (puede que no se vea que estemos escribiendo), finalmente nos preguntara el tipo de terminal y aquí escribiremos `xterm`:

![fg](/assets/img/3_Shell-Interactiva/3.png)

Después de dar enter se limpiará la pantalla y tendremos de nueva el prompt de bash, ahora debemos importar dos variables `SHELL` y `TERM` de la siguiente manera:
```shell
export SHELL=bash
export TERM=xterm
```
![export](/assets/img/3_Shell-Interactiva/4.png)

En este punto nuestra shell debe permitirnos recorrer el historial (flechas arriba y abajo), limpiar la pantalla (Ctrl+L), cancelar un proceso (Ctrl+C), etc. pero puede que el contenido no se muestren correctamente, para corregir esto abriremos una shell en nuestro equipo y vamos a ejecutar lo siguiente:

```shell
stty size
```
![tamaño](/assets/img/3_Shell-Interactiva/5.png)


Obtendremos las filas (primer número) y las columnas (segundo número) que tiene una shell en nuestro equipo, ahora esos valores los copiaremos a la reverse shell para que se muestre correctamente:


```shell
stty rows 41 columns 172
```

![dimensiones](/assets/img/3_Shell-Interactiva/6.png)


# Conclusiones

Con estos sencillos pasos debemos tener configurada nuestra full interactive shell que nos permitirá explorar la máquina objetivo con más comodidad para las tareas de post-explotación, sin embargo, no siempre funciona debido al tipo de conexiones inversas que obtenemos. Espero que este post les haya gustado y que les haya sido útil, nos vemos en otro tutorial o en otra publicación. 


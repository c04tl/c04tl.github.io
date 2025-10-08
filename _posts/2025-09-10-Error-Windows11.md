---
title: Reparando Windows 11 qué no arranca
date: 2025-10-07 19:00:00 +/-TTTT
categories: [Tutorial, DIY]
tags: [windows, cmd, command prompt]
---

# Contexto

En este post les contaré qué tienen en común, unas boneless, un colchón nuevo y mi laptop con windows 11 qué dejó de funcionar por que quedó sin archivos de arranque. Y tal vez te estés preguntando: "¿Unas boneless y un windows 11 corrupto?"
Y la respuesta es Sí, si tienen relación.

Les cuento por que resulta y resalta, que el día Jueves 4 de Agosto, ya se acercaba la hora de salida de  mi trabajo y en eso mi roomie me mandó un meme buenísimo, aquí la evidencia:

![Sabor BIOS](/assets/img/8_Reparando-Windows11/1.jpg)

Despues me preguntó si yo tenía plan y si quería acompañarla para buscar un regalo para el cumpleaños del novio de una de sus amigas y terminando de comprar el regalo pasáramos a cenar alitas.
No les voy a mentir, mi plan era llegar, jugar Age of Empires, luego escribir un post qué ya había empezado tomo mientras estrenaba mi colchón nuevo por que unos 15 días atrás lo compré  y me lo trajeron el 3 de agosto.


Continuando con la historia, le dije a mi roomie que sí y entonces regresé rápido al departamento, me cambié y fuimos a buscar el regalo
Pasamos a una tienda de ropa en busca de una playera "minimalista" sencilla, pero solo encontrábamos oversized y no le gustaban, estuvimos buscando un rato y al fin dimos con la elegida


Ya con eso, fuimos a buscar una gorra pero ahí fallamos por que no habían gorras cool, solo eran lisas y sin estampados entonces quisimos buscar calcetines pero tampoco tenían imágenes o diseños padres, 
Entonces solo buscamos un par de calcetines pero lo que si encontramos fue esta chamarra de Pókemon súper padre el diseño, y puse una encuesta en instagram:

![Chamarra pokémon](/assets/img/8_Reparando-Windows11/2.jpg)

La mayoría votó qué si me quedaba, y créanme qué tuve una tentación inmensa pior comprármelo y ponérsela a mi gatita toda una maestra pokemón <3, pero resistí y no la compré. Después salimos de la tienda con los regalos y luego fuimos buscar de cenar, estabamos entre sushi y alitas y al final comimos boneless en el wings academy

Había una promo de 20 alítas, pedimos BBQ y Louissiana, a mí me gustan mucho las louisiana entonces me las acabé por que estaban muy picositas para mi roomie, terminé super lleno y me pegó durísimo el mal del puerco jajaja.

Ya que llegamos a casa, era un poco tarde pero me lavé mis dientes y me hice mi skin care, fui a mi cuarto me acosté y me dije: "Puedo escribir un ratito el post que estaba escribiendo ayer", entonces fui por mi lap, me volví a acostar y en la comodidad de nuevo colchón me sentí muy cansado, entonces dije: "mejor me duermo y descanso", dejé mi lap a un lado y me quedé super dormido, dormí como 9 horas y media. Al otro día estaba super bien descansado y en la tarde prendí la lap y me salió una nuncio de la BIOS diciendo que se le había acabado la batería, la conecté y le di continuar.



# Problema

Al otro día cuando la prendí y terminó ded prender, me pedía seleccionar un idioma y después me daba un menu de recuperación pero ninguna de las opciones arreglaba el problema, la unica que funcionaba era la de abrir un interprete de comandos.

![cmd](/assets/img/8_Reparando-Windows11/4.jpg)
![cmd](/assets/img/8_Reparando-Windows11/5.jpg)
![cmd](/assets/img/8_Reparando-Windows11/6.jpg)

Despues de reiniciar varias veces e intentar todos los métodos del menú yo ya estaba pensando que iba a tener que formatear la lap y todo lo que implica formatear: respaldar, formatear, configurar cuentas, configurar perfiles, instalar aplicaciones, etc. etc.



Pero entonces se me ocurrió buscar un tutorial en youtube, y después de varias busquedas y tutoriales sin funcionar, dí con el bueno, el elegido jajajaja.

Para mi fortuna el video está en español, y es muy conciso, todos los créditos para el autor: [INFORMÁTICA FÁCIL](https://www.youtube.com/watch?v=J53B8yziVAE)


Mi hipotesis sobre el problema es que mientras se estaban actualizando archivos de arranque o algún componente del inicio de windows, se le acabó la batería a la laptop y esto corrompió los archivos o no terminaron de escribirse y por eso no sabía que archivos cargar



# Solución

Para arreglar este problema se ejecutan una serie de comandos desde la opción de consola de comandos del arranque de windows, investigando sobre que son y que hace cada uno de estos comandos, encontré que. . .        


- DISKPART es un gestor de discos, particiones y volumenes
- bootsect permite reescribir el código de arranque de windows
- bcdboot se usa para reconstruir BCD (Boot Configuration Data) cuando Windows no arranca.
. . .


Vamos a empezar el tutorial asumiendo que ya tenemos una consola de comandos iniciada. El primer comando que ejecutamos es `diskpart`, una herramienta que es una navaja suiza para discos y particiones en wuindows que nos deja administrar dicos, particiones y volumenes.

```prompt
diskpart
```

Al ejecutar está línea de comandos, "entramos" al menú de diskpart, lo sabrás por que vas a ver el prompt `DISKPART>`, ahí escribimos `list disk` y nos aparecerán todos los discos que están instalados, después seleccionamos el numero del disco con el que vamos a trabajar, en mi caso es el disco 0: `select disk 0`, escribimos otra vez `list disk` y veremos el disco seleccionado con un asterisco dedl lado izquierdo:


![diskpart](/assets/img/8_Reparando-Windows11/7.jpg)


Ahora vamos a ver las particiones que tiene este disco con `list part`, seleccionamos la partición de tipo "sistema" con su numero, en mi caso `select part 1`


![select part](/assets/img/8_Reparando-Windows11/8.jpg)


En esta parte tenemos que seleccionar el volumen con el mismo tamaño que la partición para formatearlo con el sistema de archivos `fat32`, para eso hacemos lo siguiente:

1. Usamos `list vol` para ver los volumenes
2. Asignamos una letra de unidad con `assign letter=X`
3. Volvemos a hacer un `list vol`
4. Con el volumen seleccionado ejecutamos `format override fs=fat32`

> En caso de que el volumen no esté seleccionado ejecutamos `select vol N` 

![list vol](/assets/img/8_Reparando-Windows11/9.jpg)

![Select vol](/assets/img/8_Reparando-Windows11/10.jpg)

Ahora salimos de DISKPART ejecutando `exit`, luego entramos a la unidad que acabamos de formatear, eso lo hacemos escribiendo la letra y `:`, en mi caso `F:`, dentro de la unidad vamos a usar la herramienta `bootsect` para reescribir el código de arranque y pueda iniciar windows, para eso ejecutamos `bootsect /nt60 all /force`


![bootsect](/assets/img/8_Reparando-Windows11/11.jpg)

Hasta aquí ya se actualizaron los discos donde va a puntar el código de arranque de MOOTMGR pero falta crear los archivos de arranque para que la pc sepa que SO va a iniciar, para eso ejecutamos `bcdboot C:\windows /s F: /f all`




![bcdboot](/assets/img/8_Reparando-Windows11/12.jpg)

Ahora ejecutamos `exit`, esto nos regresa al menú principal y ahora sí nos aparecen todas las opciones de arranque avanzado y ya podemos seleccionar la opción "salir y continuar con Windows 10".


![DELL](/assets/img/8_Reparando-Windows11/13.jpg)

![Windows](/assets/img/8_Reparando-Windows11/14.jpg)





# Conclusiones

Este error **NUNCA** me había pasado y es relativamente sencillo reparar windows con herramientas que ya trae el propio SO, además de eso, tambien aprendí a tener paciencia y analizar con más detenimiento el error antes de asumir lo peor, en este caso pasar por todo el proceso de recuperar mis archivos, formatear y luego dejar mi lap como me gusta.
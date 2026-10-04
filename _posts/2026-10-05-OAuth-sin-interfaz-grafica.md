---
title: ¿Cómo autenticarse con OAuth sin interfaz gráfica raspberry pi Zero 2W?
date: 2026-10-05 17:00:00 +/-TTTT
categories:
  - How-To
tags:
  - ssh
  - linux
  - networking
  - bash
  - ssh-tunnel
  - codex
  - supabase
---

### Nivel de dificultad: Bajo

# Introducción

La intención de este post es aprender como podemos autenticarnos con OAuth cuando no tenemos una interfaz gráfica o [GUI](https://es.wikipedia.org/wiki/Interfaz_gr%C3%A1fica_de_usuario), todo en un entorno local.

# Problema
Hace unos días estaba usando codex en un proyecto sobre noticias y necesitaba empezar a usar [supabase](https://supabase.com/) como base de datos para los artículos de interés. Este proyecto lo tengo en una Raspberry pi Zero 2W que no tiene un ambiente de escritorio y sólo me conecto por ssh con mi tablet. Todo esto por el bajo consumo energético ;).

Al momento de instalar el pluggin de supabase en Codex, supabase me pide iniciar sesión y darle permisos a codex para manejar las BD y/o proyectos que tenga en mi cuenta, el problema es que codex automáticamente abre un navegador para hacer login y sin interfaz gráfica instalada en mi raspberry, yo no podía darle los permisos por que solo me aparecía esta url y me pedía que la abriera en un navegador.

![codex mcp login](/assets/img/10_OAUth_sin_GUI/1.png)

![[Pasted image 20260816155136.png]]

Como estaba conectado por ssh, intenté abrir el enlace que me mandaba codex en mi tablet, pero en la misma url se puede ver un redirect hacia localhost, es decir, la raspberry. Entonces a pesar de poder abrir el enlace e iniciar sesión en supabase en mi tablet, al momento de autorizar a Codex, el redirect da un error, por otro lado, codex se va a timeout por que nunca recibe respuesta del redirect.


# Solución
## Prerrequisitos

- Una PC/laptop/tablet
- Conocer la IP de la raspberry

Cada que tengo un problema me cuestiono a mí mismo, y en este caso la pregunta fue: ¿Cómo le haré para autenticarme si no tengo interfaz gráfica?

Pensé que la forma más fácil sería con un navegador web por CLI y también pensé cual sería la solución en un entorno productivo controlado o con políticas zero-trust donde es muy dificil poder instalar aplicaciones.

Entonces me replantee la pregunta: ¿De qué forma puedo exponer un "servicio local" de mi raspberry en mi red para que lo vea mi tablet y ahí se mande la respuesta?.
 
Fue así como recordé el [*ssh tunneling, ssh port-forwarding* o túnel ssh para la raza](#) por que vi su uso en el write-up de una máquina de HTB y dije: "vamos a hacerlo de la forma difícil".

Para este caso, lo que hice fue:
1) Solicitar la autenticación de supabase
2) Identificar el puerto en la url
3) Crear el túnel ssh en el mismo puerto
4) Abrir la url en el navegador de mi tablet
5) Autenticarme y autorizar a codex

Para que Codex de la url hay que ejecutar ˋcodex mcp login supabaseˋ, al principio me costó trabajo por que me tardaba en modificar la url original que está  codificada en url encode y no me acordé cuales eran los caracteres codificados, pero con ayuda de cyberchef, copié esta parte de la url:


Decodifiacando tenemos que`%3A` = `:` y `%2F` = `/`y entre estos 2 caracteres viene el puerto, en mi caso fue 34733. Saber esto es necesario para crear el túnel local, y para crearlo usé la siguiente línea de comandos que explicaré con más detalle.

```bash
ssh -L XYZ:127.0.0.1:34733 c04tl@192.168.1.65
```

`-L` le dice a ssh que se trata de un tunel local.
`XYZ` es el puerto donde se espera la respuesta.
`127.0.0.1:34733` le dice a ssh que inicie el tunel en mi tablet por el puerto 34733.
`c04tl@192.168.1.65` es el usuario y la IP de mi raspberry.

Ahora si abro la url en mi tablet, me pedirá iniciar sesión en supabase para autorizar a codex, después de poner nuestras credenciales terminará el proceso y saldrá este mensaje.

![Autenticación completada](/assets/img/10_OAUth_sin_GUI/2.png)

![[Pasted image 20260816181238.png]]


# Validación
Para validar que Codex ya se conectó a Supabase, ejecuté `codex mcp list` y se imprime esta lista confirmando que ya está habilitado y autenticado.

# Errores comunes

Cada que se ejecuta `codex mcp login supabase` la url cambia al igual que el puerto local que espera la respuesta, por eso tienes que confirmar el puerto del túnel.

# Conclusiones
Instalar herramientas de terceros que faciliten este tipo de actividades de autenticación y/o autorización puede ser el camino más facil, sin embargo, en entornos productivos puede resultar muy difícil por las limitaciones como la interfaz gráfica, restricciones de instalación de software y/o auditorias normativas, por lo que esta opción puede resultar útil ya que se usan herramientas nativas del sistema operativo además de crear una conexión de "un solo uso" a través de un canal cifrado. 
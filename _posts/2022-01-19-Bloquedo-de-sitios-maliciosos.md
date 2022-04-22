---
title: Bloquea contenido malicioso con los DNS de  cloudflare
date: 2022-01-19 12:00:00 +/-TTTT
categories: [Tutorial, DIY, Windows, Android]
tags: [DNS, Configuración de red, Bloquedo de Malware]
---

# Introducción

Bienvenidos a este tutorial donde aprenderan a bloquear malware y/o sitios con contenido para adultos al modificar una configuración muy sencilla en los ajustes de red en nuestros dispositivos móviles o computadoras pero primero debemos entender que es un DNS. La siguiente imagen muestra un diagrama sencillo sobre el funcionamiento de un DNS:

![DNS](/assets/img/2_Bloquea_Malware/1.png "Funcionamiento básico de DNS")

1. El cliente hace una consulta al dominio youtube.com
2. el DNS traduce el nombre de dominio a la ip del sitio youtube.com

Un DNS es un sistema que nos facilita la traducción de las feas direcciones IP en nombres de dominios más bonitos para el entendimiento humano, sin embargo, para las máquinas se siguen utilizando las IP's, pero ¿Qué pasaría si visitaramos un sitio con contenido malicioso?. Muy fácil, el DNS nos respondería como lo ha venido haciendo desde tiempos inmemorables ya que los DNS's por defecto no validan si el sitio a resolver a sido catalogado como malicioso, con malware o si se trata de un sitio con contenido para adultos :(.  


Es por esto que en 2008 la empresa CloudFlare dió a conocer su familia de DNS's *1.1.1.1 For Families*, un sistema de resolución de DNS seguro, rápido, gratuito y que prioriza la privacidad para que todos podamos disponer de esta línea de defensa adicional sin restricción alguna. *1.1.1.1 for Families* incluye [sólidas garantías de privacidad](https://developers.cloudflare.com/1.1.1.1/privacy/public-dns-resolver) y tiene la finalidad de bloquear sitios con Malware, Contenido para adultos o bloquear ambos según sean nuestras necesidades.


# ¿Cómo empezar a usarlo?
Para poder usar esta línea de defensa primero debemos elegir la opción que más se adapte a nuestras necesidades:

1. Bloqueo de malware  
	DNS Primario	1.1.1.2  
	DNS Secundario	1.0.0.2

2. Bloqueo de malware y contenido para adultos  
	DNS Primario	1.1.1.3  
	DNS Secundario	1.0.0.3


Una vez que elíjamos una opción, basta con cambiar la configuración de DNS de nuestros nuestros dispositivos. Para ello veremos primero como realizarlo en android y posteriormente en Windows ya que son los dispositivos más comunes entre los usuarios.

## Android

Como primer paso, debemos abrir la configuración de Wi-Fi de nuestro dispositivo al bajar la barra de estado y dejando presionado sobre el ícono de Wi-Fi para después ir a los detalles de la red en la que estemos conectados.  

![Paso 1](/assets/img/2_Bloquea_Malware/2.jpg)


A continuación vamos a cambiar la configuración de IP por una dirección estática que no esté siendo ocupada por otro dispositivo. Recomiendo poner un valor arriba de 100 para estar seguros y no entrar en conflictos de direccionamiento ;).  


Por lo general nuestra Puerta de Enlace o Router tiene la primera dirección de nuestra red (en mi caso *10.0.0.1*) y en longitud de prefijo ponemos 24 o la longitud que tengamos configurada, finalmente, en DNS primario y DNS Secundario ponemos la opción que hayamos elegido, en este ejemplo utilicé el bloqueo de Malware. Con todas estas modificaciones deberiamos tener algo como lo siguiente:  

![Paso 2](/assets/img/2_Bloquea_Malware/3.jpg)

Guardamos los cambios realizados y con esto terminaríamos con la configuración en Android.

## Windows

Para windows debemos empezar haciendo click derecho en el ícono de conexión en la barra de tareas y después seleccionar la opción **Abrir configuración de red e internet**

![Paso 1](/assets/img/2_Bloquea_Malware/4.jpg)

A continuación se abrirá la venta de configuración y seleccionaremos el botón **Propiedades** de la red en la que estemos conectados

![Paso 2](/assets/img/2_Bloquea_Malware/5.jpg)

En la nueva ventana nos desplazaremos hacia abajo hasta encontrar la sección **Configuración de IP** donde seleccionaremos el botón editar y después seleccionaremos la opción Manual del menú desplegable

![Paso 3](/assets/img/2_Bloquea_Malware/6.jpg)


Finalmente activamos el interruptor de IPv4 y al igual que en Android agregamos la dirección IP, Puerta de enlace, longitud del prefijo y, en este caso, los DNS de bloqueo de malware y contenido para adultos, recuerden guardar los cambios antes de salir.

![Paso 4](/assets/img/2_Bloquea_Malware/7.jpg)

Y ¡listo! con estas configuraciones tendremos agregada una capa extra de seguridad para navegar y mantenernos más seguros en la web. Gracias por visitar mi página, espero que te haya sido útil y nos vemos hasta otra publicación ;).

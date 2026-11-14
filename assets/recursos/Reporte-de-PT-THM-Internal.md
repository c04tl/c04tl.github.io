
# Resumen ejecutivo
Este reporte presenta los hallazgos encontrados en la evaluación de seguridad de la máquina Internal de THM.

## Alcance
El alcance definido para la evaluación fue unicamente la dirección IP del equipo **internal.thm**


## Pruebas ejecutadas
El detalle de las pruebas fue  laskdalksjdalksjdaksaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa


## Resultados e indicadores de riesgo
Se encontraron N vulnerabilidades y en la siguiente tabla se muestra el desglose por criticidad/impacto

| Numero de vulnerabilidades | Criticidad |
| -------------------------- | ---------- |
| N                          | Críticas   |
| N                          | Altas      |
| N                          | Medias     |
| N                          | Bajas      |





# Detalle de vulnerabilidades
Se encontraron N vulnerabilidades, con impactos Alto, etc , etc y en la siguiente tabla se muestra el detalle técnico de cada una.


| ID  | Hallazgo                                                                             | Descripción                                                             | CVE | Score CVSS V.3 | CWE                                     | Score OWASP | Criticidad |
| --- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- | --- | -------------- | --------------------------------------- | ----------- | ---------- |
| 01  | Revelación de usuarios y contraseñas válidas en panel de administración de wordpress | el panel de login revela nombres de usuario válidos                     | NA  |                | CWE-204 Observable Response Discrepancy |             | Baja       |
| 02  | Credenciales débiles en panel de administración de wordpress                         | La cuenta de administración utiliza una contraseña común y poco robusta | NA  |                | CWE-1391 Use of Weak Credentials        |             | Alta       |
| 03  | Contraseña en archivo de texto plano                                                 | Se encontró la contraseña para la cuenta **aubreanna**                  | NA  |                | CWE- Plaintext Storage of a password    |             | Alta       |
| 04  | Credenciales débiles en panel de administración de Jenkins                           | La cuenta de administración utiliza una contraseña común y poco robusta | NA  |                | CWE-1391 Use of Weak Credentials        |             | Alta       |
|     |                                                                                      |                                                                         |     |                |                                         |             |            |

### 01 Revelación de usuarios y contraseñas válidas en panel de administración de wordpress

**Descripción de hallazgo:** El panel de administración de wordpress indica cuando un usuario y una contraseña es válido o inválido, lo cual permite enumerar los usuarios registrados que pueden iniciar sesión en el panel con sus respectivas contraseñas.

**Evidencias:** Se intentó iniciar sesión con una lista de usuarios comunes con la herramietna hydra y se obtuvo el siguiente resultado:

> Imagen de pruebas

Con esta prueba se confirmó la existencia del usuario **admin**.

Se intentó iniciar sesión con una lista de contraseñas comunes con la herramietna hydra y se obtuvo el siguiente resultado:

> Imagen de pruebas


**Sugerencias de remediación:**
- Se recomienda mostrar un mensaje genérico que no revele si el usuario ni la contraseña son válidos o inválidos.

**Referencias**
- [CWE-204: Observable Response Discrepancy](https://cwe.mitre.org/data/definitions/204.html)
- Yo Merengues
- Jhonny Bravo
- Yomi Yomi
- Yoplait
- etc.


### 02 Credenciales débiles en panel de administración de wordpress

**Descripción de hallazgo:** La cuenta **admin**, previamente descubierta, cuenta con una contraseña común y poco robusta.

**Evidencias:** Se intentó iniciar sesión con una lista de contraseñas comunes con la herramietna hydra y se obtuvo el siguiente resultado confirmando que la contraseña para el usuario **admin** es la siguiente:

> Imagen de pruebas


**Sugerencias de remediación:**
- Usar contraseñas robustas con una longitud mínima de 12 caracteres y que incluya al menos un valor de la siguiente lista:
	- Número
	- Letra minúscula
	- Letra mayúscula
	- Carácter especial
	- Símbolo


**Referencias**
- [CWE-1391: Use of weak credentials](https://cwe.mitre.org/data/definitions/1391.html)
- Yo Merengues
- Jhonny Bravo
- Yomi Yomi
- Yoplait
- etc.





### 03 Contraseña en archivo de texto plano

**Descripción de hallazgo:** La cuenta **admin**, previamente descubierta, utiliza contraseña común y poco robusta.

**Evidencias:** Se intentó iniciar sesión con una lista de contraseñas comunes con la herramietna hydra y se obtuvo el siguiente resultado confirmando que la contraseña para el usuario **admin** es la siguiente:

> Imagen de pruebas


**Sugerencias de remediación:**
- Usar contraseñas robustas con una longitud mínima de 12 caracteres y que incluya al menos un valor de la siguiente lista:
	- Número
	- Letra minúscula
	- Letra mayúscula
	- Carácter especial
	- Símbolo


**Referencias**
- [CWE-1391: Use of weak credentials](https://cwe.mitre.org/data/definitions/1391.html)
- Yo Merengues
- Jhonny Bravo
- Yomi Yomi
- Yoplait
- etc.

### 04 Credenciales débiles en panel de administración de Jenkins

**Descripción de hallazgo:** La cuenta **admin**, previamente descubierta, cuenta con una contraseña común y poco robusta.

**Evidencias:** Se intentó iniciar sesión con una lista de contraseñas comunes con la herramietna hydra y se obtuvo el siguiente resultado confirmando que la contraseña para el usuario **admin** es la siguiente:

> Imagen de pruebas


**Sugerencias de remediación:**
- Usar contraseñas robustas con una longitud mínima de 12 caracteres y que incluya al menos un valor de la siguiente lista:
	- Número
	- Letra minúscula
	- Letra mayúscula
	- Carácter especial
	- Símbolo


**Referencias**
- [CWE-1391: Use of weak credentials](https://cwe.mitre.org/data/definitions/1391.html)
- Yo Merengues
- Jhonny Bravo
- Yomi Yomi
- Yoplait
- etc.
### Página por defecto de servidor web Apache

**Descripción: Se encontró una página por defecto del servidor web apache versión 2.4.29 en la dirección http://internal.thm, esta página se encuentra en instalaciones por defecto y muestra información del servidor web.**

**Evidencias**
Para esta prueba se utilizó lautilidad Wappalyzer para identificar la tecnología
- Imagen de pruebas
- Imagen de resultado

Para corroborarlo, también se usó curl
- Imagen de pruebas
- Imagen de resultado


´´´bash

´´´

**Sugerencias de remediación:**
- Se recomienda hacer X  en Y

**Referencias**
como evitar XSS --> URL de owasp



# Detalle de pruebas ejecutadas

Para la fase de reconocimiento activo, se ejecutó un escaneo de puertos y servicios con la utilidad nmap y se encontraron 2 servicios expuestos en los puertos 22 y 80 correspondientes a ssh versión 7.6 p1 y apache 2.4.29 respectivamente.

**Evidencia**
>Imagen de evidencia

## Página de administración de Wordpress

Durante la fase de escaneo activo, se descubrió una instalación del X de Y Wordpress en su versión 5.4.2 y se logró encontrar el panel principal de administración protegido por contraseña.

>IMAGEN del  portal

Se ejecutaron pruebas de enumeración 


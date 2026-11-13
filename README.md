# Página de c04tl

Tema propio de Jekyll para [c04tl.github.io](https://c04tl.github.io).

## Publicar un artículo

Crea `_posts/AAAA-MM-DD-nombre.md` con estos metadatos y escribe el cuerpo en Markdown:

```yaml
---
title: Mi artículo
description: Una descripción breve.
categories: [Linux]
tags: [bash]
image: /assets/img/mi-portada.webp
---
```

La fecha se toma del nombre del archivo si no indicas `date`. Puedes definir
`last_modified_at` para mostrar una fecha de actualización explícita. Si omites
`image` o `description`, el tema usa una imagen del artículo o la portada
predeterminada, y un extracto. El tiempo de lectura se estima a 200 palabras
por minuto. Usa encabezados `##` y `###` en el cuerpo para la tabla de contenidos.

## Publicar un recurso

Sube el adjunto a `assets/recursos/` y crea una ficha `_recursos/mi-recurso.md`:

```yaml
---
title: Comandos esenciales de Linux
description: Una referencia rápida para la terminal.
tipo: Cheatsheet
archivo: /assets/recursos/comandos-linux.pdf
---
```

Usa nombres de archivo sin espacios. El tema obtiene el formato y el tamaño
del adjunto. Los recursos aparecen en el catálogo y se pueden buscar por
título, descripción o tipo.

## Vista previa y publicación

Con Ruby 3.3 y Bundler (RubyInstaller con Devkit en Windows), ejecuta:

```sh
bundle install
bundle exec jekyll serve
```

Abre http://localhost:4000. Para verificar una compilación:

```sh
bundle exec jekyll build
bundle exec ruby tools/check-site.rb
```

Al activar el nuevo flujo por primera vez, selecciona **GitHub Actions** en
**Settings → Pages → Build and deployment → Source**. Después, cada cambio
integrado en `main` compila, valida y publica el sitio automáticamente.
Las solicitudes de cambios se validan sin publicar.

El menú está en `_data/navigation.yml`, la paleta en `_sass/_theme.scss`
y las plantillas en `_layouts/` y `_includes/`.

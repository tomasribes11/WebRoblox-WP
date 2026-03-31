# Guía de WordPress para Tomás

Hola Tomás! Este documento te explica cómo funciona el sitio web **Mundo Roblox** y cómo puedes gestionarlo tú mismo usando el panel de administración de WordPress. No necesitas saber programar para hacer casi todo.

---

## ¿Qué es WordPress?

WordPress es como el "cerebro" del sitio web. Es un programa que te permite crear y gestionar páginas web sin tener que escribir código. La mayoría de sitios web del mundo lo usan.

El sitio tiene dos partes:

- **La parte pública** — Lo que ven los visitantes: [http://localhost:8080](http://localhost:8080)
- **El panel de administración** — La "cocina" del sitio, donde tú gestionas todo: [http://localhost:8080/wp-admin](http://localhost:8080/wp-admin)

---

## Cómo entrar al panel de administración

1. Abre el navegador (Chrome, Firefox, Edge, lo que uses)
2. Escribe en la barra de direcciones: `http://localhost:8080/wp-admin`
3. Escribe el usuario: **admin**
4. Escribe la contraseña: **admin123**
5. Haz clic en **Acceder**

Ya estás dentro! Verás un menú a la izquierda con todas las opciones.

---

## Cómo escribir un artículo nuevo

Los artículos son las "noticias" o "guías" que aparecen en la página principal del sitio.

### Pasos para crear un artículo:

**1.** En el menú de la izquierda, haz clic en **Entradas**

**2.** Haz clic en **Añadir nueva entrada**

**3.** Escribe el **título** del artículo (la frase grande que se ve en la tarjeta)

**4.** En el área grande de abajo, escribe el **contenido** del artículo. Es como escribir en Word — puedes poner texto, imágenes, listas...

**5.** En el panel de la derecha, busca **Categoría** y elige una:
   - **Trucos** — para consejos y secretos del juego
   - **Guías** — para tutoriales paso a paso
   - **Noticias** — para novedades de Roblox

**6.** En el panel de la derecha, busca **Extracto** (puede que tengas que hacer scroll hacia abajo) y escribe una frase corta que describa el artículo. Esta frase aparece debajo del título en la tarjeta.

**7.** Para añadir una **imagen** al artículo, busca **Imagen destacada** en el panel de la derecha, haz clic en "Establecer imagen destacada" y sube una foto desde tu ordenador.

**8.** Cuando tengas todo listo, haz clic en el botón azul **Publicar** (arriba a la derecha)

¡Listo! El artículo aparecerá en el sitio web.

---

## Cómo editar un artículo que ya existe

**1.** En el menú izquierdo, haz clic en **Entradas > Todas las entradas**

**2.** Verás una lista de todos los artículos. Busca el que quieres cambiar.

**3.** Pasa el ratón por encima del título — aparecerá un menú con opciones. Haz clic en **Editar**.

**4.** Cambia lo que necesites (título, texto, imagen...)

**5.** Haz clic en **Actualizar** (botón azul arriba a la derecha)

---

## Cómo borrar un artículo

**1.** Ve a **Entradas > Todas las entradas**

**2.** Pasa el ratón por encima del artículo que quieres borrar

**3.** Haz clic en **Papelera**

> El artículo no se borra del todo enseguida — va a la papelera. Si te arrepientes, puedes recuperarlo. Para borrarlo definitivamente, haz clic en **Papelera** (en el menú de la izquierda, dentro de Entradas) y luego en **Vaciar papelera**.

---

## Los idiomas del sitio

El sitio funciona en tres idiomas: Español 🇪🇸, Inglés 🇬🇧 y Francés 🇫🇷. Cuando creas un artículo en español, tienes la opción de crear también las versiones en inglés y francés.

### Cómo crear la versión en inglés de un artículo:

**1.** Ve a **Entradas > Todas las entradas**

**2.** Fíjate en las columnas de la derecha. Verás tres banderas pequeñas 🇪🇸 🇬🇧 🇫🇷

**3.** Si una bandera tiene un **+** debajo, significa que ese artículo no tiene traducción en ese idioma todavía

**4.** Haz clic en el **+** de la bandera del inglés 🇬🇧

**5.** Se abrirá un editor nuevo, ya enlazado al artículo original. Escribe el título y contenido en inglés.

**6.** Haz clic en **Publicar**

Ahora cuando alguien cambie el idioma del sitio a inglés, verá la versión inglesa de ese artículo.

---

## Cómo ver y gestionar los usuarios registrados

Los visitantes del sitio pueden crear una cuenta (registrarse). Tú puedes ver quién se ha registrado:

**1.** En el menú izquierdo, haz clic en **Usuarios > Todos los usuarios**

**2.** Verás una lista con todos los usuarios: el admin (tú) y los que se han registrado

**3.** Si quieres cambiar algo de un usuario (como su contraseña o nombre), haz clic en su nombre

---

## Cambiar el título del sitio o tu contraseña

### Cambiar el título del sitio:
**1.** Ve a **Ajustes > Generales**
**2.** Cambia el campo **Título del sitio**
**3.** Haz clic en **Guardar cambios**

### Cambiar tu contraseña de administrador:
**1.** Haz clic en tu nombre de usuario arriba a la derecha (o ve a **Usuarios > Tu perfil**)
**2.** Baja hasta la sección **Gestión de cuenta**
**3.** Haz clic en **Generar contraseña** o escribe una nueva
**4.** Haz clic en **Actualizar perfil**

---

## Arrancar y parar el sitio

El sitio funciona dentro de **Docker** (un programa que crea "cajitas virtuales" donde vive el sitio web). Para que el sitio funcione, Docker tiene que estar arrancado.

### Para arrancar el sitio:

Abre una terminal (en Mac: busca "Terminal"; en Windows: busca "PowerShell" o "Git Bash") y escribe:

```
make up
```

Espera unos segundos y ya puedes abrir el navegador en `http://localhost:8080`.

### Para parar el sitio:

```
make down
```

### Si algo va mal y quieres ver qué está pasando:

```
make logs
```

Verás mensajes técnicos. Si algo está rojo o dice "Error", cuéntaselo a tu padre para que lo revise.

---

## Cosas que NO debes tocar (a menos que estés seguro)

Estas secciones del panel de administración son para configuraciones avanzadas. Si las cambias sin saber bien qué haces, el sitio puede dejar de funcionar:

- **Apariencia > Editor de temas** — Aquí está el código del diseño del sitio
- **Plugins** — Los programas que añaden funcionalidades (como Polylang, que gestiona los idiomas)
- **Ajustes > Permalinks** — La estructura de las URLs del sitio
- **Herramientas** — Opciones de importar/exportar datos

Si tienes curiosidad sobre alguna de estas secciones, pregúntale a tu padre primero.

---

## Resumen rápido

| Quiero... | Voy a... |
|-----------|----------|
| Crear un artículo nuevo | Entradas > Añadir nueva entrada |
| Editar un artículo | Entradas > Todas las entradas > Editar |
| Borrar un artículo | Entradas > Todas las entradas > Papelera |
| Ver los usuarios | Usuarios > Todos los usuarios |
| Cambiar el título del sitio | Ajustes > Generales |
| Cambiar mi contraseña | Usuarios > Tu perfil |
| Ver el sitio como visitante | Abrir http://localhost:8080 |
| Arrancar el sitio | Escribir `make up` en la terminal |
| Parar el sitio | Escribir `make down` en la terminal |

---

¡Mucha suerte con el sitio, Tomás! Si algo no funciona como esperas o tienes dudas, es normal — aprender a gestionar webs lleva su tiempo. Lo estás haciendo genial.

# Mundo Roblox — WordPress Edition

Versión WordPress del sitio **Mundo Roblox**: artículos sobre trucos, guías y noticias de Roblox en tres idiomas (ES/EN/FR), completamente dockerizada y lista para arrancar con un solo comando.

---

## Índice

1. [Requisitos](#requisitos)
2. [Instalación y primer arranque](#instalación-y-primer-arranque)
3. [Uso diario](#uso-diario)
4. [Funcionalidades del sitio](#funcionalidades-del-sitio)
5. [Panel de administración](#panel-de-administración)
6. [Estructura del proyecto](#estructura-del-proyecto)
7. [Comandos de desarrollo](#comandos-de-desarrollo)
8. [Producción](#producción)
9. [Solución de problemas](#solución-de-problemas)

---

## Requisitos

- **Docker Desktop** instalado y en ejecución (Mac o Windows)
- **Make** (incluido en Mac; en Windows usar WSL2 o Git Bash)
- Puerto **8080** libre en el host (el sitio corre ahí)
- Puerto **3307** libre en el host (MySQL, solo para desarrollo)

> Si tienes el proyecto Laravel/React de Mundo Roblox corriendo en paralelo no hay conflicto: este proyecto usa puertos distintos (8080 y 3307 en vez de 80 y 3306).

---

## Instalación y primer arranque

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd WebRoblox-WP
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
```

Edita `.env` si quieres cambiar las credenciales. Los valores por defecto funcionan para desarrollo local:

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `WP_HOME` | `http://localhost:8080` | URL pública del sitio |
| `WP_ADMIN_USER` | `admin` | Usuario del panel WordPress |
| `WP_ADMIN_PASSWORD` | `admin123` | Contraseña del panel |
| `MYSQL_PASSWORD` | `wppassword` | Contraseña del usuario de BD |

### 3. Ejecutar el setup completo

```bash
make setup
```

Este comando:
1. Construye la imagen Docker de PHP (instala extensiones `intl` y cliente MySQL)
2. Arranca los contenedores nginx, php-fpm y MySQL
3. Espera a que MySQL esté completamente inicializado
4. Descarga e instala WordPress core automáticamente
5. Instala y activa el plugin **Polylang** (multiidioma)
6. Activa el tema **webroblox**
7. Crea los 3 idiomas: Español (default), English, Français
8. Crea las 3 categorías en los 3 idiomas y las enlaza como traducciones
9. Genera 15 artículos de ejemplo (5 por categoría × 3 idiomas) con sus traducciones enlazadas
10. Inicializa el contador de visitas de cada artículo a 0

El proceso tarda entre **2 y 5 minutos** (la primera vez descarga las imágenes Docker).

### 4. Verificar que funciona

Abre el navegador en:

- **Sitio:** [http://localhost:8080](http://localhost:8080)
- **Admin:** [http://localhost:8080/wp-admin](http://localhost:8080/wp-admin)
  - Usuario: `admin` / Contraseña: `admin123` (o los que pusiste en `.env`)

---

## Uso diario

Una vez instalado, no hace falta volver a ejecutar `make setup`. Usa:

```bash
make up       # Arrancar el sitio
make down     # Parar el sitio
make logs     # Ver logs en tiempo real (Ctrl+C para salir)
```

El sitio arranca en **segundos** porque los datos persisten en volúmenes Docker.

---

## Funcionalidades del sitio

### Multiidioma (ES / EN / FR)

El sitio está completamente traducido usando el plugin **Polylang**. Desde la barra de navegación superior se puede cambiar de idioma con las banderas 🇪🇸 🇬🇧 🇫🇷. Al cambiar, los artículos, categorías y toda la interfaz se muestran en el idioma seleccionado.

Los artículos de cada idioma están enlazados entre sí como traducciones: si estás leyendo un artículo en español y cambias al inglés, WordPress te lleva a la versión inglesa del mismo artículo.

### Tema oscuro / claro

El sitio carga en **modo oscuro** por defecto. El botón 🌙/☀️ en la barra de navegación alterna entre tema oscuro y claro. La preferencia se guarda en el navegador (localStorage) y persiste entre visitas y recargas.

El cambio de tema se aplica **instantáneamente** sin parpadeo gracias a que el script de detección se ejecuta antes de que el navegador pinte la página.

### Categorías

| Español | English | Français | Contenido |
|---------|---------|----------|-----------|
| Trucos | Tricks | Astuces | Consejos y secretos del juego |
| Guías | Guides | Guides | Tutoriales paso a paso |
| Noticias | News | Actualités | Últimas novedades de Roblox |

### Contador de visitas

Cada artículo muestra el número de visitas únicas. El sistema usa una cookie de 1 hora por artículo: si recargas la página el contador no se incrementa. Si abres el mismo artículo desde otro navegador o en modo incógnito, sí cuenta como nueva visita.

### Autenticación de usuarios

Los lectores pueden registrarse e iniciar sesión usando el sistema nativo de WordPress:

- **Registro:** botón "Registrarse" en la barra de navegación → `/wp-register.php`
- **Login:** botón "Iniciar sesión" → `/wp-login.php`
- **Logout:** enlace "Salir" visible cuando hay sesión activa
- Al iniciar sesión, la barra muestra "Hola, [nombre de usuario]"

### Diseño responsive

El sitio se adapta a móvil, tablet y escritorio. En pantallas pequeñas la barra de navegación se colapsa en un menú hamburguesa. Los artículos se muestran en grid de 1, 2 o 3 columnas según el ancho de pantalla.

---

## Panel de administración

Acceso: [http://localhost:8080/wp-admin](http://localhost:8080/wp-admin)

Desde el panel de administración de WordPress puedes:

### Gestionar artículos
- **Entradas > Todas las entradas** — Ver, editar y borrar artículos
- **Entradas > Añadir nueva** — Crear un artículo nuevo
  - Seleccionar categoría en el panel lateral derecho
  - Añadir imagen destacada (aparece en la tarjeta del listado)
  - El campo "Extracto" se usa como subtítulo en la vista de artículo
  - En la columna "Idioma" (Polylang) se indica el idioma del artículo

### Gestionar traducciones con Polylang
- Desde la lista de entradas, cada artículo muestra iconos de bandera. Haz clic en el icono del idioma para crear/editar la traducción.
- **Idiomas** (menú lateral) — Gestionar los idiomas activos del sitio

### Gestionar categorías
- **Entradas > Categorías** — Ver categorías. Polylang añade una columna de idioma y permite enlazar las categorías como traducciones entre sí.

### Gestionar usuarios
- **Usuarios > Todos los usuarios** — Ver y editar usuarios registrados
- **Usuarios > Añadir nuevo** — Crear usuarios manualmente

### Ajustes generales
- **Ajustes > Generales** — Título del sitio, email del admin
- **Ajustes > Lectura** — Configurar qué página es la portada
- **Ajustes > Permalinks** — Estructura de URLs (configurada como `/%category%/%postname%/`)

---

## Estructura del proyecto

```
WebRoblox-WP/
├── .env.example              ← Variables de entorno (copiar a .env)
├── .gitignore
├── Makefile                  ← Comandos de desarrollo
├── docker-compose.yml        ← Stack de desarrollo
├── docker-compose.prod.yml   ← Overrides de producción
│
├── docker/
│   ├── nginx/
│   │   ├── nginx.dev.conf    ← Configuración nginx desarrollo
│   │   └── nginx.prod.conf   ← Configuración nginx producción
│   ├── php/
│   │   ├── Dockerfile        ← wordpress:php8.2-fpm + intl + mysql-client
│   │   └── php.ini           ← Límites de memoria/upload, opcache
│   └── mysql/
│       └── my.cnf            ← utf8mb4, innodb_buffer_pool
│
├── scripts/
│   ├── setup-wp.sh           ← Setup automático con wp-cli (idempotente)
│   └── wait-for-mysql.sh     ← Polling hasta que MySQL acepta conexiones
│
└── wp-content/
    ├── themes/
    │   └── webroblox/        ← ÚNICO directorio rastreado en git
    │       ├── style.css
    │       ├── functions.php
    │       ├── front-page.php
    │       ├── archive.php
    │       ├── single.php
    │       ├── 404.php
    │       ├── header.php
    │       ├── footer.php
    │       ├── inc/          ← Módulos PHP del tema
    │       ├── template-parts/ ← Componentes HTML reutilizables
    │       └── assets/       ← CSS y JS propios
    └── plugins/              ← Ignorado en git (instalado por wp-cli)
```

> **Nota importante:** El core de WordPress, los plugins y wp-config.php **no están en git**. Se descargan e instalan automáticamente dentro del volumen Docker `wp_wordpress_data` al ejecutar `make setup`. Solo el tema personalizado `webroblox` está versionado.

---

## Comandos de desarrollo

```bash
# Setup y ciclo de vida
make setup          # Primera instalación completa
make up             # Arrancar contenedores
make down           # Parar contenedores
make logs           # Logs en tiempo real de todos los servicios
make logs-nginx     # Logs solo de nginx
make logs-php       # Logs solo de PHP/WordPress

# WordPress CLI
make wp-shell                         # Terminal interactiva con wp-cli
make wp-cmd CMD="post list"           # Listar artículos
make wp-cmd CMD="plugin list"         # Listar plugins instalados
make wp-cmd CMD="option get siteurl"  # Ver URL del sitio
make wp-cmd CMD="cache flush"         # Limpiar caché

# Acceso a contenedores
make php-shell      # Bash en el contenedor PHP-FPM
make db-shell       # MySQL shell (acceso directo a la BD)

# Limpieza (destructivo)
make clean          # Para contenedores y borra TODOS los volúmenes (incluida la BD)
make reset          # clean + setup completo desde cero
```

---

## Producción

Para desplegar en producción, usa el override de compose que:
- Cambia la configuración de nginx por la versión de producción
- Elimina la exposición del puerto MySQL al host (solo accesible internamente)
- Desactiva `WORDPRESS_DEBUG`

```bash
make up-prod
# equivalente a:
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Antes de desplegar en producción:
1. Cambiar `WP_HOME` y `WP_SITEURL` en `.env` a la URL real del servidor
2. Usar contraseñas seguras en todas las variables de `.env`
3. Asegurarse de que el servidor tiene los puertos 80/443 abiertos y redirigir mediante un proxy externo si es necesario

---

## Solución de problemas

### El setup se queda esperando a MySQL

MySQL necesita tiempo para inicializarse la primera vez (crear usuario, base de datos). El script espera automáticamente hasta que el usuario `wpuser` puede conectarse. Si tarda más de 3-4 minutos, ejecuta:

```bash
make logs   # Buscar errores en los logs de mysql
```

### El sitio no carga tras `make up`

Verifica que los contenedores están corriendo:
```bash
docker compose ps
```
Todos deben estar en estado `running` o `healthy`.

### Polylang no muestra las traducciones correctamente

Entra al panel de admin → **Idiomas** y verifica que los 3 idiomas están activos. Si hay artículos sin traducción enlazada, ve a **Entradas**, selecciona el artículo y usa los iconos de bandera de Polylang para enlazar las traducciones.

### Perder datos / empezar de cero

```bash
make reset   # ⚠️ Borra todo y reinstala desde cero
```

### Acceder a la base de datos directamente

```bash
make db-shell
# Una vez dentro:
USE webroblox_wp;
SELECT ID, post_title, post_status FROM wp_posts WHERE post_type='post';
```

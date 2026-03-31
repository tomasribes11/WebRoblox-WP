# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Comandos de desarrollo

```bash
# Primera vez (destruye y recrea todo)
make setup          # build + docker compose up + wp-cli setup automático

# Uso diario
make up             # docker compose up -d
make down           # docker compose down
make logs           # docker compose logs -f
make logs-nginx     # logs solo de nginx
make logs-php       # logs solo de php-fpm

# WordPress CLI
make wp-shell                      # bash interactivo con wp-cli
make wp-cmd CMD="post list"        # ejecutar cualquier comando wp
make wp-cmd CMD="plugin list"
make wp-cmd CMD="option get siteurl"

# Contenedores
make php-shell      # bash en php-fpm
make db-shell       # MySQL shell

# Limpieza
make clean          # ⚠️ docker compose down -v (borra BD y volúmenes)
make reset          # clean + setup desde cero
```

Acceso: `http://localhost:8080` | Admin: `http://localhost:8080/wp-admin`
Credenciales admin por defecto: `admin` / `admin123` (ver `.env`)

## Arquitectura

Stack WordPress tradicional dockerizado. PHP genera HTML server-side — no hay frontend SPA separado.

```
[browser] → nginx:8080
               ├── *.php        → fastcgi_pass php-fpm:9000
               ├── /wp-content/ → archivos estáticos
               └── /*           → try_files → /index.php?$args (WP routing)

nginx:8080  → puerto alternativo (coexiste con proyecto Laravel en :80)
mysql:3307  → puerto alternativo (coexiste con proyecto Laravel en :3306)
```

### Servicios Docker

| Servicio | Imagen | Rol |
|----------|--------|-----|
| `nginx` | nginx:1.25-alpine | Proxy reverso, archivos estáticos |
| `php-fpm` | build: `docker/php/` | WordPress runtime (PHP 8.2-fpm + intl) |
| `mysql` | mysql:8.0 | Base de datos |
| `wp-cli` | wordpress:cli-php8.2 | Setup one-shot (`profiles: ["setup"]`) |

El contenedor `wp-cli` usa `profiles: ["setup"]` — **no arranca con `docker compose up`**, solo con `make setup` o `docker compose run --rm wp-cli`.

### Volúmenes y red

- `wp_wordpress_data` — core WordPress en `/var/www/html` (compartido nginx + php-fpm + wp-cli)
- `wp_mysql_data` — datos MySQL
- `wp_uploads` — `/var/www/html/wp-content/uploads`
- Red: `webroblox_wp_net` (aislada del proyecto Laravel)

Solo `wp-content/themes/webroblox/` está rastreado en git. Plugins, uploads, wp-config.php y el core de WordPress **se generan en runtime** dentro del volumen `wp_wordpress_data`.

## Tema `webroblox`

Localización: `wp-content/themes/webroblox/`

`functions.php` solo hace `require` de los módulos en `inc/`:

| Módulo | Responsabilidad |
|--------|----------------|
| `inc/setup.php` | `after_setup_theme`: title-tag, thumbnails, image size `article-card` |
| `inc/enqueue.php` | Bootstrap 5.3 CDN + `theme.css` + `theme.js` (en `<head>`, no footer) |
| `inc/view-count.php` | Hook `wp`: incrementa `_view_count` post meta, cookie `wr_viewed_{ID}` 1h anti-recarga |
| `inc/polylang.php` | Helpers Polylang: `webroblox_current_lang()`, `webroblox_language_switcher_data()`, `webroblox_category_link($slug)` |
| `inc/custom-queries.php` | `webroblox_articles_query()`, `webroblox_featured_articles_query()` wrapping WP_Query |

### Dark/Light theme

`header.php` renderiza `<html data-bs-theme="dark">` como default server-side. `theme.js` se carga en `<head>` (no footer) como IIFE: lee `localStorage('wr_theme')` y aplica el atributo **antes del primer paint** para evitar flash. Bootstrap 5.3 responde automáticamente al atributo `data-bs-theme`.

### Polylang i18n

- 3 idiomas: `es` (default), `en`, `fr`
- 3 categorías × 3 traducciones, enlazadas con `wp pll term save_translations`
- 15 artículos (5/categoría × 3 idiomas), enlazados con `wp pll post save_translations`
- `webroblox_category_link('trucos')` resuelve el slug traducido según idioma actual mediante mapa hardcodeado en `inc/polylang.php`
- Todas las funciones Polylang comprueban `function_exists('pll_*')` — el tema funciona sin el plugin

### Plantillas de página

| Archivo | Ruta |
|---------|------|
| Home (hero + 6 artículos) | `front-page.php` |
| Archivo por categoría | `archive.php` |
| Artículo individual | `single.php` |
| Fallback | `index.php` |
| 404 | `404.php` |
| Partials | `template-parts/article-card.php`, `hero.php`, `pagination.php`, `language-switcher.php`, `theme-toggle.php` |

## Setup automático (`scripts/setup-wp.sh`)

Idempotente (verifica `wp core is-installed` antes de instalar). Flujo:

1. Esperar MySQL via `wait-for-mysql.sh` (usa `mysqli_connect` con credenciales de app)
2. `wp core install` → permalinks `/%category%/%postname%/` → `users_can_register=1`
3. Instalar y activar Polylang → activar tema `webroblox`
4. Crear 3 idiomas → 3 categorías × 3 traducciones → 15 artículos × 3 locales
5. Inicializar `_view_count = 0` en cada artículo → eliminar posts de muestra → flush rewrites

## Variables de entorno

Copiar `.env.example` a `.env` antes del primer `make setup` (el Makefile lo hace automáticamente).

Variables clave:
- `WORDPRESS_DB_HOST`, `WORDPRESS_DB_USER`, `WORDPRESS_DB_PASSWORD`, `WORDPRESS_DB_NAME` — conexión WordPress
- `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` — inicialización MySQL
- `WP_HOME`, `WP_SITEURL` — deben coincidir con el puerto expuesto (`http://localhost:8080`)
- `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD` — credenciales del panel `/wp-admin`

---
description: Desarrollo diario del tema y contenido WordPress
---

# Workflow: Desarrollo Diario

Este workflow te ayuda en el día a día del desarrollo del sitio WordPress.

## Arranque y parada:

1. **Arrancar el sitio**
   ```bash
   make up
   ```
   // turbo

2. **Verificar que funciona**
   Abre http://localhost:8080 en el navegador

3. **Parar el sitio**
   ```bash
   make down
   ```

## Desarrollo del tema:

1. **Editar archivos del tema**
   Los archivos del tema están en `wp-content/themes/webroblox/`
   - `style.css` - Estilos principales
   - `functions.php` - Funcionalidades PHP
   - `template-parts/` - Componentes reutilizables
   - `assets/` - CSS y JS adicionales

2. **Recargar cambios**
   Los cambios en PHP se reflejan automáticamente
   Para cambios CSS/JS, recarga el navegador (Ctrl+F5)

## Gestión de contenido:

1. **Acceder al panel de administración**
   URL: http://localhost:8080/wp-admin
   Login: admin / admin123

2. **Comandos WP-CLI útiles**
   ```bash
   make wp-cmd CMD="post list"              # Listar artículos
   make wp-cmd CMD="user list"               # Listar usuarios  
   make wp-cmd CMD="plugin list"             # Listar plugins
   make wp-cmd CMD="cache flush"             # Limpiar caché
   ```

## Debug y logs:

1. **Ver logs en tiempo real**
   ```bash
   make logs           # Todos los servicios
   make logs-nginx     # Solo nginx
   make logs-php       # Solo PHP/WordPress
   ```

2. **Acceder a los contenedores**
   ```bash
   make php-shell      # Terminal en contenedor PHP
   make db-shell       # Terminal MySQL
   ```

## Multiidioma con Polylang:

1. **Crear traducciones**
   - En el panel admin → Entradas → Todas las entradas
   - Usa los iconos de bandera para crear traducciones
   - Los idiomas configurados: ES 🇪🇸, EN 🇬🇧, FR 🇫🇷

2. **Verificar estructura de idiomas**
   ```bash
   make wp-cmd CMD="language list"
   ```

## Producción:

Para desplegar en producción:
```bash
make up-prod
```

## Problemas comunes:

- **El sitio no carga**: Ejecuta `make logs` para ver errores
- **MySQL no responde**: Espera unos minutos o ejecuta `make down && make up`
- **Permisos de archivos**: Los cambios se sincronizan automáticamente vía volúmenes Docker

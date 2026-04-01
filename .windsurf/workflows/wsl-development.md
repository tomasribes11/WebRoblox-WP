---
description: Guía de desarrollo en entorno WSL + Docker
---

# Workflow: Desarrollo WSL + Docker

Guía completa para desarrollar el proyecto WordPress en entorno WSL con Docker integration.

## Configuración del Entorno

### Terminal WSL en Windsurf
- **Shell**: WSL Ubuntu
- **Directorio por defecto**: `/home/tomasribes11/projects/web-roblox-wp`
- **Comandos disponibles**: make, docker, git, wp-cli

### Rutas Importantes
- **WSL**: `/home/tomasribes11/projects/web-roblox-wp`
- **Windows**: `\\wsl.localhost\Ubuntu\home\tomasribes11\projects\web-roblox-wp`
- **Docker volúmenes**: Montados automáticamente desde WSL

## Flujo de Desarrollo

### 1. Inicio del Día
```bash
# Desde Windsurf terminal (WSL)
make up
# o
./.windsurf/scripts/docker-helper.sh start

# Verificar estado
./.windsurf/scripts/docker-helper.sh status
```

### 2. Desarrollo de Temas
```bash
# Acceder a contenedor PHP para testing
./.windsurf/scripts/docker-helper.sh php-shell

# Dentro del contenedor, verificar archivos
ls -la wp-content/themes/webroblox/
```

### 3. Operaciones WordPress
```bash
# WP-CLI para gestión de contenido
./.windsurf/scripts/docker-helper.sh wp-shell

# Ejemplos de comandos WP:
wp plugin list --allow-root
wp theme activate webroblox --allow-root
wp post list --allow-root
```

### 4. Base de Datos
```bash
# Acceso MySQL para debugging
./.windsurf/scripts/docker-helper.sh db-shell

# Queries útiles:
SHOW TABLES;
SELECT * FROM wp_posts LIMIT 5;
```

## Operaciones IA Seguras

### Comandos Permitidos para Cascade:
- `make` - Comandos del Makefile
- `docker compose` - Operaciones Docker básicas
- `git` - Control de versiones
- `ls`, `cat`, `grep` - Operaciones de archivo
- `./.windsurf/scripts/docker-helper.sh` - Scripts helper

### Operaciones de Archivos:
- **Edición segura**: Archivos en `wp-content/themes/`, `docker/`, `scripts/`
- **Lectura**: Todo el proyecto
- **Escritura restringida**: No modificar `.env` sin confirmación

### Acceso a Contenedores:
```bash
# Operaciones seguras dentro de contenedores
docker compose exec php-fpm ls -la /var/www/html
docker compose exec php-fpm cat wp-config.php
docker compose run --rm wp-cli wp cache flush --allow-root
```

## Debugging y Troubleshooting

### Logs y Monitorización:
```bash
# Logs en tiempo real
./.windsurf/scripts/docker-helper.sh logs

# Logs específicos
./.windsurf/scripts/docker-helper.sh logs php-fpm
./.windsurf/scripts/docker-helper.sh logs nginx
```

### Problemas Comunes WSL:
1. **Permisos de archivos**: Asegurar UID/GID correctos
2. **Docker daemon**: Verificar Docker Desktop ejecutándose
3. **Integración WSL**: Activar en Docker Desktop settings
4. **Rutas**: Usar rutas WSL, no Windows

### Verificación de Entorno:
```bash
# Verificar configuración
echo $WSL_DISTRO_NAME
docker version
groups | grep docker
pwd  # Debe ser /home/tomasribes11/projects/web-roblox-wp
```

## Best Practices

### Desarrollo Eficiente:
1. **Usar scripts helper**: Facilitan operaciones comunes
2. **Mantener terminal WSL**: Evita problemas de rutas
3. **Verificar contenedores**: Antes de hacer cambios
4. **Backup .env**: Antes de modificaciones

### Seguridad:
1. **No exponer credenciales**: En commits o logs
2. **Usar comandos seguros**: Los definidos en workspace.json
3. **Verificar permisos**: Antes de operaciones críticas
4. **Logs sensibles**: Evitar mostrar passwords

### Rendimiento:
1. **Evitar rebuilds**: Usar `make up` en lugar de `make setup`
2. **Caché Docker**: Aprovechar capas existentes
3. **Monitoreo recursos**: WSL + Docker consume memoria

## Comandos de Emergencia

### Reset Completo:
```bash
# Limpiar todo y empezar de cero
./.windsurf/scripts/docker-helper.sh clean
make setup
```

### Recuperación:
```bash
# Si contenedores no responden
docker compose down
docker compose up -d

# Si hay problemas de red
docker network prune
docker compose up -d
```

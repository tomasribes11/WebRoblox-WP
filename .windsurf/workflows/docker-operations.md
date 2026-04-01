---
description: Operaciones Docker comunes para el proyecto WordPress
---

# Workflow: Operaciones Docker

Este workflow facilita las operaciones comunes con Docker para el proyecto WebRoblox-WP en entorno WSL.

## Comandos Rápidos

### Gestión de Contenedores
```bash
# Iniciar todos los servicios
./.windsurf/scripts/docker-helper.sh start

# Detener todos los servicios  
./.windsurf/scripts/docker-helper.sh stop

# Reiniciar servicios
./.windsurf/scripts/docker-helper.sh restart

# Ver estado de contenedores
./.windsurf/scripts/docker-helper.sh status
```

### Acceso a Shells
```bash
# Shell en contenedor PHP
./.windsurf/scripts/docker-helper.sh php-shell

# Shell MySQL
./.windsurf/scripts/docker-helper.sh db-shell

# Shell WP-CLI
./.windsurf/scripts/docker-helper.sh wp-shell
```

### Logs y Debugging
```bash
# Logs de todos los servicios
./.windsurf/scripts/docker-helper.sh logs

# Logs de un servicio específico
./.windsurf/scripts/docker-helper.sh logs nginx
./.windsurf/scripts/docker-helper.sh logs php-fpm
./.windsurf/scripts/docker-helper.sh logs mysql
```

### Mantenimiento
```bash
# Setup completo desde cero
./.windsurf/scripts/docker-helper.sh setup

# Limpieza completa (cuidado: elimina datos)
./.windsurf/scripts/docker-helper.sh clean
```

## Operaciones IA Comunes

### Para Cascade/IA Assistant:
- **Archivos de tema**: `wp-content/themes/webroblox/`
- **Configuración Docker**: `docker/`
- **Scripts**: `scripts/`
- **Variables de entorno**: `.env`

### Comandos seguros para IA:
```bash
make up
make down
make logs
docker compose exec php-fpm bash
docker compose run --rm wp-cli wp --allow-root --path=/var/www/html
```

## Troubleshooting

### Problemas Comunes:
1. **Permisos denegados**: Ejecutar con usuario correcto en WSL
2. **Docker no disponible**: Verificar Docker Desktop ejecutándose
3. **Puertos en uso**: Verificar que 8080 y 3307 estén libres
4. **Volúmenes corruptos**: Ejecutar `docker compose down -v` y luego `make setup`

### Verificación:
```bash
# Verificar integración WSL-Docker
docker version
docker compose version

# Verificar permisos
groups | grep docker
```

## URLs de Acceso
- **Sitio**: http://localhost:8080
- **Admin**: http://localhost:8080/wp-admin
- **Login**: admin / admin123 (configurable en .env)

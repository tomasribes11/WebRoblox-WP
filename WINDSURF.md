# Mundo Roblox WordPress - Guía para Windsurf

Este proyecto WordPress ha sido preparado para funcionar perfectamente en el ecosistema Windsurf.

## 🚀 Configuración Rápida

### Requisitos Previos
- **Docker Desktop** instalado y en ejecución ✅ (Detectado: Docker v29.3.1)
- **Git Bash** o **WSL2** para comandos `make` (Windows no incluye make por defecto)

### Primer Arranque

1. **Abrir terminal en Windsurf**
   - Usa `Ctrl+J` o el terminal integrado
   - Asegúrate de estar en el directorio del proyecto

2. **Ejecutar el workflow de setup**
   ```bash
   /setup
   ```
   O manualmente:
   ```bash
   cp .env.example .env
   docker compose up -d --build
   docker compose run --rm wp-cli sh /scripts/setup-wp.sh
   ```

3. **Verificar instalación**
   - Sitio: http://localhost:8080
   - Admin: http://localhost:8080/wp-admin (admin/admin123)

## 📋 Comandos Esenciales

| Comando | Descripción |
|---------|-------------|
| `make up` | Arrancar contenedores |
| `make down` | Parar contenedores |
| `make logs` | Ver logs en tiempo real |
| `make wp-shell` | Terminal WP-CLI |
| `make db-shell` | Terminal MySQL |

> **Nota para Windows**: Si `make` no funciona, usa los comandos Docker directamente:
> ```bash
> docker compose up -d          # en lugar de make up
> docker compose down           # en lugar de make down
> docker compose logs -f        # en lugar de make logs
> ```

## 🎯 Desarrollo en Windsurf

### Estructura del Proyecto
- `wp-content/themes/webroblox/` - Tema personalizado
- `docker/` - Configuración Docker
- `scripts/` - Scripts de setup
- `.windsurf/` - Configuración Windsurf

### Workflows Disponibles
- `/setup` - Configuración inicial del proyecto
- `/develop` - Desarrollo diario

### Edición del Tema
Los archivos principales del tema:
- `style.css` - Estilos CSS
- `functions.php` - Funcionalidades PHP
- `template-parts/` - Componentes HTML
- `assets/` - Recursos CSS/JS adicionales

Los cambios se reflejan automáticamente gracias a los volúmenes Docker.

## 🌍 Multiidioma

El sitio está configurado para 3 idiomas:
- 🇪🇸 Español (por defecto)
- 🇬🇧 English  
- 🇫🇷 Français

Usa Polylang desde el panel de administración para gestionar traducciones.

## 🔧 Solución de Problemas

### Docker no funciona
```bash
docker --version
docker compose version
```

### Puertos ocupados
Verifica que los puertos 8080 y 3307 estén libres.

### make no disponible en Windows
Instala Git Bash o usa WSL2. También puedes ejecutar los comandos Docker directamente.

### Verificar estado
```bash
docker compose ps
docker compose logs
```

## 📚 Documentación Adicional

- `README.md` - Documentación completa del proyecto
- `WP-TOMAS.md` - Guía para gestionar contenido
- `CLAUDE.md` - Notas técnicas de implementación

## 🎨 Características del Sitio

- ✅ WordPress 6.x con PHP 8.2
- ✅ Multiidioma con Polylang
- ✅ Tema oscuro/claro
- ✅ Contador de visitas
- ✅ Diseño responsive
- ✅ 15 artículos de ejemplo
- ✅ Sistema de usuarios

---

**¡Listo para desarrollar en Windsurf!** El proyecto está completamente configurado y optimizado para el ecosistema Windsurf.

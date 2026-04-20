# Script de Backup de Base de Datos WordPress

Plan para crear un script shell que facilite los backups de la base de datos MySQL del proyecto WordPress WebRoblox-WP.

## Análisis del Entorno
- Proyecto WordPress corriendo en Docker Compose
- Base de datos MySQL 8.0 en puerto 3307
- Configuración en archivo .env (MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD)
- Contenedor mysql:3306 accesible vía Docker Compose

## Características del Script
1. **Backup completo de la base de datos** con mysqldump
2. **Compresión gzip** para reducir tamaño
3. **Timestamp automático** en nombres de archivos
4. **Directorio de backups organizado** (backups/db/)
5. **Rotación automática** (mantener últimos N backups)
6. **Opciones de restauración**
7. **Verificación de backups**
8. **Integración con Makefile**

## Estructura del Script
```bash
scripts/backup-db.sh
- backup: Crear backup completo
- restore: Restaurar desde backup
- list: Listar backups disponibles
- verify: Verificar integridad de backup
- clean: Rotar backups antiguos
```

## Comandos a Agregar al Makefile
- make db-backup: Ejecutar backup
- make db-restore: Restaurar backup
- make db-list: Listar backups

## Consideraciones de Seguridad
- Leer credenciales desde .env (no hardcodeadas)
- Permisos adecuados en archivos de backup
- Validación de archivos antes de restaurar

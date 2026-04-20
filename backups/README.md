# Backups de Base de Datos

Este directorio contiene los backups de la base de datos MySQL del proyecto WebRoblox-WP.

## Estructura

```
backups/
  db/                    # Backups de la base de datos
    latest_*.sql.gz      # Enlace simbólico al backup más reciente
    *.sql.gz             # Backups con timestamp
  README.md              # Este archivo
```

## Uso del Script de Backup

### Comandos Directos

```bash
# Crear un backup
./scripts/backup-db.sh backup

# Listar todos los backups
./scripts/backup-db.sh list

# Verificar integridad de un backup
./scripts/backup-db.sh verify webroblox_wp_20260420_204046.sql.gz

# Restaurar desde backup
./scripts/backup-db.sh restore webroblox_wp_20260420_204046.sql.gz

# Limpiar backups antiguos (mantener últimos 5)
./scripts/backup-db.sh clean

# Mantener solo los últimos 3 backups
./scripts/backup-db.sh clean 3
```

### Comandos Make (recomendado)

```bash
# Crear backup
make db-backup

# Listar backups
make db-list

# Verificar backup
make db-verify BACKUP=webroblox_wp_20260420_204046.sql.gz

# Restaurar backup
make db-restore BACKUP=webroblox_wp_20260420_204046.sql.gz

# Limpiar backups (mantener 5 por defecto)
make db-clean

# Mantener solo 3 backups
make db-clean KEEP=3
```

## Características

- **Compresión gzip**: Los backups se comprimen automáticamente
- **Timestamp automático**: Cada backup tiene un timestamp único
- **Verificación de integridad**: Verifica que los backups no estén corruptos
- **Rotación automática**: Elimina backups antiguos para ahorrar espacio
- **Enlace simbólico**: `latest_*.sql.gz` siempre apunta al backup más reciente

## Información de Backup

- **Base de datos**: webroblox_wp
- **Formato**: SQL comprimido con gzip
- **Contenido**: Estructura de tablas, datos, procedimientos, triggers y eventos
- **Codificación**: UTF8MB4

## Restauración

**ADVERTENCIA**: La restauración sobreescribirá completamente la base de datos actual.

1. Verifica el backup antes de restaurar:
   ```bash
   make db-verify BACKUP=archivo.sql.gz
   ```

2. Restaura el backup:
   ```bash
   make db-restore BACKUP=archivo.sql.gz
   ```

## Automatización

Puedes agregar backups automáticos usando cron:

```bash
# Backup diario a las 2 AM
0 2 * * * cd /ruta/al/proyecto && ./scripts/backup-db.sh backup && ./scripts/backup-db.sh clean 7
```

## Solución de Problemas

### Error: "Access denied"
Este warning es normal y no afecta el backup. Se debe a que el usuario de MySQL no tiene privilegios PROCESS, pero el backup se completa correctamente.

### Error: "Archivo .env no encontrado"
Asegúrate de que el archivo `.env` exista en el directorio raíz del proyecto con las variables de base de datos configuradas.

### Error: "Contenedor MySQL no está corriendo"
Inicia los contenedores con:
```bash
docker compose up -d
```

#!/bin/bash
# backup-db.sh - Script de backup y restauración para base de datos WordPress
# Uso: ./backup-db.sh [backup|restore|list|verify|clean] [opciones]

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backups/db"
ENV_FILE="$PROJECT_DIR/.env"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de utilidad
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar dependencias
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado o no está en el PATH"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado o no está en el PATH"
        exit 1
    fi
    
    if ! command -v gzip &> /dev/null; then
        log_error "gzip no está instalado"
        exit 1
    fi
}

# Cargar variables de entorno
load_env() {
    if [[ ! -f "$ENV_FILE" ]]; then
        log_error "Archivo .env no encontrado en $PROJECT_DIR"
        log_info "Copia .env.example a .env y configura las variables"
        exit 1
    fi
    
    # Cargar variables del .env de forma segura (manejo de espacios)
    while IFS='=' read -r key value; do
        # Ignorar comentarios y líneas vacías
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        
        # Remover espacios al inicio y final
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        
        # Exportar variable
        export "$key"="$value"
    done < "$ENV_FILE"
    
    # Verificar variables necesarias
    local required_vars=("MYSQL_DATABASE" "MYSQL_USER" "MYSQL_PASSWORD")
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            log_error "Variable $var no está definida en .env"
            exit 1
        fi
    done
}

# Verificar que contenedor MySQL está corriendo
check_mysql_container() {
    if ! docker compose -f "$PROJECT_DIR/docker-compose.yml" ps mysql | grep -q "Up"; then
        log_error "El contenedor MySQL no está corriendo"
        log_info "Ejecuta: docker compose up -d"
        exit 1
    fi
}

# Crear directorio de backups
ensure_backup_dir() {
    mkdir -p "$BACKUP_DIR"
    log_info "Directorio de backups: $BACKUP_DIR"
}

# Generar timestamp
get_timestamp() {
    date '+%Y%m%d_%H%M%S'
}

# Obtener tamaño de archivo en formato legible
get_file_size() {
    local file="$1"
    if [[ -f "$file" ]]; then
        ls -lh "$file" | awk '{print $5}'
    else
        echo "N/A"
    fi
}

# Función principal de backup
backup_database() {
    local backup_name="${MYSQL_DATABASE}_$(get_timestamp).sql.gz"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    log_info "Iniciando backup de la base de datos..."
    log_info "Base de datos: $MYSQL_DATABASE"
    log_info "Archivo de destino: $backup_name"
    
    # Ejecutar backup usando Docker Compose
    docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T mysql \
        mysqldump \
        -u"$MYSQL_USER" \
        -p"$MYSQL_PASSWORD" \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --hex-blob \
        --default-character-set=utf8mb4 \
        "$MYSQL_DATABASE" | gzip > "$backup_path"
    
    if [[ $? -eq 0 ]]; then
        local file_size=$(get_file_size "$backup_path")
        log_success "Backup completado exitosamente"
        log_info "Tamaño del archivo: $file_size"
        log_info "Ubicación: $backup_path"
        
        # Crear symlink al backup más reciente
        local latest_link="$BACKUP_DIR/latest_${MYSQL_DATABASE}.sql.gz"
        ln -sf "$(basename "$backup_path")" "$latest_link"
        log_info "Backup más reciente: $latest_link"
    else
        log_error "Error durante el backup"
        [[ -f "$backup_path" ]] && rm "$backup_path"
        exit 1
    fi
}

# Listar backups disponibles
list_backups() {
    ensure_backup_dir
    
    log_info "Backups disponibles en $BACKUP_DIR:"
    echo
    
    if [[ ! -d "$BACKUP_DIR" ]] || [[ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        log_warning "No se encontraron backups"
        return
    fi
    
    # Listar backups ordenados por fecha (más reciente primero)
    local count=0
    for backup in $(ls -t "$BACKUP_DIR"/*.sql.gz 2>/dev/null); do
        if [[ -f "$backup" ]]; then
            count=$((count + 1))
            local basename=$(basename "$backup")
            local size=$(get_file_size "$backup")
            local date=$(stat -c %y "$backup" | cut -d' ' -f1)
            local time=$(stat -c %y "$backup" | cut -d' ' -f2 | cut -d. -f1)
            
            printf "%3d. %-40s %8s  %s %s\n" "$count" "$basename" "$size" "$date" "$time"
        fi
    done
    
    echo
    log_info "Total: $count backups"
}

# Verificar integridad de backup
verify_backup() {
    local backup_file="$1"
    
    if [[ -z "$backup_file" ]]; then
        log_error "Especifica el archivo de backup a verificar"
        log_info "Uso: $0 verify <archivo_backup>"
        return 1
    fi
    
    # Si no es ruta absoluta, buscar en el directorio de backups
    if [[ "$backup_file" != /* ]]; then
        backup_file="$BACKUP_DIR/$backup_file"
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Archivo no encontrado: $backup_file"
        return 1
    fi
    
    log_info "Verificando integridad de: $(basename "$backup_file")"
    
    # Verificar que sea un archivo gzip válido
    if ! gzip -t "$backup_file" 2>/dev/null; then
        log_error "El archivo está corrupto (no es un gzip válido)"
        return 1
    fi
    
    # Verificar que contenga datos SQL
    if ! gzip -dc "$backup_file" | head -n 5 | grep -q "MySQL dump"; then
        log_error "El archivo no parece ser un dump de MySQL válido"
        return 1
    fi
    
    log_success "El backup parece estar en buen estado"
    
    # Mostrar información del archivo
    local uncompressed_size=$(gzip -dc "$backup_file" | wc -c)
    local table_count=$(gzip -dc "$backup_file" | grep -c "^CREATE TABLE")
    local insert_count=$(gzip -dc "$backup_file" | grep -c "^INSERT INTO")
    
    log_info "Tamaño descomprimido: $(( uncompressed_size / 1024 )) KB"
    log_info "Tablas: $table_count"
    log_info "Inserts: $insert_count"
}

# Restaurar desde backup
restore_backup() {
    local backup_file="$1"
    
    if [[ -z "$backup_file" ]]; then
        log_error "Especifica el archivo de backup a restaurar"
        log_info "Uso: $0 restore <archivo_backup>"
        return 1
    fi
    
    # Si no es ruta absoluta, buscar en el directorio de backups
    if [[ "$backup_file" != /* ]]; then
        backup_file="$BACKUP_DIR/$backup_file"
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Archivo no encontrado: $backup_file"
        return 1
    fi
    
    log_warning "¡ATENCIÓN! Esto sobreescribirá completamente la base de datos actual"
    log_info "Base de datos a restaurar: $MYSQL_DATABASE"
    log_info "Archivo de backup: $(basename "$backup_file")"
    
    # Confirmación
    read -p "¿Estás seguro? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        log_info "Operación cancelada"
        return 0
    fi
    
    log_info "Verificando backup antes de restaurar..."
    if ! verify_backup "$backup_file"; then
        log_error "El backup no es válido, abortando restauración"
        return 1
    fi
    
    log_info "Iniciando restauración..."
    
    # Restaurar usando Docker Compose
    gzip -dc "$backup_file" | docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T mysql \
        mysql \
        -u"$MYSQL_USER" \
        -p"$MYSQL_PASSWORD" \
        "$MYSQL_DATABASE"
    
    if [[ $? -eq 0 ]]; then
        log_success "Restauración completada exitosamente"
        log_info "Base de datos $MYSQL_DATABASE ha sido restaurada"
    else
        log_error "Error durante la restauración"
        exit 1
    fi
}

# Limpiar backups antiguos (rotación)
clean_backups() {
    local keep_count="${1:-5}"
    
    ensure_backup_dir
    
    log_info "Limpiando backups antiguos..."
    log_info "Manteniendo los últimos $keep_count backups"
    
    # Contar backups actuales
    local total_backups=$(ls -1 "$BACKUP_DIR"/*.sql.gz 2>/dev/null | wc -l)
    
    if [[ $total_backups -le $keep_count ]]; then
        log_info "No hay backups para eliminar (actuales: $total_backups, mantener: $keep_count)"
        return 0
    fi
    
    # Eliminar backups más antiguos
    local delete_count=$((total_backups - keep_count))
    log_info "Eliminando $delete_count backups más antiguos..."
    
    ls -t "$BACKUP_DIR"/*.sql.gz | tail -n $delete_count | while read -r backup; do
        log_info "Eliminando: $(basename "$backup")"
        rm "$backup"
    done
    
    log_success "Limpieza completada"
}

# Mostrar ayuda
show_help() {
    cat << EOF
Uso: $0 <comando> [opciones]

Comandos:
    backup              Crear un nuevo backup de la base de datos
    restore <archivo>   Restaurar base de datos desde backup
    list                Listar todos los backups disponibles
    verify <archivo>    Verificar integridad de un backup
    clean [n]           Eliminar backups antiguos, manteniendo los últimos n (default: 5)
    help                Mostrar esta ayuda

Ejemplos:
    $0 backup                           # Crear backup
    $0 restore webroblox_wp_20240420_120000.sql.gz  # Restaurar backup
    $0 list                             # Listar backups
    $0 verify webroblox_wp_20240420_120000.sql.gz   # Verificar backup
    $0 clean 3                          # Mantener solo 3 backups más recientes

Directorio de backups: $BACKUP_DIR
EOF
}

# Función principal
main() {
    local command="${1:-help}"
    
    case "$command" in
        "backup")
            check_dependencies
            load_env
            check_mysql_container
            ensure_backup_dir
            backup_database
            ;;
        "restore")
            check_dependencies
            load_env
            check_mysql_container
            restore_backup "$2"
            ;;
        "list")
            ensure_backup_dir
            list_backups
            ;;
        "verify")
            load_env
            verify_backup "$2"
            ;;
        "clean")
            ensure_backup_dir
            clean_backups "$2"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Comando desconocido: $command"
            echo
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"

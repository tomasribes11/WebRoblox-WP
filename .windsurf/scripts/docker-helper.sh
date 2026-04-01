#!/bin/bash
# Docker Helper Script para Windsurf + WSL
# Facilita operaciones comunes con permisos correctos

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funciones de ayuda
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en el directorio correcto
check_directory() {
    if [[ ! -f "docker-compose.yml" ]]; then
        log_error "No se encuentra docker-compose.yml. Ejecuta desde el directorio del proyecto."
        exit 1
    fi
}

# Verificar que Docker está disponible
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está disponible en WSL"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "No se puede conectar al daemon de Docker. Asegúrate de que Docker Desktop está ejecutándose."
        exit 1
    fi
}

# Comandos principales
case "${1:-help}" in
    "start")
        check_directory
        check_docker
        log_info "Iniciando contenedores..."
        docker compose up -d
        log_info "Contenedores iniciados. Sitio disponible en http://localhost:8080"
        ;;
    
    "stop")
        check_directory
        log_info "Deteniendo contenedores..."
        docker compose down
        log_info "Contenedores detenidos"
        ;;
    
    "restart")
        check_directory
        log_info "Reiniciando contenedores..."
        docker compose restart
        log_info "Contenedores reiniciados"
        ;;
    
    "logs")
        check_directory
        SERVICE="${2:-}"
        if [[ -n "$SERVICE" ]]; then
            log_info "Mostrando logs del servicio: $SERVICE"
            docker compose logs -f "$SERVICE"
        else
            log_info "Mostrando logs de todos los servicios"
            docker compose logs -f
        fi
        ;;
    
    "php-shell")
        check_directory
        log_info "Abriendo shell en contenedor php-fpm..."
        docker compose exec php-fpm bash
        ;;
    
    "db-shell")
        check_directory
        log_info "Abriendo shell MySQL..."
        if [[ -f ".env" ]]; then
            MYSQL_USER=$(grep MYSQL_USER .env | cut -d= -f2)
            MYSQL_PASSWORD=$(grep MYSQL_PASSWORD .env | cut -d= -f2)
            MYSQL_DATABASE=$(grep MYSQL_DATABASE .env | cut -d= -f2)
            docker compose exec mysql mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
        else
            log_error "Archivo .env no encontrado"
            exit 1
        fi
        ;;
    
    "wp-shell")
        check_directory
        log_info "Abriendo shell WP-CLI..."
        docker compose run --rm wp-cli bash
        ;;
    
    "setup")
        check_directory
        log_info "Ejecutando setup completo..."
        if [[ ! -f ".env" ]]; then
            cp .env.example .env
            log_info "Archivo .env creado desde .env.example"
        fi
        docker compose up -d --build
        log_info "Esperando que MySQL esté listo..."
        sleep 10
        docker compose run --rm wp-cli sh /scripts/setup-wp.sh
        log_info "Setup completo. Sitio: http://localhost:8080"
        ;;
    
    "status")
        check_directory
        log_info "Estado de los contenedores:"
        docker compose ps
        ;;
    
    "clean")
        check_directory
        log_warn "Esto eliminará todos los volúmenes y datos. ¿Continuar? (y/N)"
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            log_info "Limpiando contenedores y volúmenes..."
            docker compose down -v
            log_info "Limpieza completada"
        else
            log_info "Operación cancelada"
        fi
        ;;
    
    "help"|*)
        echo "Docker Helper para WebRoblox-WP"
        echo ""
        echo "Uso: $0 <comando> [opciones]"
        echo ""
        echo "Comandos disponibles:"
        echo "  start       - Iniciar todos los contenedores"
        echo "  stop        - Detener todos los contenedores"
        echo "  restart     - Reiniciar todos los contenedores"
        echo "  logs [svc]  - Mostrar logs (opcionalmente de un servicio)"
        echo "  php-shell   - Abrir shell en contenedor PHP"
        echo "  db-shell    - Abrir shell MySQL"
        echo "  wp-shell    - Abrir shell WP-CLI"
        echo "  setup       - Setup completo desde cero"
        echo "  status      - Mostrar estado de contenedores"
        echo "  clean       - Limpiar contenedores y volúmenes"
        echo "  help        - Mostrar esta ayuda"
        echo ""
        echo "Ejemplos:"
        echo "  $0 start"
        echo "  $0 logs nginx"
        echo "  $0 php-shell"
        ;;
esac

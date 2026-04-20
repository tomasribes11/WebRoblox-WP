## Makefile — WebRoblox-WP Development Commands
## Acceso: http://localhost:8080  |  Admin: http://localhost:8080/wp-admin

.PHONY: help setup up down logs logs-nginx logs-php wp-shell wp-cmd php-shell \
        db-shell db-backup db-restore db-list db-verify db-clean up-prod clean reset

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ─── PRIMERA VEZ ─────────────────────────────────────────────────────────────

setup: ## Build + start + setup completo con wp-cli (primera vez)
	@echo "Copiando .env.example → .env (si no existe)..."
	@cp -n .env.example .env 2>/dev/null || true
	@echo "Construyendo e iniciando contenedores..."
	docker compose up -d --build
	@echo "Esperando que MySQL arranque..."
	@sleep 10
	@echo "Ejecutando setup de WordPress con wp-cli..."
	docker compose run --rm wp-cli sh /scripts/setup-wp.sh
	@echo ""
	@echo "✓ Setup completo."
	@echo "  Sitio:  http://localhost:8080"
	@echo "  Admin:  http://localhost:8080/wp-admin"
	@echo "  Login:  $$(grep WP_ADMIN_USER .env | cut -d= -f2) / $$(grep WP_ADMIN_PASSWORD .env | cut -d= -f2)"

# ─── USO DIARIO ──────────────────────────────────────────────────────────────

up: ## Iniciar todos los contenedores
	docker compose up -d

down: ## Parar todos los contenedores
	docker compose down

logs: ## Ver todos los logs en tiempo real
	docker compose logs -f

logs-nginx: ## Logs solo de nginx
	docker compose logs -f nginx

logs-php: ## Logs solo de php-fpm
	docker compose logs -f php-fpm

# ─── WORDPRESS ───────────────────────────────────────────────────────────────

wp-shell: ## Abrir bash interactivo con wp-cli
	docker compose run --rm wp-cli bash

wp-cmd: ## Ejecutar comando wp-cli: make wp-cmd CMD="post list"
	docker compose run --rm wp-cli wp $(CMD) --allow-root --path=/var/www/html

php-shell: ## Abrir bash en el contenedor php-fpm
	docker compose exec php-fpm bash

# ─── BASE DE DATOS ────────────────────────────────────────────────────────────

db-shell: ## Abrir MySQL shell
	@docker compose exec mysql mysql \
		-u$$(grep MYSQL_USER .env | cut -d= -f2) \
		-p$$(grep MYSQL_PASSWORD .env | cut -d= -f2) \
		$$(grep MYSQL_DATABASE .env | cut -d= -f2)

db-backup: ## Crear backup de la base de datos
	@./scripts/backup-db.sh backup

db-restore: ## Restaurar base de datos desde backup (usa: make db-restore BACKUP=archivo.sql.gz)
	@if [ -z "$(BACKUP)" ]; then \
		echo "Especifica el archivo de backup: make db-restore BACKUP=archivo.sql.gz"; \
		echo "Backups disponibles:"; \
		./scripts/backup-db.sh list; \
		exit 1; \
	fi
	@./scripts/backup-db.sh restore $(BACKUP)

db-list: ## Listar todos los backups disponibles
	@./scripts/backup-db.sh list

db-verify: ## Verificar integridad de un backup (usa: make db-verify BACKUP=archivo.sql.gz)
	@if [ -z "$(BACKUP)" ]; then \
		echo "Especifica el archivo de backup: make db-verify BACKUP=archivo.sql.gz"; \
		echo "Backups disponibles:"; \
		./scripts/backup-db.sh list; \
		exit 1; \
	fi
	@./scripts/backup-db.sh verify $(BACKUP)

db-clean: ## Limpiar backups antiguos (usa: make db-clean KEEP=5 para mantener 5 backups)
	@./scripts/backup-db.sh clean $(KEEP)

# ─── PRODUCCIÓN ──────────────────────────────────────────────────────────────

up-prod: ## Iniciar stack de producción
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# ─── LIMPIEZA ────────────────────────────────────────────────────────────────

clean: ## ⚠️ Parar contenedores y BORRAR todos los volúmenes (incluida la BD)
	docker compose down -v

reset: ## ⚠️ Limpieza completa + setup desde cero
	$(MAKE) clean
	$(MAKE) setup

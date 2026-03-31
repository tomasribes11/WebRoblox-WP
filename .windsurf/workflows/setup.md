---
description: Configurar y arrancar el proyecto WordPress por primera vez
---

# Workflow: Setup del Proyecto WordPress

Este workflow configura el proyecto Mundo Roblox WordPress desde cero en tu entorno local.

## Pasos:

1. **Verificar requisitos previos**
   - Asegúrate de que Docker Desktop está instalado y en ejecución
   - Verifica que los puertos 8080 y 3307 están libres

2. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   ```
   // turbo

3. **Ejecutar setup completo**
   ```bash
   make setup
   ```
   Este comando:
   - Construye las imágenes Docker
   - Arranca todos los contenedores
   - Instala WordPress automáticamente
   - Configura Polylang para multiidioma
   - Crea contenido de ejemplo

4. **Verificar instalación**
   Abre el navegador en:
   - Sitio: http://localhost:8080
   - Admin: http://localhost:8080/wp-admin
   - Login: admin / admin123

## Comandos útiles después del setup:

- `make up` - Arrancar los contenedores
- `make down` - Parar los contenedores  
- `make logs` - Ver logs en tiempo real
- `make wp-shell` - Acceder a WP-CLI
- `make db-shell` - Acceder a MySQL

## Si algo falla:

- Ejecuta `make logs` para ver los logs de error
- Usa `make reset` para limpiar todo y empezar de cero
- Verifica que Docker esté funcionando correctamente

# Instrucciones para Corregir Problemas de Subida de Imágenes

## Script: `fix-uploads.php`

### 🎯 Objetivo
Corregir el error "The uploaded file could not be moved to wp-content/uploads" en WordPress.

### 🚀 Cómo Ejecutar

#### Método 1: Usando Docker Compose (Recomendado)
```bash
docker compose exec php-fpm php fix-uploads.php
```

#### Método 2: Usando Make
```bash
make exec-php-fpm php fix-uploads.php
```

### 📋 Qué Hace el Script

1. **Verifica existencia** de `wp-content/uploads`
2. **Crea la carpeta** si no existe con permisos 755
3. **Genera estructura** año/mes actual (ej: 2025/04)
4. **Ajusta permisos** recursivamente (755 directorios, 644 archivos)
5. **Verifica ownership** del usuario PHP
6. **Realiza test** de escritura para confirmar funcionamiento

### 🔍 Salida Esperada
```
=== Script de Corrección de Uploads WordPress ===
Versión: 1.0
Compatible con: PHP 7.4+, WordPress 5.0+

🔧 Iniciando corrección de problemas de uploads en WordPress...

✅ Carpeta wp-content/uploads ya existe
✅ Estructura 2025/04 creada exitosamente
🔐 Ajustando permisos de la carpeta uploads...
✅ Permisos de wp-content/uploads ajustados a 755
✅ Permisos ajustados para: wp-content/uploads/2025
✅ Permisos ajustados para: wp-content/uploads/2025/04
👤 Usuario PHP actual: www-data
✅ Owner de wp-content/uploads verificado

🔍 Verificación final:
✅ wp-content/uploads existe y tiene permisos de escritura
✅ Estructura 2025/04 existe y tiene permisos de escritura

🧪 Realizando test de escritura...
✅ Test de escritura exitoso
✅ Archivo de prueba eliminado

🎉 ¡Todo correcto! Los problemas de uploads han sido corregidos.
📋 Resumen de acciones realizadas:
   - Carpeta wp-content/uploads verificada/creada
   - Estructura año/mes creada: 2025/04
   - Permisos ajustados a 755
   - Test de escritura validado

✅ Script completado exitosamente
```

### ⚠️ Notas Importantes

- **Seguro**: No usa permisos 777 ni prácticas inseguras
- **Temporal**: Script de una sola ejecución, puede eliminarse después
- **Compatible**: Funciona con PHP 7.4+ y WordPress actual
- **Docker**: Diseñado específicamente para entorno Docker

### 🗑️ Después de Usar
Una vez que el script confirme que todo está correcto, puedes eliminarlo:
```bash
rm fix-uploads.php
```

### 🔧 Si Persisten Problemas

1. **Verificar permisos del contenedor**:
   ```bash
   docker compose exec php-fpm whoami
   docker compose exec php-fpm ls -la wp-content/uploads/
   ```

2. **Reiniciar contenedores**:
   ```bash
   docker compose restart php-fpm nginx
   ```

3. **Verificar espacio en disco**:
   ```bash
   docker compose exec php-fpm df -h
   ```

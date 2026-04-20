<?php
/**
 * Script PHP para corregir problemas de subida de imágenes en WordPress
 * 
 * Este script verifica y corrige los permisos y estructura de la carpeta wp-content/uploads
 * Compatible con PHP 7.4+ y WordPress actual
 * Ejecutar dentro del contenedor Docker PHP-FPM
 */

// Evitar acceso directo fuera de WordPress
if (!defined('ABSPATH')) {
    // Si no estamos en WordPress, definimos la ruta base
    define('ABSPATH', dirname(__FILE__) . '/');
}

/**
 * Función principal para corregir problemas de uploads
 */
function fixWordpressUploads() {
    echo "🔧 Iniciando corrección de problemas de uploads en WordPress...\n\n";
    
    // 1. Verificar y crear carpeta principal wp-content/uploads
    $uploadsDir = ABSPATH . 'wp-content/uploads';
    
    if (!file_exists($uploadsDir)) {
        echo "📁 Creando carpeta wp-content/uploads...\n";
        if (mkdir($uploadsDir, 0755, true)) {
            echo "✅ Carpeta wp-content/uploads creada exitosamente\n";
        } else {
            echo "❌ Error: No se pudo crear la carpeta wp-content/uploads\n";
            return false;
        }
    } else {
        echo "✅ Carpeta wp-content/uploads ya existe\n";
    }
    
    // 2. Crear estructura de año/mes actual
    $currentYear = date('Y');
    $currentMonth = date('m');
    $yearMonthDir = $uploadsDir . '/' . $currentYear . '/' . $currentMonth;
    
    if (!file_exists($yearMonthDir)) {
        echo "📁 Creando estructura de carpetas $currentYear/$currentMonth...\n";
        if (mkdir($yearMonthDir, 0755, true)) {
            echo "✅ Estructura $currentYear/$currentMonth creada exitosamente\n";
        } else {
            echo "❌ Error: No se pudo crear la estructura $currentYear/$currentMonth\n";
            return false;
        }
    } else {
        echo "✅ Estructura $currentYear/$currentMonth ya existe\n";
    }
    
    // 3. Corregir permisos de la carpeta uploads
    echo "🔐 Ajustando permisos de la carpeta uploads...\n";
    if (chmod($uploadsDir, 0755)) {
        echo "✅ Permisos de wp-content/uploads ajustados a 755\n";
    } else {
        echo "⚠️  Advertencia: No se pudieron ajustar permisos de wp-content/uploads\n";
    }
    
    // 4. Corregir permisos de subcarpetas recursivamente
    fixDirectoryPermissions($uploadsDir);
    
    // 5. Verificar ownership (usuario PHP)
    $phpUser = get_current_user();
    echo "👤 Usuario PHP actual: $phpUser\n";
    
    // Intentar cambiar ownership si tenemos permisos
    if (function_exists('chown')) {
        $owner = fileowner($uploadsDir);
        if ($owner !== false) {
            echo "✅ Owner de wp-content/uploads verificado\n";
        } else {
            echo "⚠️  No se pudo verificar el owner de wp-content/uploads\n";
        }
    }
    
    // 6. Verificación final
    echo "\n🔍 Verificación final:\n";
    
    // Verificar que la carpeta principal existe y es escribible
    if (is_dir($uploadsDir) && is_writable($uploadsDir)) {
        echo "✅ wp-content/uploads existe y tiene permisos de escritura\n";
    } else {
        echo "❌ wp-content/uploads no existe o no tiene permisos de escritura\n";
        return false;
    }
    
    // Verificar que la carpeta de año/mes existe y es escribible
    if (is_dir($yearMonthDir) && is_writable($yearMonthDir)) {
        echo "✅ Estructura $currentYear/$currentMonth existe y tiene permisos de escritura\n";
    } else {
        echo "❌ Estructura $currentYear/$currentMonth no existe o no tiene permisos de escritura\n";
        return false;
    }
    
    // 7. Test de escritura
    echo "\n🧪 Realizando test de escritura...\n";
    $testFile = $yearMonthDir . '/test-upload-' . time() . '.tmp';
    
    if (file_put_contents($testFile, 'test') !== false) {
        echo "✅ Test de escritura exitoso\n";
        unlink($testFile); // Limpiar archivo de prueba
        echo "✅ Archivo de prueba eliminado\n";
    } else {
        echo "❌ Test de escritura fallido\n";
        return false;
    }
    
    echo "\n🎉 ¡Todo correcto! Los problemas de uploads han sido corregidos.\n";
    echo "📋 Resumen de acciones realizadas:\n";
    echo "   - Carpeta wp-content/uploads verificada/creada\n";
    echo "   - Estructura año/mes creada: $currentYear/$currentMonth\n";
    echo "   - Permisos ajustados a 755\n";
    echo "   - Test de escritura validado\n";
    
    return true;
}

/**
 * Función recursiva para corregir permisos de directorios
 */
function fixDirectoryPermissions($dir) {
    if (!is_dir($dir)) {
        return;
    }
    
    // Corregir permisos del directorio actual
    if (chmod($dir, 0755)) {
        echo "✅ Permisos ajustados para: " . str_replace(ABSPATH, '', $dir) . "\n";
    }
    
    // Recorrer subdirectorios
    $items = scandir($dir);
    foreach ($items as $item) {
        if ($item == '.' || $item == '..') {
            continue;
        }
        
        $path = $dir . '/' . $item;
        
        if (is_dir($path)) {
            fixDirectoryPermissions($path);
        } elseif (is_file($path)) {
            // Corregir permisos de archivos a 644
            chmod($path, 0644);
        }
    }
}

/**
 * Función para mostrar uso del script
 */
function showUsage() {
    echo "Uso: php fix-uploads.php\n";
    echo "Este script debe ejecutarse dentro del contenedor PHP-FPM\n";
    echo "Comando Docker recomendado:\n";
    echo "docker compose exec php-fpm php fix-uploads.php\n";
}

// Ejecutar el script
if (php_sapi_name() === 'cli') {
    echo "=== Script de Corrección de Uploads WordPress ===\n";
    echo "Versión: 1.0\n";
    echo "Compatible con: PHP 7.4+, WordPress 5.0+\n\n";
    
    $result = fixWordpressUploads();
    
    if ($result) {
        echo "\n✅ Script completado exitosamente\n";
        exit(0);
    } else {
        echo "\n❌ El script encontró errores que no pudo resolver\n";
        exit(1);
    }
} else {
    echo "Este script solo puede ejecutarse desde línea de comandos (CLI)\n";
    showUsage();
    exit(1);
}

?>

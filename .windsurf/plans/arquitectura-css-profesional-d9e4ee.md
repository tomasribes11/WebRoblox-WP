# Plan: Arquitectura CSS Profesional WordPress

## Problema Actual
- `custom-finance.css` en raíz del proyecto (incorrecto)
- Duplicación de archivos CSS en tema Kadence
- Sin estructura organizada según estándares WordPress

## Arquitectura Propuesta

### 1. Estructura de Directorios
```
wp-content/themes/[tema-activo]/
├── assets/
│   ├── css/
│   │   ├── main.css
│   │   ├── finance.css
│   │   └── responsive.css
│   ├── js/
│   ├── images/
│   └── fonts/
├── inc/
│   ├── customizer.php
│   ├── hooks.php
│   └── helpers.php
└── functions.php
```

### 2. Organización CSS Modular
- **main.css**: Estilos base y variables CSS
- **finance.css**: Estilos específicos contenido financiero
- **responsive.css**: Media queries organizadas

### 3. Sistema de Enqueue Proper
- Usar `functions.php` para cargar CSS/JS con dependencias
- Versionado automático de archivos
- Condiciones de carga específicas

### 4. Child Theme Strategy
- Crear child theme del tema base
- Mantener capacidad de actualizaciones
- Heredar funcionalidades base

## Pasos de Implementación
1. Identificar tema activo actual
2. Crear estructura de directorios
3. Modularizar archivos CSS
4. Implementar sistema de enqueue
5. Mover y organizar estilos existentes
6. Probar y validar funcionamiento

## Preguntas para Usuario
- ¿Qué tema está activo actualmente?
- ¿Prefieres child theme o modificar tema actual?
- ¿Mantener estilos existentes o reestructurar?

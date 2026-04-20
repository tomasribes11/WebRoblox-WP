# Plan: Arreglar Visibilidad del Menú de Navegación

## Problema Identificado
El menú de navegación existe y funciona correctamente (6 elementos configurados), pero los textos no son visibles debido a un conflicto entre las clases CSS que WordPress genera y los estilos definidos en el tema.

## Causa Raíz
- WordPress genera el menú con clase `.navbar-nav` (Bootstrap)
- El CSS del tema apunta a `.menu-principal` 
- Los estilos de Bootstrap están sobrescribiendo la visibilidad

## Solución Propuesta

### 1. CSS Fuerte para Forzar Visibilidad
Aplicar estilos CSS con `!important` que aseguren que los elementos del menú sean visibles sin importar los conflictos.

### 2. Apuntar a Clases Correctas
Crear estilos que apunten tanto a las clases de WordPress como a las clases Bootstrap:
- `#main-menu` (ID del menú)
- `.navbar-nav` (clase Bootstrap)
- `.nav-link` (clase de enlaces Bootstrap)

### 3. Contraste Garantizado
Asegurar colores con alto contraste:
- Texto oscuro (#111) sobre fondo claro
- Texto claro (#E9ECEF) sobre fondo oscuro

### 4. Aplicación
El CSS se aplicará via **Apariencia → Personalizar → CSS adicional** en WordPress.

## CSS a Implementar
```css
/* Forzar visibilidad del menú principal */
#main-menu,
.navbar-nav {
    display: flex !important;
    opacity: 1 !important;
    visibility: visible !important;
    list-style: none !important;
    margin: 0 !important;
    padding: 0 !important;
    gap: 20px;
    align-items: center;
}

#main-menu li,
.navbar-nav li {
    display: inline-block !important;
    opacity: 1 !important;
    visibility: visible !important;
}

#main-menu a,
.navbar-nav .nav-link {
    color: #111 !important;
    font-size: 16px !important;
    font-weight: 600 !important;
    text-decoration: none !important;
    opacity: 1 !important;
    visibility: visible !important;
    display: block !important;
    padding: 8px 12px !important;
    border-radius: 6px;
    transition: all 0.2s ease;
}

#main-menu a:hover,
.navbar-nav .nav-link:hover {
    color: #0073aa !important;
    background-color: #f8f9fa !important;
}

/* Dark mode adjustments */
.dark-mode #main-menu a,
.dark-mode .navbar-nav .nav-link {
    color: #E9ECEF !important;
}

.dark-mode #main-menu a:hover,
.dark-mode .navbar-nav .nav-link:hover {
    color: #4A9EFF !important;
    background-color: #212529 !important;
}

/* Mobile responsive */
@media (max-width: 768px) {
    #main-menu,
    .navbar-nav {
        flex-direction: column !important;
        gap: 8px !important;
        width: 100% !important;
    }
    
    #main-menu a,
    .navbar-nav .nav-link {
        width: 100% !important;
        padding: 12px 16px !important;
    }
}
```

## Validación
- [ ] Menú visible en desktop
- [ ] Textos legibles con buen contraste
- [ ] Enlaces funcionales
- [ ] Funciona en móvil
- [ ] Compatible con modo oscuro
- [ ] Efectos hover funcionales

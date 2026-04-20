# Plan: Agregar 4 artículos financieros a sección Comparaciones

Crear la estructura completa para la sección Comparaciones usando categorías WordPress, incluyendo 4 artículos financieros con placeholders y mantener el diseño consistente del tema.

## Tareas a realizar

### 1. Crear categoría "Comparaciones"
- Crear categoría WordPress con slug "comparaciones"
- Configurar para que aparezca en navegación

### 2. Crear página de sección Comparaciones
- Crear página con URL `/comparativas` 
- Usar plantilla que muestre solo artículos de categoría "comparaciones"
- Mantener diseño consistente con archive.php

### 3. Crear los 4 artículos financieros
1. **Indexa Capital vs Finizens** - Fondos de inversión automatizados
2. **Openbank vs Bankinter** - Cuentas bancarias online  
3. **ING Direct vs EVO Banco** - Comparativa cuentas online
4. **Revolut vs Wise** - Transferencias internacionales

### 4. Configurar cada artículo
- Asignar categoría "Comparaciones"
- Usar placeholder de imagen (emoji 💰 según diseño actual)
- Extracto automático del contenido
- Títulos y contenido completo proporcionado

### 5. Validación final
- Verificar que artículos aparecen solo en Comparaciones
- Comprobar navegación funcional
- Confirmar diseño responsive

## Estructura técnica
- Categoría: `comparaciones` (slug)
- Página: `/comparativas` (template personalizado)
- Artículos: 4 posts con contenido completo
- Imágenes: placeholders con emoji 💰
- Navegación: enlace existente en header.php apuntará a página funcional

<?php
/**
 * inc/setup.php — Configuración del tema (after_setup_theme)
 */

add_action('after_setup_theme', function () {
    // Permite que WordPress gestione el <title>
    add_theme_support('title-tag');

    // Imágenes destacadas (cover images en tarjetas)
    add_theme_support('post-thumbnails');

    // HTML5 semántico
    add_theme_support('html5', [
        'search-form',
        'comment-form',
        'comment-list',
        'gallery',
        'caption',
        'style',
        'script',
    ]);

    // Tamaño de imagen para las tarjetas de artículo
    add_image_size('article-card', 600, 360, true);
});

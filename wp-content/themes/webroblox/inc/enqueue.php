<?php
/**
 * inc/enqueue.php — Carga de estilos y scripts (wp_enqueue_scripts)
 */

add_action('wp_enqueue_scripts', function () {
    $version = wp_get_theme()->get('Version');

    // Bootstrap 5.3 CSS (CDN)
    wp_enqueue_style(
        'bootstrap',
        'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css',
        [],
        '5.3.3'
    );

    // Tema CSS (después de Bootstrap)
    wp_enqueue_style(
        'webroblox-theme',
        get_template_directory_uri() . '/assets/css/theme.css',
        ['bootstrap'],
        $version
    );

    // Bootstrap 5.3 JS bundle (incluye Popper)
    wp_enqueue_script(
        'bootstrap',
        'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js',
        [],
        '5.3.3',
        true   // en el footer
    );

    // Tema JS — se carga en el <head> (no en footer) para evitar flash de tema
    wp_enqueue_script(
        'webroblox-theme',
        get_template_directory_uri() . '/assets/js/theme.js',
        [],        // sin dependencias (se ejecuta antes de Bootstrap)
        $version,
        false      // en el <head>
    );
});

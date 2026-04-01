<?php
/**
 * inc/custom-queries.php — Helpers de WP_Query para el tema
 *
 * Polylang filtra automáticamente por idioma todas las WP_Query
 * cuando está activo, por lo que no es necesario pasar 'lang'.
 */

/**
 * Devuelve una WP_Query para artículos publicados.
 *
 * @param array $args {
 *   @type string $category_slug  Slug de la categoría (idioma actual)
 *   @type int    $posts_per_page Número de posts por página (default: 12)
 *   @type int    $paged          Página actual (default: get_query_var('paged'))
 * }
 */
function webroblox_articles_query(array $args = []): WP_Query
{
    $paged = get_query_var('paged') ?: 1;

    $defaults = [
        'post_type'      => 'post',
        'post_status'    => 'publish',
        'posts_per_page' => $args['posts_per_page'] ?? 12,
        'paged'          => $args['paged'] ?? $paged,
        'orderby'        => 'date',
        'order'          => 'DESC',
    ];

    if (!empty($args['category_slug'])) {
        $defaults['category_name'] = $args['category_slug'];
    }

    return new WP_Query($defaults);
}

/**
 * Devuelve los 6 artículos más recientes para la home.
 */
function webroblox_featured_articles_query(): WP_Query
{
    return webroblox_articles_query(['posts_per_page' => 6, 'paged' => 1]);
}

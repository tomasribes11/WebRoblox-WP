<?php
/**
 * inc/view-count.php — Contador de visitas por artículo
 *
 * Estrategia: hook en 'wp', incrementa el meta _view_count en cada visita
 * única (una cookie de 1h previene el inflation por recarga).
 */

add_action('wp', function () {
    if (!is_single()) {
        return;
    }

    global $post;
    if (!$post) {
        return;
    }

    $cookie_key = 'wr_viewed_' . $post->ID;

    // Si ya se visitó en la última hora, no incrementar
    if (isset($_COOKIE[$cookie_key])) {
        return;
    }

    $count = (int) get_post_meta($post->ID, '_view_count', true);
    update_post_meta($post->ID, '_view_count', $count + 1);

    // Cookie de 1h (3600s) para evitar recuentos duplicados
    setcookie(
        $cookie_key,
        '1',
        time() + 3600,
        defined('COOKIEPATH') ? COOKIEPATH : '/',
        defined('COOKIE_DOMAIN') ? COOKIE_DOMAIN : ''
    );
});

/**
 * Devuelve el contador de visitas de un post.
 */
function webroblox_get_view_count(int $post_id): int
{
    return (int) get_post_meta($post_id, '_view_count', true);
}

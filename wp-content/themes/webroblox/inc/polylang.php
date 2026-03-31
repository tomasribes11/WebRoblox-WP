<?php
/**
 * inc/polylang.php — Helpers para integración con Polylang
 *
 * Todas las funciones comprueban si Polylang está activo antes de llamar
 * a sus APIs, para que el tema funcione también sin el plugin.
 */

/**
 * Devuelve el código del idioma actual (es, en, fr).
 * Fallback: 'es'.
 */
function webroblox_current_lang(): string
{
    return function_exists('pll_current_language')
        ? (string) pll_current_language()
        : 'es';
}

/**
 * Devuelve los datos del language switcher para la plantilla.
 * Cada entrada: ['code', 'name', 'flag', 'url', 'active']
 */
function webroblox_language_switcher_data(): array
{
    if (!function_exists('pll_the_languages')) {
        return [];
    }

    $flags = ['es' => '🇪🇸', 'en' => '🇬🇧', 'fr' => '🇫🇷'];
    $raw   = pll_the_languages(['raw' => 1, 'show_flags' => 0]);
    $result = [];

    foreach ($raw as $lang) {
        $code     = $lang['slug'];
        $result[] = [
            'code'   => $code,
            'name'   => strtoupper($code),
            'flag'   => $flags[$code] ?? '',
            'url'    => $lang['url'],
            'active' => (bool) $lang['current_lang'],
        ];
    }

    return $result;
}

/**
 * Devuelve la URL de la categoría traducida al idioma actual
 * a partir del slug base en español.
 *
 * Ejemplo: webroblox_category_link('trucos') → en inglés devuelve /en/category/tricks/
 */
function webroblox_category_link(string $base_slug): string
{
    // Mapa base_slug (ES) → slug por idioma
    $slug_map = [
        'trucos'   => ['es' => 'trucos',   'en' => 'tricks',  'fr' => 'astuces'],
        'guias'    => ['es' => 'guias',     'en' => 'guides',  'fr' => 'guides-fr'],
        'noticias' => ['es' => 'noticias',  'en' => 'news',    'fr' => 'actualites'],
    ];

    $lang = webroblox_current_lang();
    $slug = $slug_map[$base_slug][$lang] ?? $base_slug;

    $term = get_term_by('slug', $slug, 'category');

    if ($term && !is_wp_error($term)) {
        return (string) get_term_link($term);
    }

    // Fallback: categoría en español
    $term_es = get_term_by('slug', $base_slug, 'category');
    return ($term_es && !is_wp_error($term_es))
        ? (string) get_term_link($term_es)
        : home_url('/');
}

/**
 * Devuelve la URL home del idioma especificado.
 */
function webroblox_lang_home_url(string $lang): string
{
    return function_exists('pll_home_url')
        ? (string) pll_home_url($lang)
        : home_url('/');
}

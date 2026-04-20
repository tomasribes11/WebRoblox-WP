<?php
if (!function_exists('gamernews_theme_enqueue_styles')) {
    add_action('wp_enqueue_scripts', 'gamernews_theme_enqueue_styles');

    function gamernews_theme_enqueue_styles()
    {
        $min = defined('SCRIPT_DEBUG') && SCRIPT_DEBUG ? '' : '.min';
        $gamernews_version = wp_get_theme()->get('Version');
        $parent_style = 'morenews-style';

        // Enqueue Parent and Child Theme Styles
        wp_enqueue_style('bootstrap', get_template_directory_uri() . '/assets/bootstrap/css/bootstrap' . $min . '.css', array(), $gamernews_version);
        wp_enqueue_style($parent_style, get_template_directory_uri() . '/style' . $min . '.css', array(), $gamernews_version);
        wp_enqueue_style(
            'gamernews',
            get_stylesheet_directory_uri() . '/style.css',
            array('bootstrap', $parent_style),
            $gamernews_version
        );

        // Enqueue RTL Styles if the site is in RTL mode
        if (is_rtl()) {
            wp_enqueue_style(
                'morenews-rtl',
                get_template_directory_uri() . '/rtl.css',
                array($parent_style),
                $gamernews_version
            );
        }
    }
}

// Set up the WordPress core custom background feature.
add_theme_support('custom-background', apply_filters('morenews_custom_background_args', array(
    'default-color' => 'f5f5f5',
    'default-image' => '',
)));


function gamernews_custom_header_setup($default_custom_header)
{
    $default_custom_header['default-text-color'] = 'ffffff';
    return $default_custom_header;
}
add_filter('morenews_custom_header_args', 'gamernews_custom_header_setup', 1);

function gamernews_filter_default_theme_options($defaults)
{
    $defaults['select_header_image_mode']  = 'above';
    $defaults['select_popular_tags_mode']  = 'category';
    $defaults['global_site_mode_setting']    = 'aft-dark-mode';
    $defaults['dark_background_color']     = '#1A1A1A';
    $defaults['site_title_font_size'] = 64;
    $defaults['site_title_uppercase']  = 0;
    $defaults['disable_header_image_tint_overlay']  = 1;
    $defaults['show_primary_menu_desc']  = 0;
    $defaults['flash_news_title'] = __('Breaking News', 'gamernews');
    $defaults['aft_custom_title']           = __('Watch Video', 'gamernews');
    $defaults['secondary_color'] = '#E72B99';
    $defaults['select_update_post_filterby'] = 'cat';
    $defaults['frontpage_content_type']  = 'frontpage-widgets-and-content';
    $defaults['featured_news_section_title'] = __('Featured News', 'gamernews');
    $defaults['single_related_posts_title']     = __('Related News', 'gamernews');
    return $defaults;
}
add_filter('morenews_filter_default_theme_options', 'gamernews_filter_default_theme_options', 1);

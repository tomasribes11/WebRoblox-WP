<?php
/**
 * Funciones para selector de idioma Polylang en tema Kadence
 */

// Agregar selector de idioma simple en la esquina superior derecha
add_action('wp_head', 'kadence_add_simple_language_switcher');

function kadence_add_simple_language_switcher() {
    if (function_exists('pll_the_languages')) {
        ?>
        <style>
        .simple-lang-switcher {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            background: #0073aa;
            color: white;
            padding: 8px 15px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }
        
        .simple-lang-switcher:hover {
            background: #005a87;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        
        .lang-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 5px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            overflow: hidden;
            display: none;
            min-width: 120px;
        }
        
        .lang-dropdown.show {
            display: block;
        }
        
        .lang-option {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            transition: background 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .lang-option:last-child {
            border-bottom: none;
        }
        
        .lang-option:hover {
            background: #f5f5f5;
            color: #0073aa;
        }
        
        .lang-option.current {
            background: #e8f4f8;
            color: #0073aa;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .simple-lang-switcher {
                top: 15px;
                right: 15px;
                padding: 6px 12px;
                font-size: 12px;
            }
        }
        </style>
        
        <div class="simple-lang-switcher" onclick="toggleLangDropdown()">
            <span id="current-lang-display">ES</span>
            <div class="lang-dropdown" id="lang-dropdown">
                <?php
                $languages = pll_the_languages(array(
                    'show_flags' => 0,
                    'show_names' => 1,
                    'display_names_as' => 'slug',
                    'hide_if_no_translation' => 1,
                    'force_home' => 0,
                    'echo' => 0,
                    'item_format' => '<a href="%2$s" class="lang-option %3$s">%1$s</a>',
                    'current_lang' => '<span class="lang-option current">%1$s</span>'
                ));
                echo $languages;
                ?>
            </div>
        </div>
        
        <script>
        function toggleLangDropdown() {
            const dropdown = document.getElementById('lang-dropdown');
            dropdown.classList.toggle('show');
            
            // Cerrar dropdown al hacer clic fuera
            document.addEventListener('click', function closeDropdown(e) {
                if (!e.target.closest('.simple-lang-switcher')) {
                    dropdown.classList.remove('show');
                    document.removeEventListener('click', closeDropdown);
                }
            });
        }
        
        // Actualizar idioma actual mostrado
        document.addEventListener('DOMContentLoaded', function() {
            const currentLang = document.querySelector('.lang-option.current');
            if (currentLang) {
                document.getElementById('current-lang-display').textContent = currentLang.textContent.toUpperCase();
            }
        });
        </script>
        <?php
    }
}


// Agregar soporte para URLs multidioma en el tema
add_action('after_setup_theme', 'kadence_multilang_setup');

function kadence_multilang_setup() {
    // Asegurar que el tema soporte hreflang
    add_theme_support('html5', array('language-attributes'));
    
    // Optimizar navegación para Polylang
    if (function_exists('pll_home_url')) {
        add_filter('theme_mod_logo', function($logo) {
            return pll_home_url() . ltrim(str_replace(pll_home_url(), '', $logo), '/');
        });
    }
}

// Filtro para menús multidioma
add_filter('wp_nav_menu_args', 'kadence_multilang_menu_args');

function kadence_multilang_menu_args($args) {
    if (function_exists('pll_current_language')) {
        $current_lang = pll_current_language();
        
        // Asignar menús específicos por idioma
        $menu_locations = array(
            'primary' => array(
                'es' => 'menu-espanol',
                'en' => 'menu-english', 
                'fr' => 'menu-francais'
            ),
            'footer' => array(
                'es' => 'footer-espanol',
                'en' => 'footer-english',
                'fr' => 'footer-francais'
            )
        );
        
        if (isset($args['theme_location']) && isset($menu_locations[$args['theme_location']][$current_lang])) {
            $args['menu'] = $menu_locations[$args['theme_location']][$current_lang];
        }
    }
    
    return $args;
}

?>

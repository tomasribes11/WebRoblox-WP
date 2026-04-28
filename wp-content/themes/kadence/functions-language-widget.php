<?php
/**
 * Widget personalizado para selector de idioma en el header
 */

class Kadence_Language_Switcher_Widget extends WP_Widget {

    public function __construct() {
        parent::__construct(
            'kadence_language_switcher',
            'Selector de Idioma',
            array( 'description' => 'Botón para cambiar de idioma en el header' )
        );
    }

    public function widget( $args, $instance ) {
        if (function_exists('pll_the_languages')) {
            echo '<div class="header-language-switcher">';
            
            $current_lang = pll_current_language('slug');
            echo '<button class="lang-btn" onclick="toggleLangMenu()">';
            echo '<span class="current-lang">' . strtoupper($current_lang) . '</span>';
            echo '<span class="lang-arrow">▼</span>';
            echo '</button>';
            
            echo '<div class="lang-menu" id="lang-menu">';
            $languages = pll_the_languages(array(
                'show_flags' => 0,
                'show_names' => 1,
                'display_names_as' => 'name',
                'hide_if_no_translation' => 1,
                'force_home' => 0,
                'echo' => 0,
                'item_format' => '<a href="%2$s" class="lang-link">%1$s</a>',
                'current_lang' => '<span class="lang-current">%1$s</span>'
            ));
            echo $languages;
            echo '</div>';
            
            echo '</div>';
            
            // Estilos y JavaScript
            ?>
            <style>
            .header-language-switcher {
                position: relative;
                display: inline-block;
                margin-left: 20px;
            }
            
            .lang-btn {
                background: #0073aa;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 5px;
                transition: all 0.3s ease;
            }
            
            .lang-btn:hover {
                background: #005a87;
                transform: translateY(-1px);
            }
            
            .lang-arrow {
                font-size: 10px;
                transition: transform 0.3s ease;
            }
            
            .lang-btn:hover .lang-arrow {
                transform: rotate(180deg);
            }
            
            .lang-menu {
                position: absolute;
                top: 100%;
                right: 0;
                margin-top: 5px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
                overflow: hidden;
                display: none;
                min-width: 150px;
                z-index: 1000;
            }
            
            .lang-menu.show {
                display: block;
            }
            
            .lang-link, .lang-current {
                display: block;
                padding: 10px 15px;
                color: #333;
                text-decoration: none;
                font-size: 14px;
                transition: background 0.2s ease;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .lang-link:hover {
                background: #f5f5f5;
                color: #0073aa;
            }
            
            .lang-current {
                background: #e8f4f8;
                color: #0073aa;
                font-weight: 600;
            }
            
            @media (max-width: 768px) {
                .header-language-switcher {
                    margin-left: 10px;
                }
                
                .lang-btn {
                    padding: 6px 12px;
                    font-size: 12px;
                }
            }
            </style>
            
            <script>
            function toggleLangMenu() {
                const menu = document.getElementById('lang-menu');
                menu.classList.toggle('show');
                
                // Cerrar al hacer clic fuera
                document.addEventListener('click', function closeMenu(e) {
                    if (!e.target.closest('.header-language-switcher')) {
                        menu.classList.remove('show');
                        document.removeEventListener('click', closeMenu);
                    }
                });
            }
            </script>
            <?php
        }
    }

    public function form( $instance ) {
        ?>
        <p>
            <label for="<?php echo $this->get_field_id( 'title' ); ?>">Título:</label>
            <input class="widefat" id="<?php echo $this->get_field_id( 'title' ); ?>" name="<?php echo $this->get_field_name( 'title' ); ?>" type="text" value="<?php echo esc_attr( $instance['title'] ); ?>" />
        </p>
        <?php
    }

    public function update( $new_instance, $old_instance ) {
        $instance = array();
        $instance['title'] = ( ! empty( $new_instance['title'] ) ) ? strip_tags( $new_instance['title'] ) : '';
        return $instance;
    }
}

// Registrar el widget
function register_kadence_language_widget() {
    register_widget( 'Kadence_Language_Switcher_Widget' );
}
add_action( 'widgets_init', 'register_kadence_language_widget' );

?>

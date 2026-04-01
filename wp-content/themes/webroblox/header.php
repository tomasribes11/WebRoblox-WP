<!DOCTYPE html>
<html <?php language_attributes(); ?> data-bs-theme="dark">
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<?php wp_body_open(); ?>

<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">

        <!-- Logo -->
        <a class="navbar-brand fw-bold text-gradient-accent fs-4"
           href="<?php echo esc_url(home_url('/')); ?>">
            🎮 Mundo Roblox
        </a>

        <!-- Hamburger -->
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarMain"
                aria-controls="navbarMain" aria-expanded="false"
                aria-label="Abrir menú">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Nav links + controles -->
        <div class="collapse navbar-collapse" id="navbarMain">

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link <?php echo is_front_page() ? 'active' : ''; ?>"
                       href="<?php echo esc_url(home_url('/')); ?>">
                        Inicio
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link"
                       href="<?php echo esc_url(webroblox_category_link('trucos')); ?>">
                        Trucos
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link"
                       href="<?php echo esc_url(webroblox_category_link('guias')); ?>">
                        Guías
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link"
                       href="<?php echo esc_url(webroblox_category_link('noticias')); ?>">
                        Noticias
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <!-- Selector de idioma -->
                <?php get_template_part('template-parts/language-switcher'); ?>

                <!-- Toggle de tema -->
                <?php get_template_part('template-parts/theme-toggle'); ?>

                <!-- Auth -->
                <?php if (is_user_logged_in()) :
                    $current_user = wp_get_current_user();
                ?>
                    <span class="navbar-text small text-body-secondary">
                        Hola, <?php echo esc_html($current_user->display_name); ?>
                    </span>
                    <a href="<?php echo esc_url(wp_logout_url(home_url('/'))); ?>"
                       class="btn btn-outline-danger btn-sm">
                        Salir
                    </a>
                <?php else : ?>
                    <a href="<?php echo esc_url(wp_login_url()); ?>"
                       class="btn btn-accent btn-sm">
                        Iniciar sesión
                    </a>
                    <a href="<?php echo esc_url(wp_registration_url()); ?>"
                       class="btn btn-outline-secondary btn-sm">
                        Registrarse
                    </a>
                <?php endif; ?>
            </div>

        </div>
    </div>
</nav>

<!-- Contenido principal (templates lo abren y cierran) -->

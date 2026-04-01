<?php
/**
 * 404.php — Página de error "no encontrado"
 */
get_header();
?>

<main class="container py-5 text-center">
    <div class="py-5">
        <p class="display-1 fw-bold text-gradient-accent">404</p>
        <h1 class="h2 fw-bold mb-3">Página no encontrada</h1>
        <p class="text-body-secondary mb-4">
            La página que buscas no existe o ha sido movida.
        </p>
        <a href="<?php echo esc_url(home_url('/')); ?>"
           class="btn btn-accent btn-lg">
            Volver al inicio
        </a>
    </div>
</main>

<?php get_footer(); ?>

<?php
/**
 * index.php — Plantilla de fallback requerida por WordPress
 *
 * Redirige al archive en caso de que no haya una plantilla más específica.
 * En la práctica, front-page.php y archive.php cubren todos los casos.
 */
get_header();
?>

<main class="container py-5">

    <h1 class="fw-bold mb-4">
        <span class="text-gradient-accent">Artículos</span>
    </h1>

    <?php if (have_posts()) : ?>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <?php while (have_posts()) : the_post(); ?>
                <div class="col">
                    <?php get_template_part('template-parts/article-card'); ?>
                </div>
            <?php endwhile; ?>
        </div>

        <?php get_template_part('template-parts/pagination'); ?>

    <?php else : ?>

        <div class="alert alert-secondary">
            No hay contenido disponible.
        </div>

    <?php endif; ?>

</main>

<?php get_footer(); ?>

<?php
/**
 * front-page.php — Portada del sitio
 *
 * Muestra el hero section y los 6 artículos más recientes.
 */
get_header();
?>

<?php get_template_part('template-parts/hero'); ?>

<main class="container py-5">

    <h2 class="fw-bold mb-4">
        <span class="text-gradient-accent">Artículos destacados</span>
    </h2>

    <?php
    $featured = webroblox_featured_articles_query();

    if ($featured->have_posts()) :
    ?>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <?php while ($featured->have_posts()) : $featured->the_post(); ?>
                <div class="col">
                    <?php get_template_part('template-parts/article-card'); ?>
                </div>
            <?php endwhile; ?>
        </div>

        <div class="text-center mt-5">
            <a href="<?php echo esc_url(get_post_type_archive_link('post')); ?>"
               class="btn btn-outline-secondary btn-lg">
                Ver todos los artículos →
            </a>
        </div>

    <?php else : ?>
        <div class="alert alert-secondary">
            No hay artículos publicados todavía.
        </div>
    <?php endif; ?>

    <?php wp_reset_postdata(); ?>

</main>

<?php get_footer(); ?>

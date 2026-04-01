<?php
/**
 * archive.php — Grid de artículos por categoría con paginación
 *
 * Usado en /category/trucos/, /category/guias/, /category/noticias/
 * y en el archivo general de posts.
 */
get_header();
?>

<main class="container py-5">

    <!-- Título de la categoría -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="<?php echo esc_url(home_url('/')); ?>">Inicio</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    <?php
                    if (is_category()) {
                        single_cat_title();
                    } else {
                        echo 'Todos los artículos';
                    }
                    ?>
                </li>
            </ol>
        </nav>

        <h1 class="fw-bold">
            <?php
            if (is_category()) {
                echo '<span class="text-gradient-accent">';
                single_cat_title();
                echo '</span>';
            } else {
                echo '<span class="text-gradient-accent">Todos los artículos</span>';
            }
            ?>
        </h1>
    </div>

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

        <div class="alert alert-secondary mt-4">
            No hay artículos en esta categoría todavía.
        </div>

    <?php endif; ?>

</main>

<?php get_footer(); ?>

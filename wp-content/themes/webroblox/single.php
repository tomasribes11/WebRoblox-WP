<?php
/**
 * single.php — Vista de artículo individual
 *
 * Muestra el contenido completo, breadcrumb, categoría, fecha y contador
 * de visitas.
 */
get_header();
the_post();

$categories  = get_the_category();
$category    = $categories[0] ?? null;
$view_count  = webroblox_get_view_count(get_the_ID());
$thumbnail   = get_the_post_thumbnail_url(null, 'full');
?>

<main class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="<?php echo esc_url(home_url('/')); ?>">Inicio</a>
                    </li>
                    <?php if ($category) : ?>
                        <li class="breadcrumb-item">
                            <a href="<?php echo esc_url(get_term_link($category)); ?>">
                                <?php echo esc_html($category->name); ?>
                            </a>
                        </li>
                    <?php endif; ?>
                    <li class="breadcrumb-item active" aria-current="page">
                        <?php the_title(); ?>
                    </li>
                </ol>
            </nav>

            <!-- Categoría badge -->
            <?php if ($category) : ?>
                <span class="badge bg-accent mb-3">
                    <?php echo esc_html($category->name); ?>
                </span>
            <?php endif; ?>

            <!-- Título -->
            <h1 class="fw-bold mb-3"><?php the_title(); ?></h1>

            <!-- Extracto -->
            <?php if (has_excerpt()) : ?>
                <p class="lead text-body-secondary mb-3">
                    <?php the_excerpt(); ?>
                </p>
            <?php endif; ?>

            <!-- Meta: visitas + fecha -->
            <div class="d-flex gap-3 text-body-secondary small mb-3">
                <span>👁 <?php echo esc_html($view_count); ?> visitas</span>
                <span>📅 <?php the_date('d M Y'); ?></span>
            </div>

            <hr class="mb-4">

            <!-- Imagen destacada -->
            <?php if ($thumbnail) : ?>
                <img
                    src="<?php echo esc_url($thumbnail); ?>"
                    alt="<?php echo esc_attr(get_the_title()); ?>"
                    class="img-fluid rounded mb-4 w-100"
                    style="max-height: 400px; object-fit: cover;"
                >
            <?php endif; ?>

            <!-- Contenido del artículo -->
            <article class="article-content">
                <?php the_content(); ?>
            </article>

            <hr class="mt-4 mb-4">

            <!-- Volver a la categoría -->
            <?php if ($category) : ?>
                <a
                    href="<?php echo esc_url(get_term_link($category)); ?>"
                    class="btn btn-outline-secondary"
                >
                    ← Volver a <?php echo esc_html($category->name); ?>
                </a>
            <?php else : ?>
                <a href="<?php echo esc_url(home_url('/')); ?>"
                   class="btn btn-outline-secondary">
                    ← Volver al inicio
                </a>
            <?php endif; ?>

        </div>
    </div>
</main>

<?php get_footer(); ?>

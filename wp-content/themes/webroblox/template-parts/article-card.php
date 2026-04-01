<?php
/**
 * template-parts/article-card.php — Tarjeta de artículo reutilizable
 *
 * Usa el $post global del loop activo.
 */
$categories   = get_the_category();
$category     = $categories[0] ?? null;
$thumbnail    = get_the_post_thumbnail_url(null, 'article-card');
$view_count   = webroblox_get_view_count(get_the_ID());
$date         = get_the_date('d M Y');
?>
<div class="card h-100 shadow-sm article-card border-0">

    <?php if ($thumbnail) : ?>
        <img
            src="<?php echo esc_url($thumbnail); ?>"
            class="card-img-top"
            alt="<?php echo esc_attr(get_the_title()); ?>"
            style="height: 180px; object-fit: cover;"
            loading="lazy"
        >
    <?php else : ?>
        <div class="card-img-placeholder">🎮</div>
    <?php endif; ?>

    <div class="card-body d-flex flex-column">

        <?php if ($category) : ?>
            <span class="badge bg-accent mb-2 align-self-start">
                <?php echo esc_html($category->name); ?>
            </span>
        <?php endif; ?>

        <h5 class="card-title fw-bold">
            <?php the_title(); ?>
        </h5>

        <p class="card-text text-body-secondary flex-grow-1">
            <?php echo wp_trim_words(get_the_excerpt(), 20, '…'); ?>
        </p>

        <div class="d-flex justify-content-between align-items-center mt-3">
            <small class="text-body-secondary">
                👁 <?php echo esc_html($view_count); ?> visitas
            </small>
            <a
                href="<?php the_permalink(); ?>"
                class="btn btn-accent btn-sm"
            >
                Leer más
            </a>
        </div>

    </div>
</div>

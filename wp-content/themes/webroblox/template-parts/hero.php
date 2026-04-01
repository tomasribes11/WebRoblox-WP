<?php
/**
 * template-parts/hero.php — Sección hero de la portada
 */
?>
<section class="hero-section text-center py-5">
    <div class="container py-4">
        <h1 class="display-4 fw-bold text-gradient-accent mb-3">
            🎮 Mundo Roblox
        </h1>
        <p class="lead text-body-secondary mb-4">
            Tu lugar para aprender y mejorar en el mundo Roblox
        </p>
        <a
            href="<?php echo esc_url(webroblox_category_link('trucos')); ?>"
            class="btn btn-accent btn-lg px-5"
        >
            Ver artículos
        </a>
    </div>
</section>

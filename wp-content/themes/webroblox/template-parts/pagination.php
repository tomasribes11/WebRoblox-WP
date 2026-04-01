<?php
/**
 * template-parts/pagination.php — Paginación Bootstrap
 */
$links = paginate_links([
    'type'      => 'array',
    'prev_text' => '←',
    'next_text' => '→',
]);

if (!$links) {
    return;
}
?>
<nav class="mt-5 d-flex justify-content-center" aria-label="Paginación">
    <ul class="pagination gap-1">
        <?php foreach ($links as $link) : ?>
            <li class="page-item">
                <?php echo str_replace('page-numbers', 'page-numbers page-link', $link); ?>
            </li>
        <?php endforeach; ?>
    </ul>
</nav>

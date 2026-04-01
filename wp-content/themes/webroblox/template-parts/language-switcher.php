<?php
/**
 * template-parts/language-switcher.php — Selector de idioma (Polylang)
 */
$langs = webroblox_language_switcher_data();

if (empty($langs)) {
    return;
}

$active_lang = array_filter($langs, fn($l) => $l['active']);
$active      = reset($active_lang);
?>
<div class="dropdown">
    <button
        class="btn btn-outline-secondary btn-sm dropdown-toggle"
        type="button"
        data-bs-toggle="dropdown"
        aria-expanded="false"
        aria-label="Seleccionar idioma"
    >
        <?php echo esc_html($active['flag'] ?? ''); ?>
        <?php echo esc_html($active['name'] ?? 'ES'); ?>
    </button>
    <ul class="dropdown-menu dropdown-menu-end">
        <?php foreach ($langs as $lang) : ?>
            <li>
                <a
                    class="dropdown-item <?php echo $lang['active'] ? 'active' : ''; ?>"
                    href="<?php echo esc_url($lang['url']); ?>"
                    <?php echo $lang['active'] ? 'aria-current="true"' : ''; ?>
                >
                    <?php echo esc_html($lang['flag']); ?>
                    <?php echo esc_html($lang['name']); ?>
                </a>
            </li>
        <?php endforeach; ?>
    </ul>
</div>

<?php
/**
 * functions.php — Bootstrap del tema webroblox
 *
 * Carga los módulos en orden. No contiene lógica directamente.
 */

require get_template_directory() . '/inc/setup.php';
require get_template_directory() . '/inc/enqueue.php';
require get_template_directory() . '/inc/view-count.php';
require get_template_directory() . '/inc/polylang.php';
require get_template_directory() . '/inc/custom-queries.php';

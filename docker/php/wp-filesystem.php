<?php
/**
 * WordPress Filesystem Configuration for Docker
 * Fix permissions issues with updates and translations
 */

// Force direct filesystem method for WordPress updates
if (!defined('FS_METHOD')) {
    define('FS_METHOD', 'direct');
}

// Set proper permissions for created files
if (!defined('FS_CHMOD_FILE')) {
    define('FS_CHMOD_FILE', 0644);
}

// Set proper permissions for created directories
if (!defined('FS_CHMOD_DIR')) {
    define('FS_CHMOD_DIR', 0755);
}

// Ensure WordPress knows it's running on a proper system
if (!defined('WP_TEMP_DIR')) {
    define('WP_TEMP_DIR', '/var/www/html/wp-content/tmp');
}

?>

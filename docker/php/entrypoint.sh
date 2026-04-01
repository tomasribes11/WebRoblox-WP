#!/bin/sh
# Entrypoint script for WordPress PHP-FPM container
# Ensures proper directory structure and permissions

# Create necessary directories if they don't exist
mkdir -p /var/www/html/wp-content/uploads
mkdir -p /var/www/html/wp-content/upgrade
mkdir -p /var/www/html/wp-content/cache
mkdir -p /var/www/html/wp-content/tmp

# Set ownership and permissions only for the directories we created
chown www-data:www-data /var/www/html/wp-content/uploads
chown www-data:www-data /var/www/html/wp-content/upgrade
chown www-data:www-data /var/www/html/wp-content/cache
chown www-data:www-data /var/www/html/wp-content/tmp

chmod 755 /var/www/html/wp-content/uploads
chmod 755 /var/www/html/wp-content/upgrade
chmod 755 /var/www/html/wp-content/cache
chmod 755 /var/www/html/wp-content/tmp

# Execute the original entrypoint
exec docker-entrypoint.sh "$@"

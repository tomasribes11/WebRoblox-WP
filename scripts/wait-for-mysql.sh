#!/bin/sh
# Espera hasta que MySQL acepte conexiones con las credenciales de la aplicación.
# Usa mysqli (garantizado en wordpress:cli-php8.2) en lugar de mysqladmin.

DB_HOST=$(echo "${WORDPRESS_DB_HOST}" | cut -d: -f1)

echo "Esperando MySQL en ${DB_HOST}..."
until php -r "
\$c = @mysqli_connect('${DB_HOST}', '${WORDPRESS_DB_USER}', '${WORDPRESS_DB_PASSWORD}', '${WORDPRESS_DB_NAME}');
if (\$c) { mysqli_close(\$c); exit(0); }
exit(1);
" 2>/dev/null; do
    echo "  MySQL no disponible todavía, reintentando en 3s..."
    sleep 3
done
echo "MySQL listo."

#!/bin/sh
# Espera hasta que MySQL acepte conexiones

DB_HOST=$(echo "${WORDPRESS_DB_HOST}" | cut -d: -f1)

echo "Esperando MySQL en ${DB_HOST}..."
until mysqladmin ping -h"${DB_HOST}" \
    -u"${WORDPRESS_DB_USER}" \
    -p"${WORDPRESS_DB_PASSWORD}" \
    --silent 2>/dev/null; do
    echo "  MySQL no disponible todavía, reintentando en 3s..."
    sleep 3
done
echo "MySQL listo."

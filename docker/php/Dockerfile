FROM wordpress:php8.2-fpm

# Instalar extensión intl (el resto ya viene en la imagen wordpress oficial)
RUN apt-get update && apt-get install -y \
        libicu-dev \
        default-mysql-client \
    && docker-php-ext-install intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ajustes PHP personalizados
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY wp-filesystem.php /var/www/html/wp-config-filesystem.php

# Asegurar permisos correctos en wp-content y subdirectorios
RUN mkdir -p /var/www/html/wp-content/uploads \
    && mkdir -p /var/www/html/wp-content/upgrade \
    && mkdir -p /var/www/html/wp-content/cache \
    && mkdir -p /var/www/html/wp-content/tmp \
    && chown -R www-data:www-data /var/www/html/wp-content \
    && chmod -R 755 /var/www/html/wp-content

# Configurar PHP-FPM para correr como www-data
RUN sed -i 's/^user = .*/user = www-data/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^group = .*/group = www-data/' /usr/local/etc/php-fpm.d/www.conf

# Asegurar que el proceso principal no cambie de usuario
# (los workers ya correrán como www-data por la configuración anterior)

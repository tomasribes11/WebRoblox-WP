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

# Asegurar permisos correctos en uploads
RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content/uploads

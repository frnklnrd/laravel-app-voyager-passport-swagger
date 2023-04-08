FROM php:8.1-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && \
    apt-get install -y libicu-dev && \
    docker-php-ext-install pdo pdo_mysql intl && \
    a2enmod rewrite

RUN apt-get update && apt-get install -y \
        nano \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        graphviz \
        build-essential \
        locales \
        zip \
        jpegoptim optipng pngquant gifsicle \
        vim \
        git \
        curl

RUN docker-php-ext-install pdo_mysql pdo_pgsql zip exif pcntl gd

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

#---------------------------------------------------------

WORKDIR /var/www/html

COPY . /var/www/html/

#---------------------------------------------------------

RUN chown -R www-data:www-data /var/www/html/storage

RUN chmod -R 777 /var/www/html/storage

RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php

RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-ansi --no-dev --no-interaction --no-progress --optimize-autoloader --no-scripts

RUN composer require tcg/voyager

#---------------------------------------------------------

# ENTRYPOINT \
#            cd /var/www/html/ \
#            && . ./docker-configure.sh

#---------------------------------------------------------

CMD ["apache2-foreground"]

FROM php:8.3-fpm
RUN docker-php-ext-install pdo_mysql
COPY php/public/ /var/www/html/
COPY php/src/ /var/www/src/
COPY php/zz-app.conf /usr/local/etc/php-fpm.d/zz-app.conf

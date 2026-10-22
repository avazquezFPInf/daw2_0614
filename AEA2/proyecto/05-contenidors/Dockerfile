FROM php:8.3-apache
RUN docker-php-ext-install pdo_mysql
COPY 03-bdd/src /var/www/src
COPY 03-bdd/public/ /var/www/html/

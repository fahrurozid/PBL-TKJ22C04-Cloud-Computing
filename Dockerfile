FROM php:8.1-apache

COPY public/ /var/www/html/
COPY css/ /var/www/html/css/
COPY js/ /var/www/html/js/
COPY images/ /var/www/html/images/
COPY monitoring/ /var/www/html/monitoring/

RUN chmod -R 755 /var/www/html

RUN a2enmod rewrite

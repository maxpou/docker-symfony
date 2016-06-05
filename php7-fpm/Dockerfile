# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM php:7.0-fpm

MAINTAINER Purinda Gunasekara <purinda@gmail.com>

RUN apt-get update && apt-get install -y \
    git \
    mysql-client \
    unzip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Default DB container connection configuration
RUN echo '\
[client]\n\
host="$${DB_PORT_3306_TCP_ADDR}"\n\
user=root\n\
password="$${DB_ENV_MYSQL_ROOT_PASSWORD}"\n'\
>> ~/.my.cnf

# Setup an alias for phpunit which will create the test database for the application to use if doesnt exist.
RUN echo '\
#!/bin/bash\n\
mysql -e "CREATE DATABASE IF NOT EXISTS $${DB_ENV_MYSQL_DATABASE}_test"\n\
mysql -e "GRANT ALL PRIVILEGES ON *.* TO \'$${DB_ENV_MYSQL_USER}\'@\'%\'"\n\
php /var/www/laravel/vendor/bin/phpunit\n'\
>> /bin/phpunit

# Set timezone to UTC
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime
RUN "date"

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www/laravel
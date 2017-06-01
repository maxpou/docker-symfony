# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM php:7.0-fpm

MAINTAINER Mariano Egui <mariano@handerr.com>
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zlib1g-dev \
    libbz2-dev \
    libmcrypt-dev \
    libxml2-dev \
    libmagickwand-dev \
    libssl-dev

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - ; apt-get install -y nodejs
RUN npm --version
RUN npm install -g less uglify-js uglifycss yarn

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN "date"

RUN pecl install xdebug
RUN pecl install zip
RUN pecl install imagick
# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql zip soap pcntl


# install xdebug
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable zip
RUN docker-php-ext-enable soap
RUN docker-php-ext-enable imagick
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


RUN echo 'alias sf="php app/console"' >> ~/.bashrc
RUN echo 'alias sf3="php bin/console"' >> ~/.bashrc
RUN echo 'alias sf3db="sf3 doctrine:database:drop --force && sf3 doctrine:database:create && sf3 doctrine:schema:update --force --no-interaction && sf3 doctrine:fixtures:load --no-interaction"' >> ~/.bashrc
RUN echo 'alias sf3static="npm run install-dependencies && sf3 bazinga:js-translation:dump && sf3 assets:install --symlink && sf3 assetic:dump"' >> ~/.bashrc

WORKDIR /var/www/symfony

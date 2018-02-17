# See https://github.com/docker-library/php/blob/master/7.1/fpm/Dockerfile
FROM php:7.0-fpm
ARG TIMEZONE

MAINTAINER Florian Ajir <florian@tag-walk.com>

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    curl \
    ftp\
    geoip-database \
    git \
    libav-tools \
    libtool \
    make \
    nasm \
    npm \
    openssl \
    python-geoip \
    unzip
#&& rm -rf /var/lib/apt/lists/*

#RUN apt-get install -y -qq npm
RUN ln -s /usr/bin/nodejs /usr/bin/node

# install bower & grunt
RUN npm install -g bower grunt-cli
RUN echo '{ "allow_root": true }' > /root/.bowerrc

# Imagick
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get install -y --no-install-recommends \
        libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick-3.4.3
RUN docker-php-ext-enable imagick

WORKDIR /source
COPY mozjpeg-3.2-release-source.tar.gz /source
# mozjpeg
RUN tar -zxf /source/mozjpeg-3.2-release-source.tar.gz \
    && mv mozjpeg /opt \
    && cd /opt/mozjpeg \
    && autoreconf -fiv \
    && ./configure --prefix=/opt/mozjpeg \
    && make install

COPY wkhtmltox-0.12.4_linux-generic-i386.tar.xz /source
RUN tar -xJf /source/wkhtmltox-0.12.4_linux-generic-i386.tar.xz -C /opt

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql ftp

# install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo 'alias sf="php app/console"' >> ~/.bashrc
RUN echo 'alias sf3="php bin/console"' >> ~/.bashrc

WORKDIR /var/www
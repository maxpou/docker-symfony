FROM debian:stretch-slim

LABEL creator="Maxence POUTORD <maxence.poutord@gmail.com>"
LABEL maintainer="Julien DE CONTI <julien.de.conti@gmail.com>"

RUN apt-get update && apt-get install -y nginx

ADD nginx.conf /etc/nginx/
ADD symfony.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony \
    && rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

CMD ["nginx"]

EXPOSE 80
EXPOSE 443

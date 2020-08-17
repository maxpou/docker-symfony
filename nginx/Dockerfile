FROM debian:jessie

MAINTAINER Maxence POUTORD <maxence.poutord@gmail.com>

RUN apt-get update && apt-get install -y \
    software-properties-common wget

# Import openresty key
RUN wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add -

RUN add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty"
RUN apt-get update
RUN apt-get install -y openresty

RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled/ /etc/nginx/conf.d
ADD fastcgi_params /etc/nginx/
ADD mime.types /etc/nginx/
ADD nginx.conf /etc/nginx/
ADD symfony.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony \
&& rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]

EXPOSE 80
EXPOSE 443

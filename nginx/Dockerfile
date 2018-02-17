FROM debian:jessie

MAINTAINER FLORIAN AJIR <florian@tag-walk.com>

RUN apt-get update && apt-get install -y \
    nginx \
    openssl

# https support
RUN rm -rf /etc/nginx/conf.d/*;
RUN sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf; \
    sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf; \
    sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf

ADD nginx.conf /etc/nginx/
ADD tagwalk-www.conf /etc/nginx/sites-available/
ADD tagwalk-admin.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/tagwalk-www.conf /etc/nginx/sites-enabled/tagwalk-www
RUN ln -s /etc/nginx/sites-available/tagwalk-admin.conf /etc/nginx/sites-enabled/tagwalk-admin
RUN rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

CMD ["nginx"]

EXPOSE 80 443

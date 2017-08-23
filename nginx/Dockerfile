FROM debian:jessie

RUN apt-get update && apt-get install -y nginx

# Configure Nginx
ADD nginx.conf /etc/nginx/
ADD symfony.conf /etc/nginx/sites-available/
RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf
RUN usermod -u 1000 www-data

# Configure the virtual host
RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony
RUN rm /etc/nginx/sites-enabled/default

# Run Nginx
CMD ["nginx"]

EXPOSE 80
EXPOSE 443

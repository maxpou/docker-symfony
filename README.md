# Docker Laravel (PHP7-FPM - NGINX - MySQL - ELK - REDIS)

[![Build Status](https://travis-ci.org/purinda/docker-laravel.svg?branch=master)](https://travis-ci.org/purinda/docker-laravel)

*Credit: this is a fork from [maxpou/docker-symfony](https://github.com/maxpou/docker-symfony). Thanks to him :-)*

![](http://www.maxpou.fr/images/articles/symfony-docker/schema.png)

## Installation

1. Retrieve git project

    ```bash
    $ git clone git@github.com:purinda/docker-laravel.git
    ```

2. Symlink your Laravel/Lumen project into app folder (`ln -s <absolute-path-of-laravel-project> app`)
3. Build containers with (with and without detached mode)

    ```bash
    $ docker-compose up
    $ docker-compose up -d
    ```

4. Update your host file (add app.dev)

    ```bash
    # get containers IP address and update host (replace IP according to your configuration )
    $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=nginx -q)
    $ sudo echo "171.17.0.1 app.dev" >> /etc/hosts
    ```

If you use `docker-machine` then run the following to get IP address of the vm. 

    ```bash
    $ docker-machine ip <machine-name> 
    $ sudo echo "171.17.0.1 app.dev" >> /etc/hosts
    ```

5. Prepare Laravel/Lumen app
    1. Update app/.env (adapt hosts according to previous results)

        ```ini
        DB_CONNECTION=mysql
        DB_DATABASE=laravel
        DB_DATABASE_TEST=laravel_test
        DB_HOST=app.dev
        DB_PORT=3306
        DB_USERNAME=laravel
        DB_PASSWORD=laravel
        ```

    2. Composer install

        ```yml
        $ docker-compose exec php composer install
        ```

6. Enjoy :-)

## Using

* Laravel app: visit [app.dev](http://app.dev)  
* Logs (Kibana): [app.dev:81](http://app.dev:81)
* Logs (files location): logs/nginx and logs/laravel

## How it works?

Have a look at the `docker-compose.yml` file, here are the `docker-compose` built images:

* `application`: This is the Laravel or Lumen application code container,
* `db`: This is the MySQL database container,
* `php`: This is the PHP-FPM container in which the application volume is mounted,
* `nginx`: This is the Nginx webserver container in which application volume is mounted too,
* `elk`: This is a ELK stack container which uses Logstash to collect logs, send them into Elasticsearch and visualize them with Kibana,
* `redis`: This is a redis database container.

This results in the following running containers:

```bash
$ docker-compose ps
           Name                          Command               State              Ports            
--------------------------------------------------------------------------------------------------
dockerlaravel_application_1   /bin/bash                        Up                                  
dockerlaravel_db_1            /entrypoint.sh mysqld            Up      0.0.0.0:3306->3306/tcp      
dockerlaravel_elk_1           /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp          
dockerlaravel_nginx_1         nginx                            Up      443/tcp, 0.0.0.0:80->80/tcp
dockerlaravel_php_1           php-fpm                          Up      0.0.0.0:9000->9000/tcp      
dockerlaravel_redis_1         /entrypoint.sh redis-server      Up      0.0.0.0:6379->6379/tcp      
```

## Useful commands

```bash
# Composer (e.g. composer update)
$ docker exec -ti $(docker ps -f name=php -q) sh -c  "cd /var/www/laravel/ && composer update"

# SF commands
$ docker exec -ti $(docker ps -f name=php -q) php /var/www/laravel/app/console cache:clear

# bash commands
$ docker exec -ti $(docker ps -f name=php -q) /bin/bash

# MySQL commands
$ docker exec -ti $(docker ps -f name=db -q) mysql -uroot -p"root"

# Redis commands
$ docker exec -ti $(docker ps -f name=redis -q) sh -c 'exec redis-cli'

# F***ing cache/logs folder
$ sudo chmod -R 777 app/storage/cache app/storage/logs

# Check CPU consumption
$ docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))

# Delete all containers
$ docker rm $(docker ps -a -q)

# Delete all images
$ docker rmi $(docker images -q)
```


## TODO

- [ ] Upgrade ELK stack. Install [Timelion](https://github.com/elastic/timelion) <3
- [ ] MySQL -> PostgreSQL
- [ ] Move SF app folder?
- [ ] use php7-fpm/php.ini

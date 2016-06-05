# Docker Laravel (LEMP stack with PHP7, ELK, REDIS)

[![Build Status](https://travis-ci.org/purinda/docker-laravel.svg?branch=master)](https://travis-ci.org/purinda/docker-laravel)

**The idea of the project is to provide a pre-configured docker platform for Laravel and Lumen apps to get them up and running fast.**

*Credit: this is a kind of fork from [maxpou/docker-symfony](https://github.com/maxpou/docker-symfony). Thanks to him :-)* 
I have made the number of changes to work with Laravel or Lumen apps and modified platform level commands (`artisan`, `composer`, `mysql`) quite easy to access.

![Container Architecture](https://raw.githubusercontent.com/purinda/docker-laravel/master/docs/container-architecture.png)

## Installation

I assume you have `docker-compose` installed and either **docker-engine** running locally (Linux) or have **docker-machine** (OSX, Windows) 
configured on the computer you use.

1. Retrieve git project

    ```bash
    $ git clone git@github.com:purinda/docker-laravel.git
    ```

2. Change directory to the `docker-laravel` (`cd docker-laravel`)

3. Symlink your Laravel/Lumen project into app folder (`ln -s <absolute-path-of-laravel-project> app`)

4. Build and start containers in detached mode.

    ```bash
    $ docker-compose up -d
    ```

5. Update your host file (add `app.dev`)

    ```bash
    # get containers IP address and update host (replace IP according to your configuration )
    $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=nginx -q)
    $ sudo echo "10.211.55.7 app.dev" >> /etc/hosts
    ```

    If you use `docker-machine` (mainly OSX or Windows) then run the following to get IP address of the vm. 

    ```bash
    $ docker-machine ip <machine-name> 
    $ sudo echo "10.211.55.7 app.dev" >> /etc/hosts
    ```


6. Prepare Laravel/Lumen app
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

7. Enjoy :-)

## How to use

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
dockerlaravel_db_1            docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp
dockerlaravel_elk_1           /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp
dockerlaravel_nginx_1         nginx                            Up      443/tcp, 0.0.0.0:80->80/tcp
dockerlaravel_php_1           php-fpm                          Up      9000/tcp
dockerlaravel_redis_1         docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp   
```

## Useful commands

```bash
# Composer (e.g. composer update)
$ docker-compose exec php composer update

# Laravel Artisan commands
$ docker-compose exec php ./artisan

# bash commands
$ docker-compose exec php /bin/bash

# MySQL commands
$ docker-compose exec db mysql -uroot -p"toor" laravel

# Redis commands
$ docker-compose exec redis redis-cli

# Cache/logs folder permissions (use open permissions for development only)
$ chmod -R 777 app/storage/cache app/storage/logs

```

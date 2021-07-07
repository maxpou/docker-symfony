# Docker Laravel (LEMP stack with PHP7, ELK, REDIS)

[![Build Status](https://travis-ci.com/purinda/docker-laravel.svg?branch=master)](https://travis-ci.com/purinda/docker-laravel)

**The idea of the project is to provide a pre-configured docker platform for Laravel and Lumen apps to get them up and running fast.**

*Credit: this is a fork from [maxpou/docker-symfony](https://github.com/maxpou/docker-symfony). Thanks to him :-)* 
I have made the number of changes to work with Laravel or Lumen apps and modified platform level commands (`artisan`, `composer`, `mysql`) quite easy to access.

![Container Architecture](https://raw.githubusercontent.com/purinda/docker-laravel/master/docs/container-architecture.png)

## Installation

I assume you have `docker-compose` installed and either **docker-engine** running locally (Linux) or have **docker-machine** (installed via [docker-toolbox](https://www.docker.com/products/docker-toolbox) on OSX, Windows) 
configured on the computer you use. _NOTE: if you use docker-machine (deprecated project so recommend not to) you may need to use the docker-machine IP address instead of `localhost` URLs mentioned below_

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

5. Prepare Laravel/Lumen app
    1. Update app/.env (adapt hosts according to previous results)

        ```ini
        # Docker database configuration
        DB_CONNECTION=mysql
        DB_DATABASE=laravel
        DB_DATABASE_TEST=laravel_test
        DB_HOST=db
        DB_PORT=3306
        DB_USERNAME=laravel
        DB_PASSWORD=laravel

        # Docker SMTP MailCatcher configuration
        MAIL_DRIVER=smtp
        MAIL_HOST=mailcatcher
        MAIL_PORT=25
        MAIL_FROM_ADDRESS=docker@local
        MAIL_FROM_NAME="Docker"
        ```

    2. Composer install

        ```yml
        $ docker-compose exec php composer install
        ```

6. Enjoy 😀

## How to use

* Laravel app: visit [localhost](http://localhost)
* Logs (Kibana): [localhost:81](http://localhost:81)
* Logs (files location): logs/nginx and logs/laravel
* MailCatcher: [localhost:82](http://localhost:82)
 - For instructions please refer to https://mailcatcher.me/

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
            Name                          Command               State                                     Ports
--------------------------------------------------------------------------------------------------------------------------------------------------
docker-laravel_application_1   /bin/sh                          Up
docker-laravel_db_1            docker-entrypoint.sh mysqld      Up      3306/tcp
docker-laravel_elk_1           /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp,:::81->80/tcp
docker-laravel_mailcatcher_1   /bin/sh -c mailcatcher -f  ...   Up      0.0.0.0:25->1025/tcp,:::25->1025/tcp, 0.0.0.0:82->1080/tcp,:::82->1080/tcp
docker-laravel_nginx_1         nginx                            Up      443/tcp, 0.0.0.0:80->80/tcp,:::80->80/tcp
docker-laravel_php_1           docker-php-entrypoint php-fpm    Up      9000/tcp
docker-laravel_redis_1         docker-entrypoint.sh redis ...   Up      6379/tcp
```

## Useful commands

```bash
# Composer (e.g. composer update)
$ docker-compose exec php composer update

# Laravel Artisan commands (make sure `artisan` script in the app has executable permissions bit set)
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

## Running PHPUnit

In order to run the application test suite, it is required to run `phpunit` which runs against the test database of the 
application layer.

The script `setup-phpunit.sh` sets up the test database in the `db` container and grants required permission for the application
test suite.

Script needs docker-machine environment variables (`docker-machine env <machine-name>`) to be set if you are running 
containers on `docker-machine`. Run the script on `docker-laravel` project directory as below. The script will copy itself into
the db container and set up the required configuration.
    
    ./setup-phpunit.sh
    
Lastly, run the unit test suite

    docker-compose exec php php vendor/bin/phpunit

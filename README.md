# Docker Symfony (PHP7-FPM - NGINX - MySQL - ELK - REDIS)

[![Build Status](https://travis-ci.org/maxpou/docker-symfony.svg?branch=master)](https://travis-ci.org/maxpou/docker-symfony)

![](http://www.maxpou.fr/images/articles/symfony-docker/schema-v2.png)

Docker-symfony gives you everything you need for developing Symfony application. This complete stack run with docker and [docker-compose (1.7 or higher)](https://docs.docker.com/compose/).

## Installation

1. In the docker-compose file, indicate where's your Symfony project

    ```yml
    services:
        php:
            volumes:
                - path/to/your/symfony-project:/var/www/symfony
    ```

2. Build/run containers with (with and without detached mode)

    ```bash
    $ docker-compose build
    $ docker-compose up
    $ docker-compose up -d
    ```

3. Update your system host file (add symfony.dev)

    ```bash
    # get containers IP address and update host (replace IP according to your configuration)
    $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=nginx -q)
    # unix only (on Windows, edit C:\Windows\System32\drivers\etc\hosts)
    $ sudo echo "171.17.0.1 symfony.dev" >> /etc/hosts
    ```

    **Note:** If it's empty, run `docker inspect $(docker ps -f name=nginx -q) | grep IPAddress` instead.

4. Prepare Symfony app
    1. Retrieve DB&Redis IP

        ```bash
        $ docker inspect --format '{{ .NetworkSettings.Networks.dockersymfony_default.IPAddress }}' $(docker ps -f name=db -q)
        $ docker inspect --format '{{ .NetworkSettings.Networks.dockersymfony_default.IPAddress }}' $(docker ps -f name=redis -q)
        ```

        **Note:** If it's empty, run `docker inspect $(docker ps -f name=db -q) | grep IPAddress` instead.

    2. Update app/config/parameters.yml

        ```yml
        # path/to/your/symfony-project/app/config/parameters.yml
        parameters:
            database_host: mysqldb
            database_password: root
            #...
            redis_host: redis
        ```

    3. Composer install & create database

        ```bash
        $ docker-compose exec php bash
        $ composer install
        # Symfony2
        $ sf doctrine:database:create
        $ sf doctrine:schema:update --force
        $ sf doctrine:fixtures:load --no-interaction
        # Symfony3
        $ sf3 doctrine:database:create
        $ sf3 doctrine:schema:update --force
        $ sf3 doctrine:fixtures:load --no-interaction
        ```

5. Enjoy :-)

## Usage

Just run `docker-compose -d`, then:

* Symfony app: visit [symfony.dev](http://symfony.dev)  
* Symfony dev mode: visit [symfony.dev/app_dev.php](http://symfony.dev/app_dev.php)  
* Logs (Kibana): [symfony.dev:81](http://symfony.dev:81)
* Logs (files location): logs/nginx and logs/symfony

## How it works?

Have a look at the `docker-compose.yml` file, here are the `docker-compose` built images:

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
dockersymfony_db_1            /entrypoint.sh mysqld            Up      0.0.0.0:3306->3306/tcp      
dockersymfony_elk_1           /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp          
dockersymfony_nginx_1         nginx                            Up      443/tcp, 0.0.0.0:80->80/tcp
dockersymfony_php_1           php-fpm                          Up      0.0.0.0:9000->9000/tcp      
dockersymfony_redis_1         /entrypoint.sh redis-server      Up      0.0.0.0:6379->6379/tcp      
```

## Useful commands

```bash
# bash commands
$ docker-compose exec php bash

# Composer (e.g. composer update)
$ docker-compose exec php composer update

# SF commands (Tips: there is an alias inside php container)
$ docker-compose exec php php /var/www/symfony/app/console cache:clear # Symfony2
$ docker-compose exec php php /var/www/symfony/bin/console cache:clear # Symfony3
# Same command by using alias
$ docker-compose exec php bash
$ sf cache:clear

# MySQL commands
$ docker-compose exec db mysql -uroot -p"root"

# Redis commands
$ docker-compose exec redis redis-cli

# F***ing cache/logs folder
$ sudo chmod -R 777 app/cache app/logs # Symfony2
$ sudo chmod -R 777 var/cache var/logs # Symfony3

# Check CPU consumption
$ docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))

# Delete all containers
$ docker rm $(docker ps -aq)

# Delete all images
$ docker rmi $(docker images -q)
```

## FAQ

* How I can add PHPMyAdmin?  
Simply add this: (then go to [symfony.dev:8080](http://symfony.dev:8080))

```
phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
        - "8080:80"
    links:
        - db
```

* Got this error: `ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?
If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.` ?  
Run `docker-compose up -d` instead.

* Permission problem? See [this doc (Setting up Permission)](http://symfony.com/doc/current/book/installation.html#checking-symfony-application-configuration-and-setup)

## Contributing

First of all, **thank you** for contributing ♥  
If you find any typo/misconfiguration/... please send me a PR or open an issue. You can also ping me on [twitter](https://twitter.com/_maxpou).  
Also, while creating your Pull Request on GitHub, please write a description which gives the context and/or explains why you are creating it.


## TODO

- [ ] Upgrade ELK stack + install [Timelion](https://github.com/elastic/timelion) plugin <3

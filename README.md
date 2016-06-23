# Docker Symfony (PHP7-FPM - NGINX - MySQL - ELK - REDIS)

[![Build Status](https://travis-ci.org/maxpou/docker-symfony.svg?branch=master)](https://travis-ci.org/maxpou/docker-symfony)

*Credit: this is a kind of fork from [eko/docker-symfony](https://github.com/eko/docker-symfony). Thanks to him :-)*

![](http://www.maxpou.fr/images/articles/symfony-docker/schema.png)

## Installation

1. Retrieve git project

    ```bash
    $ git clone https://github.com/maxpou/docker-symfony
    ```

2. Move your Symfony project into symfony folder
3. Build containers with (with and without detached mode)

    ```bash
    $ docker-compose up
    $ docker-compose up -d
    ```

4. Update your host file (add symfony.dev)

    ```bash
    # get containers IP address and update host (replace IP according to your configuration)
    $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=nginx -q)
    $ sudo echo "171.17.0.1 symfony.dev" >> /etc/hosts
    ```

5. Prepare Symfony app
    1. Retrieve DB&Redis IP

        ```bash
        $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=db -q)
        $ docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -f name=redis -q)
        ```

        **Note:** If it's empty, run `docker inspect $(docker ps -f name=db -q) | grep IPAddress` instead.

    2. Update app/paraeters.yml (adapt hosts according to previous results)

        ```yml
        parameters:
            redis_host: 172.17.0.3
            database_host: 172.17.0.4
            database_port: null
            database_name: symfony
            database_user: root
            database_password: root
        ```

    3. Composer install & create database

        ```yml
        $ docker-compose exec php composer install
        $ sf doctrine:database:createsf doctrine:database:create
        $ sf doctrine:schema:update --force
        $ sf doctrine:fixtures:load --no-interaction
        ```

6. Enjoy :-)

## Using

* Symfony app: visit [symfony.dev](http://symfony.dev)  
* Symfony dev mode: visit [symfony.dev/app_dev.php](http://symfony.dev/app_dev.php)  
* Logs (Kibana): [symfony.dev:81](http://symfony.dev:81)
* Logs (files location): logs/nginx and logs/symfony

## How it works?

Have a look at the `docker-compose.yml` file, here are the `docker-compose` built images:

* `application`: This is the Symfony application code container,
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
dockersymfony_application_1   /bin/bash                        Up                                  
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
$ docker-compose exec php php /var/www/symfony/app/console cache:clear
# Same command by using alias
$ docker-compose exec php bash
$ sf cache:clear

# MySQL commands
$ docker-compose exec db mysql -uroot -p"root"

# Redis commands
$ docker-compose exec redis redis-cli

# F***ing cache/logs folder
$ sudo chmod -R 777 app/cache app/logs

# Check CPU consumption
$ docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))

# Delete all containers
$ docker rm $(docker ps -aq)

# Delete all images
$ docker rmi $(docker images -q)
```

## FAQ

* Got this error: `ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?
If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.` ?  
Run `docker-compose up -d` instead.

* Permission problem? See [this doc (Setting up Permission)](http://symfony.com/doc/current/book/installation.html#checking-symfony-application-configuration-and-setup)

* How I can add PHPMyAdmin?  
Simply add this: (then go to [symfony.dev:8080](http://symfony.dev:8080))

    ```
    phpmyadmin:
       image: corbinu/docker-phpmyadmin
       ports :
        - "8080:80"
       environment:
        - MYSQL_USERNAME=root
        - MYSQL_PASSWORD=root
       links:
        - db:mysql
    ```

## TODO

- [ ] Add DNS/use network! (and avoid retrieving ip each time)
- [ ] Remove SF app container!
- [ ] Update diagram:
    * indicate ES/Kibana ports
    * remove code container
- [ ] SF app parameters: fix misconfiguration (use environment variable instead)

    ```
    database_port: null
    database_name: symfony
    database_user: root
    database_password: root
    ```

- [ ] Upgrade ELK stack + install [Timelion](https://github.com/elastic/timelion) plugin <3
- [ ] Remove links (deprecated)

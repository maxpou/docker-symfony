# Docker Symfony (PHP7-FPM - NGINX - MySQL - ELK)

[![Build Status](https://travis-ci.org/maxpou/docker-symfony.svg?branch=master)](https://travis-ci.org/maxpou/docker-symfony)

![](doc/schema.png)

Docker-symfony gives you everything you need for developing Symfony application. This complete stack run with docker and [docker-compose (1.7 or higher)](https://docs.docker.com/compose/).

## Installation

1. Create a `.env` from the `.env.dist` file. Adapt it according to your symfony application

    ```bash
    cp .env.dist .env
    ```

2. import database

    To load an SQL dump during the docker init process you have de place your dump file in the `./sql` folder

3. Build/run containers with (with and without detached mode)

    ```bash
    $ docker-compose build
    $ docker-compose up -d
    ```

4. Update your system host file (add tag-walk.dev)

    ```bash
    # UNIX only: get containers IP address and update host (replace IP according to your configuration) (on Windows, edit C:\Windows\System32\drivers\etc\hosts)
    $ sudo echo $(docker network inspect bridge | grep Gateway | grep -o -E '[0-9\.]+') "symfony.local" >> /etc/hosts
    ```

    **Note:** For **OS X**, please take a look [here](https://docs.docker.com/docker-for-mac/networking/) and for **Windows** read [this](https://docs.docker.com/docker-for-windows/#/step-4-explore-the-application-and-run-examples) (4th step).

5. Prepare Symfony apps
    1. Update app/config/parameters.yml

        ```yml
        # path/to/your/symfony-project/app/config/parameters.yml
        parameters:
            database_host: db
        ```

    2. Composer install & create database (both apps)

        ```bash
        $ docker-compose exec php bash
        $ composer install
        $ npm install
        $ bower install
        $ cd web/vendor/video.js && npm install && grunt dist
        $ cd ../../..
        $ grunt
        $ php app/console cache:clear
        $ php app/console cache:clear --env=prod --no-debug
        ```
        
6. Configure FTP server (or use existing one)

    ```bash
    docker-compose exec ftpd bash
    /usr/sbin/ftpasswd --passwd --file=/etc/proftpd/ftpd.passwd --name=tagwalk --uid=1000 --gid=1000 --home=/home/ftp --shell=/bin/false
    ```

7. Generate selfsigned ssl cert on nginx

    ```bash
    docker-compose exec nginx bash
    cd /etc/nginx/ssl
    openssl genrsa -des3 -out server.key 1024
    openssl req -new -key server.key -out server.csr
    cp server.key server.key.org
    openssl rsa -in server.key.org -out server.key
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    ```
    

## Usage

Just run `docker-compose up -d`, then:

* Front (www) app: [tag-walk.dev](http://tag-walk.dev)  
* Front (www) dev mode: [tag-walk.dev/app_dev.php](http://tag-walk.dev/app_dev.php)  
* Back (admin) app: [admin.tag-walk.dev](https://admin.tag-walk.dev)  
* Back (admin) dev mode: [admin.tag-walk.dev/app_dev.php](http://admin.tag-walk.dev/app_dev.php)  
* Elasticsearch index: [tag-walk.dev:9200](http://tag-walk.dev:9200)
* Logs (Kibana): [tag-walk.dev:5601](http://tag-walk.dev:5601)
* Logs (files location): logs/nginx and logs/symfony

## Granting database user connections from remote hosts

```bash
$ docker-compose exec db mysql -uroot -p"root"
$ GRANT ALL PRIVILEGES ON *.* TO 'tagwalk'@'%' IDENTIFIED BY 'tagwalk' WITH GRANT OPTION;
```

## Customize

If you want to add optionnals containers like Redis, PHPMyAdmin... take a look on [doc/custom.md](doc/custom.md).

## How it works?

Have a look at the `docker-compose.yml` file, here are the `docker-compose` built images:

* `db`: This is the MySQL database container,
* `php`: This is the PHP-FPM container in which the application volume is mounted,
* `nginx`: This is the Nginx webserver container in which application volume is mounted too,
* `elk`: This is a ELK stack container which uses Logstash to collect logs, send them into Elasticsearch and visualize them with Kibana.

This results in the following running containers:

```bash
$ docker-compose ps
        Name                       Command               State                                Ports
---------------------------------------------------------------------------------------------------------------------------------
dockersymfony_db_1      docker-entrypoint.sh --max ...   Up      3306/tcp
dockersymfony_elk_1     /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp
dockersymfony_ftpd_1    proftpd --nodaemon               Up      0.0.0.0:32769->1220/tcp, 0.0.0.0:32768->1281/tcp, 20/tcp, 21/tcp
dockersymfony_nginx_1   nginx                            Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp
dockersymfony_php_1     docker-php-entrypoint php-fpm    Up      9000/tcp
```

## Useful commands

```bash
# bash commands
$ docker-compose exec php bash

# Retrieve an IP Address (here for the nginx container)
$ docker inspect --format '{{ .NetworkSettings.Networks.dockersymfony_default.IPAddress }}' $(docker ps -f name=nginx -q)
$ docker inspect $(docker ps -f name=nginx -q) | grep IPAddress

# MySQL commands
$ docker-compose exec db mysql -uroot -p"root"

# Check CPU consumption
$ docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))

# Delete all containers
$ docker rm $(docker ps -aq)

# Delete all images
$ docker rmi $(docker images -q)

# List docker volume
$ docker volume ls

# Delete docker data volume
$ docker volume rm dockersymfony_data-volume
```

## FAQ

* Got this error: `ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?
If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.` ?  
Run `docker-compose up -d` instead.

* Permission problem? See [this doc (Setting up Permission)](http://symfony.com/doc/current/book/installation.html#checking-symfony-application-configuration-and-setup)

* How to config Xdebug?
Xdebug is configured out of the box!
Just config your IDE to connect port  `9001` and id key `PHPSTORM`

## Contributing

First of all, **thank you** for contributing ♥  
If you find any typo/misconfiguration/... please send me a PR or open an issue. You can also ping me on [twitter](https://twitter.com/_maxpou).  
Also, while creating your Pull Request on GitHub, please write a description which gives the context and/or explains why you are creating it.

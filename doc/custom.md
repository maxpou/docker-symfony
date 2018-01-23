# How to customise this stack

* [Add PHPMyAdmin](#Add-phpmyadmin)
* [Add Redis](#Add-redis)

## Add PHPMyAdmin

1. Update docker-compose.yml file and add the following lines:

    ```yml
    service:
        # ...
        phpmyadmin:
            image: phpmyadmin/phpmyadmin
            ports:
                - "8080:80"
    ```

2. Visit: [symfony.local:8080](http://symfony.local:8080)

## Add Redis

1. Update docker-compose.yml file and add the following lines:

    ```yml
    service:
        # ...
        redis:
            image: redis:alpine
            ports:
                - 6379:6379
    ```

2. Adapt your Symfony configuration file

    ```yml
    # path/to/your/symfony-project/app/config/parameters.yml
    parameters:
        #...
        redis_host: redis
    ```

:question: Using [SncRedis](https://github.com/snc/SncRedisBundle)?  
Your Symfony config file should be like this:

```yml
snc_redis:
    clients:
        default:
            type: predis
            alias: default
            dsn: redis://%redis_host%
```

Access to redis-cli with:

```bash
# Redis commands
$ docker-compose exec redis redis-cli
```

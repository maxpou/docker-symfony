FROM mariadb:10.1

MAINTAINER Purinda Gunasekara <purinda@gmail.com>

VOLUME /var/lib/mysql

# Copy modified mariadb docker-entrypoint.sh with additional test db creation
# Refer to https://github.com/docker-library/mariadb/blob/master/10.1/Dockerfile
COPY docker-entrypoint.sh /usr/local/bin/

# Backwards compat
RUN ln -sf /usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["setup-my-cnf"]
CMD ["mysqld"]
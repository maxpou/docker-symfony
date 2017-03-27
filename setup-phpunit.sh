#!/usr/bin/env bash
set -eo pipefail
SCRIPT=`basename "$0"`

#
# Following condition determines the behaviour of the script.
# - If NOT within the container, script copies itself to the container
# - If within the container, script runs the commands
#
if [ -z "$MARIADB_MAJOR" ]; then
    # Copy the setup command to the database container and run
    DB_CONTAINER=$(docker-compose ps | grep db | cut -d " " -f1)
    docker cp $SCRIPT "$DB_CONTAINER:/"
    docker-compose exec db bash /$SCRIPT

    echo Laravel db setup installed and ran successfully
else
    # Write default mysql params for easier access without specifying mysql connection params in the CLI
    { \
        echo "[client]"; \
        echo "host='localhost'"; \
        echo "database=$MYSQL_DATABASE"; \
        echo "password=$MYSQL_ROOT_PASSWORD"; \
    } >> /root/.my.cnf

    # Setup Laravel test database and grant permissions
    if [ "$TEST_DB_NAME" ]; then
        mysql -e "CREATE DATABASE IF NOT EXISTS \`$TEST_DB_NAME\`";

        if [ "$TEST_DB_NAME" ]; then
            mysql -e "GRANT ALL ON \`$TEST_DB_NAME\`.* TO '$MYSQL_USER'@'%'";
        fi
    fi

    if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
        mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'";

        if [ "$MYSQL_DATABASE" ]; then
            mysql -e "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%'";
        fi

        mysql -e 'FLUSH PRIVILEGES';
    fi
fi

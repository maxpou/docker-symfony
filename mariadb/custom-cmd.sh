#!/bin/bash
set -eo pipefail

# Write default mysql params for easier access without specifying mysql connection params in the CLI
if [ "$1" = 'setup-my-cnf' ]; then
    { \
        echo "[client]"; \
        echo "host='localhost'"; \
        echo "database=$MYSQL_DATABASE"; \
        echo "password=$MYSQL_ROOT_PASSWORD"; \
    } >> /root/.my.cnf
fi




if [ "$TEST_DB_NAME" ]; then
    echo "CREATE DATABASE IF NOT EXISTS \`$TEST_DB_NAME\` ;" | "${mysql[@]}"
    mysql+=( "$TEST_DB_NAME" )
fi


if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
    echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" | "${mysql[@]}"

    if [ "$MYSQL_DATABASE" ]; then
        echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
    fi

    if [ "$TEST_DB_NAME" ]; then
        echo "GRANT ALL ON \`$TEST_DB_NAME\`.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
    fi

    echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
fi

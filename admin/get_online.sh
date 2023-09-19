#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

MYSQL_COMMAND="SELECT players_online FROM stats;"
ONLINE=$(mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD $MYSQL_NAME -e "$MYSQL_COMMAND")

echo $ONLINE | sed 's/[^0-9]*//g' 
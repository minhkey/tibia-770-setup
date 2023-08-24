#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

read -e -p "Enter a unique user ID (e.g., 1001): " ID
read -e -p "Enter a unique login number (e.g., 123456): " LOGIN
read -e -p "Enter account email: " EMAIL
read -s -e -p "Enter account password: " TMP
PASSWORD=$(echo -n $TMP | openssl sha256 | awk '{print $2}')
unset $TMP # just in case, we don't want this hanging around
echo ""
read -e -p "Enter userlevel (0 = player, 1 = premium, 50 = tutor, 100 = gamemaster, 255 = god): " USERLEVEL

MYSQL_COMMAND="INSERT INTO \`users\` (\`id\`, \`login\`, \`email\`, \`passwd\`, \`userlevel\`) VALUES ($ID, $LOGIN, '$EMAIL', '$PASSWORD', $USERLEVEL);"

read -e -p "The following query will be executed on MySQL:

${MYSQL_COMMAND}

Confirm? (y/N) 
" CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "Aborted by user."
    exit 1
fi

mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD $MYSQL_NAME -e "$MYSQL_COMMAND"


echo ""
echo "Done!"

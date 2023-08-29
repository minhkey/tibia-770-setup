#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo "---------------------------------------------------------------------------------------------"
echo "Adding new user..."
echo "---------------------------------------------------------------------------------------------"
echo ""

read -e -p "Enter a unique user ID (e.g., 1001): " ID
read -e -p "Enter a unique account/login number (e.g., 123456): " LOGIN
read -e -p "Enter e-mail: " EMAIL

echo "Generating random password..."
TMP=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c25)
echo "Hashing password..."
PASSWORD=$(echo -n $TMP | openssl sha512 | awk '{print $2}')
echo "Done!"
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
echo "---------------------------------------------------------------------------------------------"
echo "Created a new user with the following data:"
echo ""
echo "User ID:              $ID"
echo "Account/login number: $LOGIN"
echo "E-mail:               $EMAIL"
echo "Password:             $TMP"
echo "Userlevel:            $USERLEVEL"
echo "---------------------------------------------------------------------------------------------"

unset $TMP

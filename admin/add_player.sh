#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Adding new player..."
echo "---------------------------------------------------------------------------------------------"
echo ""

read -e -p "Enter a unique player ID (e.g., 1001; note, this is used in 'houses' table): " PLAYER_ID
read -e -p "Enter a unique account ID (e.g., 112233; note, this is used in 'owners.dat'): " ACCOUNT_ID
read -e -p "Enter account number (e.g., 123456; must correspond to 'login' in 'users' table): " ACCOUNT_NUMBER
read -e -p "Enter the name of the new char: " CHAR_NAME
read -e -p "Enter gender, 0 = female or 1 = male: " GENDER

MYSQL_COMMAND="INSERT INTO \`players\` (\`player_id\`, \`charname\`, \`account_id\`, \`account_nr\`, \`gender\`) VALUES ($PLAYER_ID, '$CHAR_NAME', $ACCOUNT_ID, $ACCOUNT_NUMBER, $GENDER);"

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
echo "Created a new player with the following data:"
echo ""
echo "Player ID:            $PLAYER_ID"
echo "Account ID:           $ACCOUNT_ID"
echo "Account/login number: $ACCOUNT_NUMBER"
echo "Name:                 $CHAR_NAME"
echo "Gender:               $GENDER"
echo ""
echo "Note that the account number ($ACCOUNT_NUMBER)"
echo "corresponds login number in 'users' table"
echo "---------------------------------------------------------------------------------------------"

#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Creating new guild..."
echo "---------------------------------------------------------------------------------------------"
echo ""

read -e -p "Enter a unique guild ID (e.g., 10001): " GUILD_ID
read -e -p "Enter guild name: " GUILD_NAME
read -e -p "Enter guild owner (account ID): " OWNER_ACC_ID
read -e -p "Enter rank 1: " RANK_1
read -e -p "Enter rank 2: " RANK_2
read -e -p "Enter rank 3: " RANK_3

MYSQL_COMMAND="INSERT INTO \`guilds\` (\`guild_id\`, \`guild_name\`, \`guild_owner\`, \`rank_1\`, \`rank_2\`, \`rank_3\`) VALUES ($GUILD_ID, '$GUILD_NAME', $OWNER_ACC_ID, '$RANK_1', '$RANK_2', '$RANK_3');"

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
echo "Created a new guild with the following data:"
echo ""
echo "Guild ID:            $GUILD_ID"
echo "Guild name:          $GUILD_NAME"
echo "Owner account ID:    $OWNER_ACC_ID"
echo "Rank 1:              $RANK_1"
echo "Rank 2:              $RANK_2"
echo "Rank 3:              $RANK_3"
echo ""
echo "---------------------------------------------------------------------------------------------"

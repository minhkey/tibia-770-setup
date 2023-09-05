#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Adding member to guild..."
echo "---------------------------------------------------------------------------------------------"
echo ""

read -e -p "Enter a unique entry ID (e.g., 1): " ENTRY_ID
read -e -p "Enter player account ID (e.g., 100001): " ACCOUNT_ID
read -e -p "Enter guild ID (e.g., 1): " GUILD_ID
read -e -p "Enter guild rank name: " GUILD_TITLE
read -e -p "Enter numerical rank (should correspond to rank name): " RANK

TIMESTAMP=$(date --date="yesterday" +"%s")

MYSQL_COMMAND="INSERT INTO \`guild_members\` (\`entry_id\`, \`account_id\`, \`guild_id\`, \`guild_title\`, \`timestamp\`, \`guildrank\`) VALUES ($ENTRY_ID, $ACCOUNT_ID, $GUILD_ID, '$GUILD_TITLE', $TIMESTAMP, $RANK);"

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
echo "Added player ID $ACCOUNT_ID to:"
echo ""
echo "Guild ID:            $GUILD_ID"
echo "Entry ID:            $ENTRY_ID"
echo "Guild rank name:     $GUILD_TITLE"
echo "Guild rank number:   $RANK"
echo ""
echo "---------------------------------------------------------------------------------------------"

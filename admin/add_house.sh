#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Adding new house to player..."
echo "---------------------------------------------------------------------------------------------"
echo ""

read -e -p "Enter house name (exactly as it says in-game, without quotes): " HOUSE_NAME
read -e -p "Enter account ID: " ACCOUNT_ID
read -e -p "Enter player ID: " PLAYER_ID
read -e -p "Enter player name: " PLAYER_NAME 
read -e -p "Enter world name: " WORLD_NAME

# get house ID
HOUSE_ID=$(cat /home/game/dat/houses.dat | grep -B1 "$HOUSE_NAME" | grep "ID" | tr -d -c 0-9)

# UNIX times
YESTERDAY_UNIX=$(date --date="yesterday" +"%s")
FUTURE_UNIX=1900000000

# insert data into owners.dat
echo "ID = $HOUSE_ID" >> /home/game/dat/owners.dat
echo "Owner = $ACCOUNT_ID" >> /home/game/dat/owners.dat
echo "LastTransition = $YESTERDAY_UNIX" >> /home/game/dat/owners.dat
echo "PaidUntil = $FUTURE_UNIX" >> /home/game/dat/owners.dat
echo "Guests = {}" >> /home/game/dat/owners.dat
echo "Subowners = {}" >> /home/game/dat/owners.dat
echo "" >> /home/game/dat/owners.dat

# insert into SQL table
MYSQL_COMMAND="INSERT INTO \`houses\` (\`house_id\`, \`player_id\`, \`owner_string\`, \`worldname\`, \`guests\`, \`subowners\`) VALUES ($HOUSE_ID, $PLAYER_ID, '$OWNER_STRING', '$WORLD_NAME', '', '');"

read -e -p "The following command will be executed on MySQL:

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

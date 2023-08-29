#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Editing player..."
echo "---------------------------------------------------------------------------------------------"
echo ""

read -e -p "Enter player ID to edit (e.g., 1001): " PLAYER_ID

ACCOUNT_ID=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N "SELECT account_id FROM players WHERE player_id='$PLAYER_ID'"`
ACCOUNT_NUMBER=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N "SELECT account_nr FROM players WHERE player_id='$PLAYER_ID'"`
CHAR_NAME=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N "SELECT charname FROM players WHERE player_id='$PLAYER_ID'"`
GENDER=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N "SELECT gender FROM players WHERE player_id='$PLAYER_ID'"`

echo ""
echo "Player with ID $PLAYER_ID has the following data:"
echo ""
echo "Account ID:                    $ACCOUNT_ID"
echo "Account/login number:          $ACCOUNT_NUMBER"
echo "Character name:                $CHAR_NAME"
echo "Gender (0 = female, 1 = male): $GENDER"
echo ""

PS3="What do you want to edit?"
options=("Account ID", "Account/login number" "Character name" "Gender" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Account ID")
            read -e -p "Enter new account ID (e.g. 112233): " ACCOUNT_ID_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE players SET account_id = \"${ACCOUNT_ID_NEW}\" WHERE player_id = \"${PLAYER_ID}\""
            break
            ;;
        "Account/login number")
            read -e -p "Enter new account/login number (e.g. 123456): " ACCOUNT_NUMBER_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE players SET account_nr = \"${ACCOUNT_NUMBER_NEW}\" WHERE player_id = \"${PLAYER_ID}\""
            break
            ;;
        "Character name")
            read -e -p "Enter new character name: " CHAR_NAME_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE players SET charname = \"${CHAR_NAME_NEW}\" WHERE player_id = \"${PLAYER_ID}\""
            break
            ;;
        "Gender")
            read -e -p "Enter new gender (0 = female, 1 = male): " GENDER_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE players SET gender = \"${GENDER_NEW}\" WHERE player_id = \"${PLAYER_ID}\""
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

echo "Done!"

#!/bin/bash

if ! service mysql status > /dev/null; then
    echo "MySQL service is not running. Please start it before running this script."
    exit 1
fi

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Editing user..."
echo "---------------------------------------------------------------------------------------------"
echo ""

#"SELECT \`login\` FROM \`users\` WHERE \`id\`=$ID"
read -e -p "Enter user ID to edit (e.g., 1001): " ID

LOGIN=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N -e "SELECT login FROM users WHERE id='$ID'"`
EMAIL=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N -e "SELECT email FROM users WHERE id='$ID'"`
PASSWORD=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N -e "SELECT passwd FROM users WHERE id='$ID'"`
USERLEVEL=`mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -s -N -e "SELECT userlevel FROM users WHERE id='$ID'"`

echo ""
echo "User with ID $ID has the following data:"
echo ""
echo "Account/login number: $LOGIN"
echo "E-mail:               $EMAIL"
echo "Password (hashed):    $PASSWORD"
echo "Userlevel:            $USERLEVEL"
echo ""

PS3="What do you want to edit? "
options=("Account/login number" "E-mail" "Password" "Userlevel" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Account/login number")
            read -e -p "Enter new account/login number (e.g. 123456): " LOGIN_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE users SET login = \"${LOGIN_NEW}\" WHERE id = \"${ID}\""
            break
            ;;
        "E-mail")
            read -e -p "Enter new e-mail: " EMAIL_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE users SET email = \"${EMAIL_NEW}\" WHERE id = \"${ID}\""
            break
            ;;
        "Password")
            read -e -p -s "Enter new password: " TMP
            PASSWORD_NEW=$(echo -n $TMP | openssl sha512 | awk '{print $2}')
            unset $TMP
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE users SET passwd = \"${PASSWORD_NEW}\" WHERE id = \"${ID}\""
            break
            ;;
        "Userlevel")
            read -e -p "Enter new userlevel (0 = player, 1 = premium, 50 = tutor, 100 = gamemaster, 255 = god): " USERLEVEL_NEW
            mysql -u $MYSQL_NAME -p$MYSQL_PASSWORD -D $MYSQL_NAME -e "UPDATE users SET userlevel = \"${USERLEVEL_NEW}\" WHERE id = \"${ID}\""
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

echo "Done!"

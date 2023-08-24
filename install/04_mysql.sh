#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Configuring MySQL..."
echo "---------------------------------------------------------------------------------------------"
echo ""

# create a new user using environment variaables
sudo service mysql status | grep "active (running)" || echo "MySQL is not running. Please start it manually after the intallation."
sudo mysql -u root -p$MYSQL_PASSWORD -e "CREATE USER '$MYSQL_NAME'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON *.* to '$MYSQL_NAME'@'%' WITH GRANT OPTION; CREATE DATABASE $MYSQL_NAME;"

# load schema and fix IP
tar -xvzf resources/otserv-schema.tar.gz -C resources
sudo mysql -u$MYSQL_NAME -p$MYSQL_PASSWORD $MYSQL_NAME < resources/otserv-schema.sql
sudo sed -i "s/^bind-address.*/bind-address = $LOCAL_IP/g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# delete existing players from db
echo "delete from users;" | mysql -D$MYSQL_NAME -u$MYSQL_NAME -p$MYSQL_PASSWORD
echo "delete from players;" | mysql -D$MYSQL_NAME -u$MYSQL_NAME -p$MYSQL_PASSWORD

# run secure install
# (requires user input)
sudo mysql_secure_installation

# clean up
rm resources/otserv-schema.sql

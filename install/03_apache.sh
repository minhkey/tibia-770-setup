#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Configuring Apache..."
echo "---------------------------------------------------------------------------------------------"
echo ""

sudo ufw allow in "Apache Full"
sudo ufw allow 7171/tcp
sudo ufw allow 7172/tcp

sudo service apache2 status | grep "active (running)" || echo "Apache is not running, please start manually after installation."
sudo systemctl restart apache2

# no need for default site 
sudo rm -rf /var/www/html

# copy/create configs and restart
sudo mkdir -p /etc/apache2/sites-available
sudo mkdir -p /var/www/atlantis

echo "SetEnv MYSQL_NAME \"$MYSQL_NAME\"" > /home/$USER/sql.cnf
echo "SetEnv MYSQL_PASSWORD \"$MYSQL_PASSWORD\"" >> /home/$USER/sql.cnf
echo "SetEnv MYSQL_DB \"$MYSQL_NAME\"" >> /home/$USER/sql.cnf

sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak 
sudo cp /home/$USER/tibia-770-setup/configs/apache2.conf /etc/apache2/apache2.conf 
sudo cp /home/$USER/tibia-770-setup/configs/atlantis.conf /etc/apache2/sites-available/atlantis.conf 

sudo systemctl restart apache2

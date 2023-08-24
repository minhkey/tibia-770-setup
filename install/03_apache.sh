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

# no need for an index file
sudo rm -f /var/www/html/index.html

# copy config and restart
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak 
sudo cp /home/$USER/tibia-770-setup/configs/apache2.conf /etc/apache2/apache2.conf 
sudo systemctl restart apache2

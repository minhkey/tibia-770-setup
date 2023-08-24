#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Creating MySQL credentials and setting necessary environment variables..."
echo "---------------------------------------------------------------------------------------------"
echo ""

# create random MySQL credentials
TMP=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c25); echo $(eval echo 'export MYSQL_NAME=$TMP' >> ~/.bashrc)
TMP=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c50); echo $(eval echo 'export MYSQL_PASSWORD=$TMP' >> ~/.bashrc)

# trick to reload .bashrc so we can access environment variables
eval "$(cat ~/.bashrc | tail -n +10)"

# "softcoded" variables, feel free to change
MOTD="Welcome to Atlantis"
SERVER_NAME="Atlantis"

# "hardcoded" variables, do not change these!
GAME_PATH="/home/game"
PORT=17778
LOCAL_IP=$(hostname -I | cut -d' ' -f1)
IFS='.' read -ra LOCAL_IP_PARTS <<< "$LOCAL_IP"
CORES=$(grep -Pc '^processor\t' /proc/cpuinfo)

# create some extra directories
cd /home/$USER/tibia-770-setup
mkdir -p pids logs backup
cd

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Running through install scripts..."
echo "---------------------------------------------------------------------------------------------"
echo ""

source /home/$USER/tibia-770-setup/install/01_dependencies.sh
source /home/$USER/tibia-770-setup/install/02_game.sh
source /home/$USER/tibia-770-setup/install/03_apache.sh
source /home/$USER/tibia-770-setup/install/04_mysql.sh
source /home/$USER/tibia-770-setup/install/05_query.sh
source /home/$USER/tibia-770-setup/install/06_login.sh

# set execute permissions
sudo chmod +x /home/$USER/tibia-770-setup/admin/start_services.sh

# set ssh port rate limit if not already done
sudo ufw limit OpenSSH comment "SSH port rate limit"

# set correct timezone
# (list timezones with timedatectl list-timezones)
sudo timedatectl set-timezone Europe/Stockholm

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Configuring fail2ban..."
echo "---------------------------------------------------------------------------------------------"
echo ""

# get an additional filter for SQL injection protection
cd /home/$USER/tibia-770-setup/configs
wget https://raw.githubusercontent.com/AbhishekGhosh/Fail2Ban-Apache-WordPress-Extra/master/apache-sqlinject.conf
sudo cp apache-sqlinject.conf /etc/fail2ban/filter.d/
cd

# copy fail2ban jail
sudo cp /home/$USER/tibia-770-setup/configs/jail.local /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo systemctl status fail2ban

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Done!"
echo "---------------------------------------------------------------------------------------------"
echo ""

#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Installing dependencies and utilities..."
echo "---------------------------------------------------------------------------------------------"
echo ""

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    build-essential cmake g++ curl wget unrar git apt-transport-https ufw \
    fail2ban ranger htop \
    lib32z1 libpugixml-dev \
    apache2 mysql-server libmysqlclient-dev \
    libgmp-dev libgmp3-dev libmpfr-dev \
    libboost-all-dev libboost-system-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-filesystem-dev \
    lua5.1 libluajit-5.1-dev liblua5.1-0-dev

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Installing legacy software..."
echo "---------------------------------------------------------------------------------------------"
echo ""

# in order to send messages using game/bin/.gsc, we need support for legacy i386 architecture
sudo dpkg --add-architecture i386 
sudo apt-get update 
sudo apt-get install -y libstdc++5:i386

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Installing R, R packages and Quarto..."
echo "---------------------------------------------------------------------------------------------"
echo ""

sudo apt install -y r-base libssl-dev libcurl4-openssl-dev unixodbc-dev libxml2-dev \
    libmariadb-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
    libpng-dev libtiff5-dev libjpeg-dev

wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-amd64.deb
sudo apt install -y quarto-1.3.450-linux-amd64.deb
rm quarto-1.3.450-linux-amd64.deb

Rscript -e 'install.packages(c("stringi", "here", "tidyverse", "DT", "RMySQL", "DBI"))'

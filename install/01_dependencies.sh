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

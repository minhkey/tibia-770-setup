#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Preparing query manager..."
echo "---------------------------------------------------------------------------------------------"
echo ""

cd
git clone https://github.com/minhkey/realots-query-manager

# fix IP
sudo sed -i "s/^std::string q_world.*/std::string q_world = \"$SERVER_NAME\";/g" realots-query-manager/main.cpp
sudo sed -i "s/htonl(INADDR_LOOPBACK)/inet_addr(\"$LOCAL_IP\")/g" realots-query-manager/main.cpp
sudo sed -i "s/writeMsg.addByte(213);/writeMsg.addByte(${LOCAL_IP_PARTS[0]});/g" realots-query-manager/main.cpp
sudo sed -i "s/writeMsg.addByte(163);/writeMsg.addByte(${LOCAL_IP_PARTS[1]});/g" realots-query-manager/main.cpp
sudo sed -i "s/writeMsg.addByte(67);/writeMsg.addByte(${LOCAL_IP_PARTS[2]});/g" realots-query-manager/main.cpp
sudo sed -i "s/writeMsg.addByte(173);/writeMsg.addByte(${LOCAL_IP_PARTS[3]});/g" realots-query-manager/main.cpp

make -j $CORES -C realots-query-manager

#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Preparing login server..."
echo "---------------------------------------------------------------------------------------------"
echo ""

cd
git clone https://github.com/minhkey/realotsloginserver

mkdir -p realotsloginserver/build
cmake -S realotsloginserver -B realotsloginserver/build
make -j $CORES -C realotsloginserver/build
cp realotsloginserver/build/tfls realotsloginserver

# fix server name and motd
sed -i "s/^serverName = .*/serverName = \"$SERVER_NAME\"/g" realotsloginserver/config.lua
sed -i "s/name=\"RealOTS\"/name=\"$SERVER_NAME\"/g" realotsloginserver/gameservers.xml
sed -i "s/^motd = .*/motd = \"$MOTD\"/g" realotsloginserver/config.lua

# fix IP
sed -i "s/^ip = .*/ip = \"$LOCAL_IP\"/g" realotsloginserver/config.lua
sed -i "s/^mysqlHost = .*/mysqlHost = \"$LOCAL_IP\"/g" realotsloginserver/config.lua
sed -i "s/ip=\"127.0.0.1\"/ip=\"$LOCAL_IP\"/g" realotsloginserver/gameservers.xml

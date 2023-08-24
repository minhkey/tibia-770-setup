#!/bin/bash

# note that the order of starting these processes matter!

GAME_PATH=/home/game

echo "Removing saved PIDs..."
rm -f $GAME_PATH/save/game.pid
rm -f /home/$USER/tibia-770-setup/pids/*

echo "Starting query manager..."
cd /home/$USER/realots-query-manager
nohup ./querymanager > /home/$USER/tibia-770-setup/logs/query.log 2>&1 &
echo $! > /home/$USER/tibia-770-setup/pids/query.pid
cd
sleep 5

echo "Starting game server..."
nohup $GAME_PATH/bin/game > /home/$USER/tibia-770-setup/logs/game.log 2>&1 &
echo $! > /home/$USER/tibia-770-setup/pids/game.pid
sleep 5

echo "Starting login server..."
cd /home/$USER/realotsloginserver
nohup ./tfls > /home/$USER/tibia-770-setup/logs/login.log 2>&1 &
echo $! > /home/$USER/tibia-770-setup/pids/login.pid
cd

echo "Everything is up and running!"

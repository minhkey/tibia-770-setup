#!/bin/bash

# note that the order of stopping these processes matter!

GAME_PATH=/home/game

cd $GAME_PATH/bin
./gsc broadcast "Server is going down for maintenance and upgrades! Please move to a safe area immediately!"
sleep 10
cd

echo "Stopping login server..."
PID=$(cat /home/$USER/tibia-770-setup/pids/login.pid)
kill -SIGTERM $PID
while pidof -x tfls > /dev/null; do 
    sleep 10
done

echo "Stopping game server..."
PID=$(cat $GAME_PATH/save/game.pid)
kill -SIGTERM $PID
while pidof -x game > /dev/null; do 
    echo "Server save still ongoing..."
    sleep 60
done

echo "Stopping query manager..."
PID=$(cat /home/$USER/tibia-770-setup/pids/query.pid)
kill -SIGTERM $PID
while pidof -x querymanager > /dev/null; do 
    sleep 10
done

echo "Removing saved PIDs..."
rm -f $GAME_PATH/save/game.pid
rm -f /home/$USER/tibia-770-setup/pids/*

echo "Done!"

#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Preparing game..."
echo "---------------------------------------------------------------------------------------------"
echo ""

# extract game
sudo mkdir -p $GAME_PATH
cd /home/$USER/tibia-770-setup
sudo tar -xvzf resources/tibia-game.tar.gz -C /home
sudo cp $GAME_PATH/bin/game $GAME_PATH/bin/game.original
sudo cp $GAME_PATH/.tibia $GAME_PATH/.tibia.original

# overwrite with modified game binary in order to use custom (dennis) libraries
tar -xvzf resources/game.tar.gz -C resources
sudo cp resources/game $GAME_PATH/bin
sudo chmod 777 $GAME_PATH/bin/game

# fix paths, server name, IP 
sudo sed -i 's/ = "\/game\// = "\/home\/game\//g' $GAME_PATH/.tibia
sudo sed -i "s/World = \"Zanera\"/World = \"$SERVER_NAME\"/g" $GAME_PATH/.tibia 
sudo sed -i "s/QueryManager = {.*}/QueryManager = {(\"${LOCAL_IP}\",${PORT},\"nXE?\/>j\`\"),(\"${LOCAL_IP}\",${PORT},\"nXE?\/>j\`\"),(\"${LOCAL_IP}\",${PORT},\"nXE?\/>j\`\"),(\"${LOCAL_IP}\",${PORT},\"nXE?\/>j\`\")}/g" $GAME_PATH/.tibia
cp $GAME_PATH/.tibia /home/$USER/.tibia

# fix rebooting
sudo sed -i 'sX#!/bin/shX#!/bin/bashXg' $GAME_PATH/bin/reboot-daily
sudo sed -i 'sXBASE="/game"XBASE="/home/game"Xg' $GAME_PATH/bin/reboot-daily

# extract necessary libraries
tar -xvzf resources/dennis-libraries.tar.gz -C resources
sudo chmod 777 resources/dennis-libraries/*
sudo mv resources/dennis-libraries/* /lib
sudo chown -R $USER /home/game

# clean up
rm $GAME_PATH/save/game.pid
rm -rf resources/dennis-libraries
rm resources/game

# create some nice-to-have backups
cp -r /home/game/mon /home/game/mon.original
cp -r /home/game/map /home/game/map.original

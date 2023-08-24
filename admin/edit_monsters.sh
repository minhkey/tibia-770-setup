#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Editing monsters..."
echo "---------------------------------------------------------------------------------------------"
echo ""

# create various exp variations
cp -r /home/game/mon /home/game/mon.orig
cp -r /home/game/mon /home/game/mon.1x
cp -r /home/game/mon /home/game/mon.2x
cp -r /home/game/mon /home/game/mon.5x
cp -r /home/game/mon /home/game/mon.10x

# create 2x exp monsters
cd /home/game/mon.2x
for FILE in *.mon; do
    awk '/Experience/ {$3=$3*2} 1' "$FILE" > temp_file
    mv temp_file "$FILE"
done

# create 5x exp monsters
cd /home/game/mon.5x
for FILE in *.mon; do
    awk '/Experience/ {$3=$3*5} 1' "$FILE" > temp_file
    mv temp_file "$FILE"
done

# create 10x exp monsters
cd /home/game/mon.10x
for FILE in *.mon; do
    awk '/Experience/ {$3=$3*10} 1' "$FILE" > temp_file
    mv temp_file "$FILE"
done

cd

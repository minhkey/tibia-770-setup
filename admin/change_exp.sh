#!/bin/bash

PS3="Select experience level: "
options=("1x" "2x" "5x" "10x" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "1x")
            echo "Setting experience level to 1x (original)..."
            rm -rf /home/game/mon
            cp -r /home/game/mon.1x /home/game/mon
            break
            ;;
        "2x")
            echo "Setting experience level to 2x..."
            rm -rf /home/game/mon
            cp -r /home/game/mon.2x /home/game/mon
            break
            ;;
        "5x")
            echo "Setting experience level to 5x..."
            rm -rf /home/game/mon
            cp -r /home/game/mon.5x /home/game/mon
            break
            ;;
        "10x")
            echo "Setting experience level to 10x..."
            rm -rf /home/game/mon
            cp -r /home/game/mon.10x /home/game/mon
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

echo "Done!"

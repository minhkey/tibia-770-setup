#!/bin/bash

# "hardcoded" variables, do not change!
GAME_PATH="/home/game"

PS3="What do you want to do? "
options=("Add user" "Add player" "Add house" "Create guild" "Add guildmember" "Edit user" "Edit player" "Modify monsters" "Restore monsters" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Add user")
            source /home/$USER/tibia-770-setup/admin/add_user.sh
            break
            ;;
        "Add player")
            source /home/$USER/tibia-770-setup/admin/add_player.sh
            break
            ;;
        "Add house")
            source /home/$USER/tibia-770-setup/admin/add_house.sh
            break
            ;;
        "Create guild")
            source /home/$USER/tibia-770-setup/admin/create_guild.sh
            break
            ;;
        "Add guildmember")
            source /home/$USER/tibia-770-setup/admin/add_guildmember.sh
            break
            ;;
        "Edit user")
            source /home/$USER/tibia-770-setup/admin/edit_user.sh
            break
            ;;
        "Edit player")
            source /home/$USER/tibia-770-setup/admin/edit_player.sh
            break
            ;;
        "Modify monsters")
            source /home/$USER/tibia-770-setup/admin/modify_monsters.sh
            break
            ;;
        "Restore monsters")
            echo "Restoring monsters to original state..."
            rm -rf /home/game/mon
            cp -r /home/game/mon.original /home/game/mon
            echo "Done!"
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

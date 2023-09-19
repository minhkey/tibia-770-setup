#!/bin/bash

dir=$1
account_id=$2
charname=$3
gender=$4

# copy template to account id
cp /home/$USER/tibia-770-setup/resources/template.usr /home/game/usr/$dir/$account_id.usr

# replace relevant parts of template
sed -i "s/\"Template Character\"/\"$charname\"/g" /home/game/usr/$dir/$account_id.usr
sed -i "s/ID              = 999999/ID              = $account_id/g" /home/game/usr/$dir/$account_id.usr
sed -i "s/Race            = 1/Race            = $gender/g" /home/game/usr/$dir/$account_id.usr

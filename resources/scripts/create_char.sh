#!/bin/bash

dir=$1
account_id=$2
charname=$3
gender=$4

# copy template to account id
cp /home/$USER/tibia-770-setup/resources/template.usr /home/game/usr/$dir/$account_id.usr

# sed charname
sed -i "s/\"Default Character\"/\"$charname\"/g" /home/game/usr/$dir/$account_id.usr

# sed gender
sed -i "s/Race            = 1/Race            = $gender/g" /home/game/usr/$dir/$account_id.usr

#!/bin/bash

echo ""
echo "---------------------------------------------------------------------------------------------"
echo "Modifying monsters..."
echo "---------------------------------------------------------------------------------------------"
echo ""

GAMEPATH="/home/game"

# restore original files first, so we start fresh
cp -r $GAMEPATH/mon $GAMEPATH/mon.prev
rm -rf $GAMEPATH/mon
cp -r $GAMEPATH/mon.original $GAMEPATH/mon

read -e -p "Select experience rate: " EXP_RATE
read -e -p "Select loot amount rate: " AMOUNT_RATE
read -e -p "Select loot chance rate: " CHANCE_RATE

cd $GAMEPATH/mon

# start with experience
for FILE in *.mon; do
    echo "Setting experience rate to $EXP_RATE for $FILE"
    awk -v v1=$EXP_RATE '/Experience/ {$3=$3*v1} 1' "$FILE" > temp_file
    mv temp_file "$FILE"
done

echo "Done!"

# now loot rates
for FILE in *mon; do

    echo "Setting loot amount rate to $AMOUNT_RATE and chance rate to $CHANCE_RATE for $FILE"

    sed -n '/Inventory/,/^$/p' $FILE | tr -d "[:blank:]" | sed 's/Inventory={//g' | sed 's/}//g' | sed 's/(//g' | sed 's/)//g' > tmp.txt

    # is the file non-empty (i.e., does the monster give loot)?
    if [ -s tmp.txt ]; then

        # replace loot data using R
        Rscript --vanilla /home/$USER/tibia-770-setup/admin/change_loot.R $AMOUNT_RATE $CHANCE_RATE

        # does outfile.txt exist (i.e., did the R script work)?
        if [ -e outfile.txt ]; then

            # replace relevant lines in .mon
            FIRST_LINE=$(sed -n '/^Inventory/{=;q;}' "$FILE")
            LAST_LINE=$(sed -n $FIRST_LINE,\${/\}/\{=\;q}} "$FILE")

            sed -e "${FIRST_LINE}r outfile.txt" -e "${FIRST_LINE},${LAST_LINE}d" "$FILE" > temp_file
            mv temp_file "$FILE"
            rm outfile.txt

        else
            echo "Error: R script did not work, skipping..."
        fi
    else
        echo "Error: $FILE does not seem to give loot, skipping..."
    fi
done

echo "Done!"
rm -f tmp.txt
cd

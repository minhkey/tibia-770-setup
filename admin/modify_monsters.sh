#!/bin/bash

read -e -p "Select experience rate: " EXP_RATE
read -e -p "Select loot amount rate: " AMOUNT_RATE
read -e -p "Select loot chance rate: " CHANCE_RATE

cd /home/game/mon

# start with experience
for FILE in *.mon; do
    echo "Changing experience level for: $FILE"
    awk -v v1=$EXP_RATE '/Experience/ {$3=$3*v1} 1' "$FILE" > temp_file
    mv temp_file "$FILE"
done

echo "Done!"

# now loot rates
for FILE in *mon; do

    echo "Changing loot rates for: $FILE"

    sed -n '/Inventory/,/^$/p' $FILE | tr -d "[:blank:]" | sed 's/Inventory={//g' | sed 's/}//g' | sed 's/(//g' | sed 's/)//g' > tmp.txt

    # is the file non-empty (i.e., does the monster give loot)?
    if [ -s tmp.txt ]; then

        # replace loot data using R
        Rscript --vanilla /home/$USER/tibia_770_setup/admin/change_loot.R $AMOUNT_RATE $CHANCE_RATE
        
        # does outfile.txt exist (i.e., did the R script work)?
        if [ -e outfile.txt ]; then

            # replace relevant lines in .mon
            FIRST_LINE=$(sed -n '/^Inventory/{=;q;}' "$FILE")
            NUM_LINES=$(sed -n '/Inventory/,/^$/p ' "$FILE" | wc -l)

            echo $FIRST_LINE
            echo $NUM_LINES

            if [ "$NUM_LINES" -gt 2 ]; then
                LAST_LINE=$(($FIRST_LINE+$NUM_LINES-2))
            elif [ "$NUM_LINES" -eq 2 ]; then
                LAST_LINE=$(($FIRST_LINE+$NUM_LINES))
            else 
                LAST_LINE=$(($FIRST_LINE))
            fi

            echo $LAST_LINE

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

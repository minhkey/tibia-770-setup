#!bin/bash

cp -r /home/game/mon /home/game/mon.original

for FILE in *mon; do

    echo "------------------------------------------------------"
    echo "Editing monster: $FILE"
    echo "------------------------------------------------------"

    sed -n '/Inventory/,/^$/p' $FILE | tr -d "[:blank:]" | sed 's/Inventory={//g' | sed 's/}//g' | sed 's/(//g' | sed 's/)//g' > tmp.txt

    # is the file non-empty (i.e., does the monster give loot)?
    if [ -s tmp.txt ]; then

        # replace loot data using R
        Rscript --vanilla /home/$USER/tibia_770_setup/admin/change_loot.R 10 1
        
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

            echo ""
            echo "Done!"
            echo ""
        else
            echo ""
            echo "Error: R script did not work, aborting..."
            echo ""
        fi
    else
        echo ""
        echo "Monster: $FILE does not seem to give loot, skipping..."
        echo ""
    fi
done

rm -f tmp.txt

#!/bin/bash

present="10 Content={2856 Content={3160 Charges=99, 3155 Charges=99, 3191 Charges=99, 3200 Charges=99, 3198 Charges=99}}}"

cd /home/game/usr

for FILE in $(find . -type f -name "*.usr"); do 

    awk 'index($0,"Inventory"){p=1}p{if(/^$/){exit};print}' $FILE > tmp.txt

    # check if slot is free
    if ! grep -q "10 Content" "tmp.txt"; then

        echo "Slot is free, adding content..."

        # note that count starts at 0
        FIRST_LINE=$(sed -n '/^Inventory/{=;q;}' "$FILE")
        LAST_LINE=$(sed -n '/^Depots/{=;q;}' "$FILE")
        LAST_LINE=$(( LAST_LINE - 1 ))

        # check if inventory is completely empty
        if grep -wq "Inventory   = {}" tmp.txt; then

            echo "Inventory is empty, adding new items..."
            empty="Inventory   = {}"
            emptyreplace="Inventory   = {$present"
            sed -i -e "s/${empty}/${emptyreplace}/g" tmp.txt

        else
            
            echo "Inventory is not empty, appending items..."
            awk '/./{line=$0} END{print line}' tmp.txt > tmp2.txt
            cat tmp2.txt | rev | sed 's/}/,/' | rev > tmp3.txt
            orig=`cat tmp2.txt`
            replace=`cat tmp3.txt`
            sed -i -e "s/${orig}/${replace}/g" tmp.txt
            echo "               $present" >> tmp.txt

        fi

        echo "" >> tmp.txt

        sed -e "${FIRST_LINE}r tmp.txt" -e "${FIRST_LINE},${LAST_LINE}d" "$FILE" > temp_file
        mv temp_file $FILE

        rm -f tmp.txt tmp2.txt tmp3.txt

    else
        echo "Slot is occupied, skipping..."
        rm -f tmp.txt
    fi

done

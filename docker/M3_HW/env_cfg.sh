#!/usr/bin/env bash
#Replace .profile with .bashrc if required

DESTINATION=~/.bashrc
test -f $DESTINATION || touch $DESTINATION
source $DESTINATION
echo "### Exporting evn variables..."

FILE=/node/node_env.txt
test -f $FILE && echo "::::: Node's ENV file '$FILE' loaded..." || "::::: No ENV file found at destination '$FILE'..."
while IFS= read -r line; do
    [ -z "$line" ] && continue
    VAR=$(echo $line | cut -f1 -d"=")
    VALUE=$(echo $line | cut -f2 -d"=")
    
    if [ -z "$VAR" ] || [ "$VAR" != "$VALUE" ]; then
      echo "export $VAR=$VALUE" >> $DESTINATION && echo " - $VAR env added sucessfully!"
    fi
done < $FILE

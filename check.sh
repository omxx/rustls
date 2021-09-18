#!/bin/bash

echo Starting the script execution...
echo

File="../results/medium.txt"
Lines=$(cat $File)

OK="\xE2\x9C\x94"
RED_CROSS="\u274c"

for Line in $Lines; do
   echo "$Line"

   hostname=$(echo "$Line" | sed -e 's|^[^/]*//||' -e 's|/.*$||')

   status=$(echo | cargo run --example tlsclient -- --http "${hostname}" </dev/null 2>/dev/null | grep 'TLS error')

   if [ -n "${status}" ]; then
      echo -e "${RED_CROSS} ${hostname} failed TLS cert check"
      echo
   else
      echo -e "${OK} ${hostname} is valid"
      echo "$Line" >>../results/final.txt
      echo
   fi

done

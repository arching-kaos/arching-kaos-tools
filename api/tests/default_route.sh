#!/bin/bash
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
curl http://127.0.0.1:8610 2>/dev/null | jq > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

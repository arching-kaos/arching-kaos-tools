#!/bin/bash
#

PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
printf "TEST\t/see\n"
printf "\t01:\tOutput is valid JSON format..."
curl http://127.0.0.1:8610/v0/see 2>/dev/null | jq > /dev/null
if [ $? -eq 0 ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t02:\tFound blocks inside response..."
curl http://127.0.0.1:8610/v0/see 2>/dev/null | grep block > /dev/null
if [ $? -eq 0 ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

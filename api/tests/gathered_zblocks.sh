#!/bin/bash
#

printf "TEST /see\n"
printf "\t01:\tOutput is JSON"
curl http://127.0.0.1:8610/v0/see 2>/dev/null | jq > /dev/null
if [ "$?" == "0" ]
then
    printf "\n\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t02:\tFound blocks inside response"
curl http://127.0.0.1:8610/v0/see 2>/dev/null | grep block > /dev/null
if [ "$?" == "0" ]
then
    printf "\n\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\n\t\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

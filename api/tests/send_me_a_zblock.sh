#!/bin/bash
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
printf "\t01:\tendpoint with valid data"
curl http://127.0.0.1:8610/v0/sblk --header 'Content-Type: application/json' --data-raw '{"zblock":"'$(ak-get-zlatest)'"}' 2>/dev/null | jq -M -c > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t02:\tendpoint with invalid data"
curl http://127.0.0.1:8610/v0/sblk --header 'Content-Type: application/json' --data-raw '{"zblock":"'$(ak-get-zlatest)'sdfas"}' 2>/dev/null | jq -M -c > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t03:\tendpoint no data"
curl http://127.0.0.1:8610/v0/sblk --header 'Content-Type: application/json' --data-raw '{"zblock":""}' 2>/dev/null | jq -M -c > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

#!/usr/bin/env bash
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
printf "TEST\t/v0/announce/zblock\n"
printf "\t01:\tendpoint with valid data"
curl -s http://127.0.0.1:8610/v0/announce/zblock --header 'Content-Type: application/json' --data-raw '{"zblock":"'$(ak zchain --get-latest)'"}' 2>/dev/null | jq -M -c > /dev/null
if [ $? -eq 0 ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t02:\tendpoint with invalid data"
curl -s http://127.0.0.1:8610/v0/announce/zblock --header 'Content-Type: application/json' --data-raw '{"zblock":"'$(ak zchain --get-latest)'sdfas"}' 2>/dev/null | jq -M -c > /dev/null
if [ $? -eq 0 ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t03:\tendpoint no data"
curl -s http://127.0.0.1:8610/v0/announce/zblock --header 'Content-Type: application/json' --data-raw '{"zblock":""}' 2>/dev/null | jq -M -c > /dev/null
if [ $? -eq 0 ]
then
    printf "\t\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

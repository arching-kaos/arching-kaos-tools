#!/bin/bash
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
printf "TEST\t/announce/zchain\n"
# curl http://127.0.0.1:8610/v0/announce/zchain
printf "\t01:\tendpoint with valid data"
curl -POST http://localhost:8610/v0/announce/zchain --header 'Content-Type: application/json' --data-raw '{"zchain":"k51qzi5uqu5dgapvk7bhxmchuqya9immqdpbz0f1r91ckpdqzub63afn3d5apr"}' 2>/dev/null | jq -M -c > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t02:\tendpoint with invalid data"
curl -POST http://localhost:8610/v0/announce/zchain --header 'Content-Type: application/json' --data-raw '{"zchain":"k51qzi5uqu5dgapvk7bhxmchuqya9immqdpbz0f1r91ckpdqzub63afn3d5aar"}' 2>/dev/null | jq -M -c > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

printf "\t03:\tendpoint no data"
curl -POST http://localhost:8610/v0/announce/zchain --header 'Content-Type: application/json' --data-raw '{"zchain":""}' 2>/dev/null | jq -M -c > /dev/null
if [ "$?" == "0" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

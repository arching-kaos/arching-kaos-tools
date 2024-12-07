#!/bin/bash
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
printf "TEST     /zchain\n"
printf "\t01:\tComparing API with CLI response..."
API_RESPONSE="$(curl -s http://127.0.0.1:8610/v0/zchain 2>/dev/null | jq -c -M | sha512sum - | awk '{print $1 }')"
CMD_RESPONSE="$(ak zchain --crawl | jq -c -M | sha512sum - | awk '{ print $1 }')"
if [ "$API_RESPONSE" == "$CMD_RESPONSE" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

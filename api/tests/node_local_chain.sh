#!/bin/bash
printf "\nTEST /zchain\n"
printf "\t01:\tComparing API with CLI response..."
API_RESPONSE="$(curl http://127.0.0.1:8610/v0/zchain 2>/dev/null | sha512sum - | awk '{print $1 }')"
CMD_RESPONSE="$(get-chain-min | sha512sum - | awk '{ print $1 }')"
printf "api: %s\nenter: %s\n" $API_RESPONSE $CMD_RESPONSE
if [ "$API_RESPONSE" == "$CMD_RESPONSE" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m\n"
else
    printf "\t\t\033[0;31mFAILED\033[0;0m\n"
fi

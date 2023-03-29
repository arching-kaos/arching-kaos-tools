#!/bin/bash
printf "TEST\t/seens\n"
printf "\t01:\tendpoint returns JSON...\n"
curl http://127.0.0.1:8610/v0/seens 2>/dev/null | jq > /dev/null
if [ "$?" == "0" ]
then
    printf '\t\t\033[0;32mPASSED\033[0;0m\n'
else
    printf '\t\t\033[0;31mFAILED\033[0;0m\n'
fi

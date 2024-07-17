#!/bin/bash
#
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
printf "TEST\t/slatest\n"
printf "\t01:\tendpoint"
A="$(curl http://127.0.0.1:8610/v0/slatest 2>/dev/null)"
B="$(ak schain --get-latest)"
if [ "$A" == "$B" ]
then
    printf '\t\t\033[0;32mPASSED\033[0;0m'
else
    printf '\t\t\033[0;31mFAILED\033[0;0m'
fi
printf "\n"

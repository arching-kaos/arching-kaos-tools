#!/bin/bash
#
printf "TEST\t/slatest\n"
printf "\t01:\tendpoint\n"
A="$(curl http://127.0.0.1:8610/v0/slatest 2>/dev/null)"
B="$(ak-find-latest-mined-block)"
if [ "$A" == "$B" ]
then
    printf '\t\t\033[0;32mPASSED\033[0;0m'
else
    printf '\t\t\033[0;31mFAILED\033[0;0m'
fi
printf "\n"

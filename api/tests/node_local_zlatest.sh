#!/bin/bash
PROGRAM="$(basename $0)"
printf '[%s]\n' "$PROGRAM"
API_RES="$(curl http://127.0.0.1:8610/v0/zlatest 2>/dev/null | sha512sum - | awk '{ printf $1 }')"
CMD_RES="$(ak zchain --get-latest | sed -e 's/^/{"zlatest":"/; s/$/"}/' | sha512sum - | awk '{ printf $1 }')"
printf "TEST /zlatest\n"
printf "\t01:\tLatest is the same between API response and CLI..."
if [ "$API_RES" == "$CMD_RES" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

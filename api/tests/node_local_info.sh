#!/usr/bin/env bash
PROGRAM="$(basename $0)"
source $AK_LIBDIR/_ak_ipfs
printf '[%s]\n' "$PROGRAM"
API_RES="$(curl -s http://127.0.0.1:8610/v0/node_info 2>/dev/null | sha512sum - | awk '{ printf $1 }')"
CMD_RES="$(_ak_ipfs_cat $(ak-node-info --ipfs) | sha512sum - | awk '{ printf $1 }')"
printf "TEST /node_info\n"
printf "\t01:\tLatest is the same between API response and CLI..."
if [ "$API_RES" == "$CMD_RES" ]
then
    printf "\t\t\033[0;32mPASSED\033[0;0m"
else
    printf "\t\t\033[0;31mFAILED\033[0;0m"
fi
printf "\n"

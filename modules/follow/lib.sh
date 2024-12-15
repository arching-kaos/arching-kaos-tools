#!/usr/bin/env bash
###
### arching-kaos-tools
### Tools to interact and build an Arching Kaos Infochain
### Copyright (C) 2021 - 2025  kaotisk
###
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation, either version 3 of the License, or
### (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
### GNU General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

source $AK_LIBDIR/_ak_ipfs

FOLLOWING="$AK_WORKDIR/following"

_ak_follow_follow(){
    if [ ! -z $1 ]
    then
        grep $1 $FOLLOWING
        if [ $? == 0 ]
        then
            _ak_log_error "Already exists"
            exit 1
        fi
        echo $1 >> $FOLLOWING
        IPFS=$(_ak_ipfs_add $FOLLOWING)
        if [ $? -ne 0 ]
        then
            _ak_log_error "Addition failed"
            exit 1
        fi
        ak-profile set following $IPFS
        exit 0
    fi
    printf "Usage:\n\t%s <AKID_IPFS_CID_v0>\n" $PROGRAM
    exit 1
}

_ak_follow_list(){
    if [ -f $FOLLOWING ]
    then
        cat $FOLLOWING
    else
        _ak_log_info "No following file, creating"
        touch $FOLLOWING
        echo "None found"
    fi
}

_ak_follow_unfollow(){
    FOLLOWING="$HOME/.arching-kaos/following"
    fentries="$(cat $FOLLOWING)"
    if [ ! -z $1 ]
    then
        search="$1"
        sed -i -e 's,'"$search"',,g' $FOLLOWING
        if [ $? -ne 0 ]
        then
            _ak_log_error "sed didn't found $search"
            exit 1
        fi
        IPFS="$(_ak_ipfs_add $FOLLOWING)"
        if [ $? -ne 0 ]
        then
            _ak_log_error "IPFS problem"
            exit 1
        fi
        ak-profile set repositories "$IPFS"
        exit 0
    else
        echo "Who to unfollow?"
        echo "Type following to see them"
        exit 1
    fi
}

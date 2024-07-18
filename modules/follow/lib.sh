#!/bin/bash

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

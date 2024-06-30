#!/bin/bash

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

_ak_modules_mixtapes_specs(){
    datetime_mask=$(printf '^[0-9]\{8\}_[0-9]\{6\}$' | xxd -p)
    ipfs_mask=$(printf '^Qm[a-zA-Z0-9]\{44\}$' | xxd -p)
    text_dash_underscore_space_mask=$(printf '^[a-zA-Z0-9][a-zA-Z0-9[:space:]\_]\{1,128\}$' | xxd -p -c 64)
    echo '
        {
           "datetime": "'$datetime_mask'",
           "artist":   "'$text_dash_underscore_space_mask'",
           "title":    "'$text_dash_underscore_space_mask'",
           "ipfs":     "'$ipfs_mask'",
           "detach":   "'$ipfs_mask'"
        }' | jq
}

_ak_modules_mixtapes_add(){
    if [ ! -z $3 ];
    then
        echo $1
        PWD="$(pwd)"
        MIXTAPE_ARTIST="$1"
        MIXTAPE_TITLE="$2"
        MIXTAPE_FILE="$PWD/$3"
        _ak_modules_mixtapes_main $1
        cat $PWD/data | jq -M
        _ak_zblock_pack mixtape/add $PWD/data
    fi
}

_ak_modules_mixtapes_main(){
    echo $MIXTAPE_FILE "by" $MIXTAPE_ARTIST "named as" $MIXTAPE_TITLE

    MIXTAPE_IPFS_HASH=$(_ak_ipfs_add $MIXTAPE_FILE)

    MIXTAPE_SIGN_FILE=$MIXTAPE_FILE".asc"
    _ak_gpg_sign_detached $MIXTAPE_SIGN_FILE $MIXTAPE_FILE

    MIXTAPE_SIGNATURE=$(_ak_ipfs_add $MIXTAPE_SIGN_FILE)

    cat > data <<EOF
{
    "timestamp":"$(date -u +%s)",
    "artist":"$MIXTAPE_ARTIST",
    "title":"$MIXTAPE_TITLE",
    "ipfs":"$MIXTAPE_IPFS_HASH",
    "detach":"$MIXTAPE_SIGNATURE"
}
EOF

}

_ak_modules_mixtapes_get_local_latest(){
    tempdir=$(_ak_make_temp_directory)
    cd $tempdir
    if [ -z "$1" ]
    then
        ak zchain --crawl -l 1 | jq > aktempzblock
    else
        ak zchain --crawl -l 1 $1 | jq > aktempzblock
    fi
    curzblock="`cat aktempzblock | jq -r '.[].zblock'`"
    curaction="`cat aktempzblock | jq -r '.[].action'`"
    curmodule="`cat aktempzblock | jq -r '.[].module'`"
    curdata="`cat aktempzblock | jq -r '.[].data'`"
    curipfs="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".ipfs")"
    curprevious="`cat aktempzblock | jq -r '.[].previous'`"

    if [ "$curmodule" == "mixtape" ] && [ "$curaction" == "add" ]
    then
        artist="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".artist")"
        title="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".title")"
        echo "Found zblock: $curzblock"
        echo "$title by $artist"
        _ak_ipfs_get $curipfs
        mpv $curipfs
    else
        seek $curprevious
    fi
    rm -rf $tempdir
    exit 0
}

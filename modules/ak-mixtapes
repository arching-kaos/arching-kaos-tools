#!/bin/bash
##
## The following creates a mixtape data message
##
## Usage:
##
##  -a <artist> <title> <file>            Adds a file with tags artist and title
##
##  -h , --help
##
##  -s , --specs
##
# We can extend it by calling the _ak_zblock_pack.sh mixtape/add data ## ORIGINAL LINE
fullprogrampath="$(realpath $0)"
PROGRAM="$(basename $0)"
descriptionString="AK mixtape block creator"
source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
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

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        -l | --local-index) _ak_modules_mixtapes_index; exit;;
        -i | --import) _ak_modules_mixtapes_import $2; exit;;
        -a | --add) _ak_modules_mixtapes_add_from_file $2 $3 $4; exit;;
        -c | --create) _ak_modules_mixtapes_create; exit;;
        -r | --read) _ak_modules_mixtapes_read $2; exit;;
        -s | --specs) _ak_modules_mixtapes_specs $2; exit;;
        -x | --html) _ak_modules_mixtapes_html $2; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

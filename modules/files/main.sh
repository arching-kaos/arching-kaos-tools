#!/bin/bash
##
## The following creates a files data message
##
##    -h, --help                  Prints this help message
##
fullprogrampath="$(realpath $0)"
PROGRAM=$(basename $0)
descriptionString="Module for adding files"
ZFILESDIR="$AK_WORKDIR/files"
TEMP="/tmp/aktmp"
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

if [ ! -d $ZFILESDIR ]; then
    mkdir $ZFILESDIR
    if [ $? == 0 ]
    then
        _ak_log_info "Folder $ZFILESDIR created!"
    else
        _ak_log_error "Failed to create $ZFILESDIR folder"
        exit 1
    fi
    cd $ZFILESDIR
    git init
else
    _ak_log_info "$ZFILESDIR found!"
fi

_ak_modules_files_add(){
    CRP="$(pwd)"
    FILENAME="$1"
    main $FILENAME $CRP
    cat $TEMPASSIN/data | jq -M
}
main(){
    FILENAME="$1"
    CRP="$2"
    echo "Adding $FILENAME"
    _ak_log_info "Switching to tmp folder..."
    TEMPASSIN="$(ak-tempassin)"
    cd $TEMPASSIN
    if [ $? == 0 ]; then
        _ak_log_info "Success"
    else
        _ak_log_error "Error with tmp folder"
        exit 5
    fi
    _ak_log_info "Copying $1 to $TEMPASSIN"
    cp $2/$1 $TEMPASSIN/$1
    if [ $? == 0 ]; then
        _ak_log_info "Copied successfully"
    else
        _ak_log_error "Error copying..."
    fi

    FILE="$TEMPASSIN/$1"

    _ak_log_info "Adding $FILE to IPFS..."
    FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
    if [ $? == 0 ]; then
        _ak_log_info "Added $FILE to IPFS"
    else
        _ak_log_error "Error in adding the $FILE to IPFS"
    fi
    _ak_log_info "Signing..."
    SIGN_FILE=$FILENAME".asc"
    _ak_gpg_sign_detached $SIGN_FILE $FILE
    if [ $? == 0 ]; then
        _ak_log_info "Signed"
    else
        _ak_log_error "Error while signing"
    fi

    _ak_log_info "Adding signature to IPFS"
    SIGNATURE=$(_ak_ipfs_add $TEMPASSIN/$SIGN_FILE)
    if [ $? == 0 ]; then
        _ak_log_info "Added"
    else
        _ak_log_error "Error while adding"
    fi

    cat > $TEMPASSIN/data <<EOF
{
    "timestamp":"$(date -u +%s)",
    "filename":"$FILENAME",
    "ipfs":"$FILE_IPFS_HASH",
    "detach":"$SIGNATURE"
}
EOF

echo "Printing data..."
cat $TEMPASSIN/data
echo "Publishing..."

    _ak_zblock_pack files/add $PWD/data
    if [ $? == 0 ]
    then
        echo "cool"
    else
        echo "not?"
        exit 2
    fi
}

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        add) _ak_modules_files_add $2; exit;;
        *) _ak_usage; exit;;
    esac
else _ak_usage
fi

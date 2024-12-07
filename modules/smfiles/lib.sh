#!/usr/bin/env bash

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock
source $AK_LIBDIR/_ak_smfiles

_ak_sm_files_add(){
    FILENAME="$1"
    _ak_sm_files_main $FILENAME $CRD
    cat data | jq -M
}
_ak_sm_files_main(){
    FILENAME="$1"
    CRP="$2"

    TEMPASSIN="$(_ak_make_temp_directory)"
    cd $TEMPASSIN

    echo "Adding $FILENAME"
    _ak_log_info "Switching to tmp folder..."
    if [ $? -eq 0 ]
    then
        _ak_log_info "Success"
    else
        _ak_log_error "Error with tmp folder"
        exit 5
    fi
    _ak_log_info "Copying $1 to $TEMPASSIN"

    cp $CRP/$FILENAME $FILENAME
    if [ $? -eq 0 ]
    then
        _ak_log_info "Copied successfully"
    else
        _ak_log_error "Error copying..."
    fi

    _ak_log_info "Adding $FILENAME to IPFS..."
    FILE_IPFS_HASH=$(_ak_ipfs_add $FILENAME)
    if [ $? -eq 0 ]
    then
        _ak_log_info "Added $FILENAME to IPFS"
    else
        _ak_log_error "Error in adding the $FILENAME to IPFS"
    fi

    _ak_log_info "Adding $FILE to SHAMAPSYS..."
    FILEMAP_SHA512_HASH=$(_ak_sm_file_splitter $FILENAME)
    if [ $? -eq 0 ]
    then
        _ak_log_info "Added $FILENAME to SHAMAPSYS"
    else
        _ak_log_error "Error in adding the $FILENAME to SHAMAPSYS"
    fi

    _ak_log_info "Signing..."
    SIGN_FILE=$FILENAME".asc"
    _ak_gpg_sign_detached $SIGN_FILE $FILENAME
    if [ $? -eq 0 ]
    then
        _ak_log_info "Signed"
    else
        _ak_log_error "Error while signing"
    fi

    _ak_log_info "Adding signature to IPFS"
    SIGNATURE=$(_ak_ipfs_add $SIGN_FILE)
    if [ $? -eq 0 ]
    then
        _ak_log_info "Added"
    else
        _ak_log_error "Error while adding"
    fi

    _ak_log_info "Adding signature to SHAMAPSYS"
    SHAMAPSIGMAP=$(_ak_sm_file_splitter $SIGN_FILE)
    if [ $? -eq 0 ]
    then
        _ak_log_info "Added"
    else
        _ak_log_error "Error while adding"
    fi

    cat > data <<EOF
{
    "timestamp":"$(date -u +%s)",
    "filename":"$FILENAME",
    "shamap":"$FILEMAP_SHA512_HASH",
    "shamapsig":"$SHAMAPSIGMAP",
    "ipfs":"$FILE_IPFS_HASH",
    "detach":"$SIGNATURE"
}
EOF

    echo "Printing data..."
    cat data
    echo "Publishing..."

    _ak_zblock_pack sha-files/announce $(pwd)/data
    if [ $? -eq 0 ]
    then
        echo "cool"
    else
        echo "not?"
        exit 2
    fi
}

_ak_sm_files_index(){
    tail -n1 $AK_WORKDIR/fmp/* | grep '^[abcdef1234567890]' | awk '{ print $2 }'
}

_ak_sm_files_ls_mapfiles(){
    cd $AK_WORKDIR/fmp
    for f in `find . -type f | sed -e 's/\.\///g'`
    do
        FILENAME="$(tail -n 1 $f | grep '^[abcdef1234567890]' | awk '{ print $2 }')"
        FILEHASH="$(tail -n 1 $f | grep '^[abcdef1234567890]' | awk '{ print $1 }')"
        MAPFILE="$f"
        printf "\nMap: %s\nFilename: %s\nSum: %s\n\n" $MAPFILE $FILENAME $FILEHASH
    done
}

_ak_sm_files_full_index(){
    tail -n 1 $AK_WORKDIR/fmp/* | grep '^[abcdef1234567890]'
}


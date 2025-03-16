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
source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock
source $AK_LIBDIR/_ak_zchain
source $AK_LIBDIR/_ak_utils

ZENCRYPTEDDIR="$AK_WORKDIR/encrypted"

if [ ! -d $ZENCRYPTEDDIR ]
then
    mkdir $ZENCRYPTEDDIR
    if [ $? -ne 0 ]
    then
        _ak_log_error "$ZENCRYPTEDDIR couldn't be created"
        exit 1
    fi
    _ak_log_info "$ZENCRYPTEDDIR created"
else
    _ak_log_info "$ZENCRYPTEDDIR found"
fi

cd $ZENCRYPTEDDIR

function _ak_modules_encrypted_create(){
    TEMP="$(_ak_make_temp_directory)"
    curpath="$(pwd)"
    cd $TEMP
    export ENCRYPTED_FILE="$(_ak_datetime_human)"
    vi $ENCRYPTED_FILE
    echo "Renaming..."
    TITLE="$(head -n 1 $ENCRYPTED_FILE)"
    TO_FILE=$ENCRYPTED_FILE-$(echo $TITLE | tr '[:upper:]' '[:lower:]' | sed -e 's/ /\_/g' )
    # Encrypt!!!
    #
    select x in $(_ak_gpg_list_keys_long|tr ' ' ':'| sed -e '/^:$/d')
    do
        if [ -n "$x" ]
        then
            _ak_log_info "Going to encrypt for $x"
            recipient="$(echo $x | cut -d ':' -f 1)"
            _ak_gpg_encrypt_sign $TO_FILE $ENCRYPTED_FILE $recipient
            break
        else
            _ak_log_error "You didn't choose recipient"
        fi
    done
    IPFS_FILE=$(_ak_ipfs_add $TO_FILE)
    mv $TO_FILE $ZENCRYPTEDDIR/$TO_FILE
    _ak_modules_encrypted_add $TO_FILE
    cd $ZENCRYPTEDDIR
    rm -rf $TEMP
}

function _ak_modules_encrypted_index(){
    FILES="$(ls -1 $ZENCRYPTEDDIR)"
    i=0
    ak-zchain-extract-cids | sort | uniq > temp
    for FILE in $FILES
    do
        DATE="$(echo $FILE | cut -d - -f 1 | awk '{print $1}')"
        TITLE="$(head -n 1 $ZENCRYPTEDDIR/$FILE)"
        IPFS_HASH="$(ipfs add -nQ $ZENCRYPTEDDIR/$FILE)"
        ONLINE="Not in zchain"
        grep "$IPFS_HASH" temp > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
            ONLINE="On zchain"
        fi
        printf "%3d | %5s | %52s | %10s | %56s \n"\
            "$i" "$ONLINE" "$IPFS_HASH" "$DATE" "$TITLE"
        let i+=1
    done
    rm temp
}

function _ak_modules_encrypted_import(){
    echo "#TODO"
    if [ ! -z $1 ]
    then
        if [ ! -d "$1" ]
        then
            echo $1
            echo "Folder does not exist"
            exit 4
        else
            echo "Folder $1 exists"
            fl="$(ls -1 $1)"
            for f in $fl
            do
                echo $1 $f
                _ak_modules_encrypted_add_from_file "$1/$f"
            done
        fi
    else
        echo "No value"
        exit 6
    fi
    exit 224
}

function _ak_modules_encrypted_add_from_file(){
    TEMP="$(_ak_make_temp_directory)"
    if [ -f "$1" ]
    then
        FILE="$(realpath $1)"
        cp $FILE $ZENCRYPTEDDIR
        cp $FILE $TEMP
        FILE="$(basename $1)"
        cd $TEMP
        echo "Adding encrypted from " $FILE
        DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        cat > data <<EOF
{
   "datetime":"$DATETIME",
   "filename":"$(basename $FILE)",
   "ipfs":"$FILE_IPFS_HASH",
   "detach":"$FILE_SIGNATURE"
}
EOF
    else
        _ak_log_error "File $FILE doesn't exist";
        exit 2
    fi
    _ak_zblock_pack "encrypted/add" $(pwd)/data
    if [ $? -ne 0 ]
    then
        _ak_log_error "Some error occured while packing"
        exit 1
    fi
    _ak_log_info "Encrypted added successfully"
    rm -rf $TEMP
}

function _ak_modules_encrypted_add(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ -f $ZENCRYPTEDDIR/$1 ]; then
        FILE="$1"
        echo "Adding encrypted from " $FILE
        DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        FILE_IPFS_HASH=$(_ak_ipfs_add $ZENCRYPTEDDIR/$FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $ZENCRYPTEDDIR/$FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        cat > data <<EOF
{
   "datetime":"$DATETIME",
   "filename":"$FILE",
   "ipfs":"$FILE_IPFS_HASH",
   "detach":"$FILE_SIGNATURE"
}
EOF
    else
        echo "File $FILE doesn't exist";
        exit 2
    fi
    _ak_zblock_pack "encrypted/add" $(pwd)/data
    if [ $? -ne 0 ]
    then
        _ak_log_error "Some error occured while packing"
        exit 1
    fi
    _ak_log_info "Encrypted added successfully"
    rm -rf $TEMP
}

function _ak_modules_encrypted_read(){
    ak zchain --crawl -l 1 $1 > temp
    if [ $? -ne 0 ]
    then
        echo error
        exit 22
    fi
    module="`cat temp | jq -r '.[].module'`"
    action="`cat temp | jq -r '.[].action'`"
    data="`cat temp | jq -r '.[].data'`"
    linkToText="`cat temp | jq -r ".[].$data.ipfs"`"

    if [ "$module" == "encrypted" ] && [ "$action" == "add" ]
    then

        _ak_ipfs_cat $linkToText
    else
        _ak_log_error "Not a encrypted block."
        echo "ERROR Not a encrypted block."
        exit 1
    fi
    rm temp
}

function _ak_modules_encrypted_specs(){
    datetime_mask=$(printf '^[0-9]\{8\}_[0-9]\{6\}$' | xxd -p)
    ipfs_mask=$(printf '^Qm[a-zA-Z0-9]\{44\}$' | xxd -p)
    text_mask=$(printf '^[a-zA-Z0-9_\-]\{1,128\}$' | xxd -p)
    echo '
        {
           "datetime":"'$datetime_mask'",
           "title":    "'$text_mask'",
           "filename": "'$text_mask'",
           "ipfs":     "'$ipfs_mask'",
           "detach":   "'$ipfs_mask'"
        }' | jq
}

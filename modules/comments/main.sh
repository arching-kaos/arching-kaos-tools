#!/bin/bash
##
## -h, --help                Prints this help message"
##
## index                     Prints an indexed table of your comments files"
##
## add <file> <refer_to>     Creates a data file from the comments file you point to"
##
## create <refer_to>         Vim is going to pop up, you will write and save your"
##                           commentsletter and it's going to be saved"
##
fullprogrampath="$(realpath $0)"
PROGRAM="$(basename $0)"
descriptionString="Comments module for Arching Kaos"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

ZCOMMENTSDIR="$AK_WORKDIR/comments"
TEMP="/tmp/aktmp"
if [ ! -d $ZCOMMENTSDIR ]; then
    mkdir $ZCOMMENTSDIR
    cd $ZCOMMENTSDIR
    _ak_log_info "zcommentsdir created"
else
    _ak_log_info "zcommentsdir found"
fi

_ak_modules_comments_create(){
    if [ ! -z $1 ]
    then
        REFER_TO="$1"
    else
        _ak_log_error "No reference given"
        echo "ERROR" "No reference given"
        exit 1
    fi
    TEMP="$(ak-tempassin)"
    cd $TEMP
    export COMMENTS_FILE="$(date -u +%s)"
    vi $COMMENTS_FILE
    echo "Renaming..."
    TO_FILE=$COMMENTS_FILE
    IPFS_FILE=$(_ak_ipfs_add $COMMENTS_FILE)
    mv $COMMENTS_FILE $ZCOMMENTSDIR/$TO_FILE
    _ak_modules_comments_add $TO_FILE
    _ak_log_info "Adding to git repo..."
    cd $ZCOMMENTSDIR
    if [ ! -z $REFER_TO ]
    then
        ak-reference create $REFERENCE $REFER_TO
    fi
}

_ak_modules_comments_index(){
    FILES="$(ls -1 $ZCOMMENTSDIR)"
    i=0
    for FILE in $FILES
    do
        DATE=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $ZCOMMENTSDIR/$FILE)
        echo $i \| $DATE \| $TITLE
        let i+=1
    done
}

_ak_modules_comments_add(){
    TEMP="$(ak-tempassin)"
    cd $TEMP
    if [ -f "$ZCOMMENTSDIR/$1" ]; then
        FILE=$ZCOMMENTSDIR/$1
        echo "Adding comments from " $FILE
        DATETIME="$1"
        FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        printf '{"datetime":"%s","ipfs":"%s","detach":"%s"}' $DATETIME $FILE_IPFS_HASH $FILE_SIGNATURE > data
    else
        echo "File $FILE doesn't exist";
        exit 2
    fi
    REFERENCE="$(_ak_zblock_pack "comments/add" $(pwd)/data)"
    if [ $? == 0 ]
    then
        echo "Comment added successfully"
    else
        echo "error??"
        exit 1
    fi
}

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        index) _ak_modules_comments_index; exit;;
        add) _ak_modules_comments_add $2 $3; exit;;
        create) _ak_modules_comments_create $2; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

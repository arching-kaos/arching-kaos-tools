#!/bin/bash
## #TODO
## All you need to know is that there are two options available:
## -h, --help               Prints this help message
## index                    Prints an indexed table of your references files
## import <file>            #TODO
## add <file>               Creates a data file from the references file you point to
## create [ref] [to]        Vim is going to pop up, you will write and save your
##                          referencesletter and it's going to be saved
fullprogrampath="$(realpath $0)"
PROGRAM=$(basename $0)
descriptionString="Quick description"


ZREFERENCESDIR="$AK_WORKDIR/references"
TEMP="/tmp/aktmp"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

if [ ! -d $ZREFERENCESDIR ]; then
    mkdir $ZREFERENCESDIR
    cd $ZREFERENCESDIR
    _ak_log_info "zreferencesdir created"
else
    _ak_log_info "zreferencesdir found"
fi

_ak_modules_reference_create(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    export REFERENCEFILE="$(date -u +%s)"
    if [ ! -z $1 ] && [ ! -z $2 ]
    then
        TO_FILE="$(date -u +%s)-$1-$2"
        cat > $REFERENCEFILE << EOF
$1
$2
EOF

    else
        vi $REFERENCEFILE
    fi
    REFERENCE="$(head -n 1 $REFERENCEFILE)"
    REFER_TO="$(tail -n 1 $REFERENCEFILE)"
    TO_FILE="$REFERENCEFILE-$REFERENCE-$REFER_TO"
    mv $REFERENCEFILE $ZREFERENCESDIR/$TO_FILE
    echo $TO_FILE
    IPFS_FILE=$(_ak_ipfs_add $ZREFERENCESDIR/$TO_FILE)
    sed -e 's,Qm.*,'"$IPFS_FILE"',g' $ZREFERENCESDIR/README
    _ak_modules_reference_add $ZREFERENCESDIR/$TO_FILE
    cd $ZREFERENCESDIR
}

_ak_modules_reference_index(){
    FILES="$(ls -1 $ZREFERENCESDIR)"
    i=0
    for FILE in $FILES
    do
        DATE=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $ZREFERENCESDIR/$FILE)
        REFE=$(tail -n 1 $ZREFERENCESDIR/$FILE)
        echo $i \| $DATE \| $TITLE \| $REFE
        let i+=1
    done
}

_ak_modules_reference_import(){
    echo "#TODO"
    if [ ! -z $1 ]
    then
        if [ ! -d $1 ]
        then
            echo "Folder does not exists"
            exit 4
        else
            echo "Folder $1 exists"
            fl="$(ls -1 $1)"
            for f in $fl
            do
                _ak_modules_reference_add $1/$f
            done
        fi
    else
        echo "No value"
        exit 6
    fi
    exit 224
}

_ak_modules_reference_add(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ ! -f $1 ]; then
        echo "File $FILE doesn't exist";
        exit 2
    fi
    FILE="$1"
    echo "Adding references from " $FILE
    DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
    FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
    FILE_SIGN_FILE=$FILE".asc"
    _ak_gpg_sign_detached $FILE_SIGN_FILE $FILE
    FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
    cat > data <<EOF
{
   "datetime":"$(date -u +%s)",
   "reference":"$REFERENCE",
   "refer_to":"$REFER_TO",
   "ipfs":"$FILE_IPFS_HASH",
   "detach":"$FILE_SIGNATURE"
}
EOF
    cat data | jq -M -c > tmp
    cat tmp > data
    rm tmp
    _ak_zblock_pack "references/add" $(pwd)/data
    if [ $? != 0 ]
    then
        echo "error??"
        exit 1
    fi
    echo "References added successfully"
}

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        index) _ak_modules_reference_index; exit;;
        import) _ak_modules_reference_import $2; exit;;
        add) _ak_modules_reference_add $2; exit;;
        create) _ak_modules_reference_create $2 $3; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

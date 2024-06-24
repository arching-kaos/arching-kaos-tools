#!/bin/bash
##
##     -h, --help       Prints this help message"
##
##     index            Prints an indexed table of your news files"
##
##     import <file>    #TODO"
##
##     add <file>       Creates a data file from the news file you point to"
##
##     create           Vim is going to pop up, you will write and save your"
##                      newsletter and it's going to be saved"
##
AK_CATEGORIES="$AK_WORKDIR/categories"
PROGRAM="$(basename $0)"
descriptionString="A module for adding and refering zblocks to categories"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

if [ ! -d $AK_CATEGORIES ]; then
    mkdir $AK_CATEGORIES
    cd $AK_CATEGORIES
    _ak_log_info "AK_CATEGORIES created"
else
    _ak_log_info "AK_CATEGORIES found"
fi

_ak_modules_categories_create(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    export NEWS_FILE="$(date +%Y%m%d_%H%M%S)"
    vi $NEWS_FILE
    _ak_log_info "Renaming..."
    TITLE="$(head -n 1 $NEWS_FILE)"
    TO_FILE=$NEWS_FILE-$(echo $TITLE | tr '[:upper:]' '[:lower:]' | sed -e 's/ /\_/g' )
    IPFS_FILE=$(_ak_ipfs_add $NEWS_FILE)
    mv $NEWS_FILE $AK_CATEGORIES/$TO_FILE
    sed -e 's,Qm.*,'"$IPFS_FILE"',g' $AK_CATEGORIES/README
    _ak_modules_categories_add $AK_CATEGORIES/$TO_FILE
    cd $AK_CATEGORIES
}
_ak_modules_categories_index(){
    FILES="$(ls -1 $AK_CATEGORIES)"
    i=0
    for FILE in $FILES
    do
        DATE=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $AK_CATEGORIES/$FILE)
        echo $i \| $DATE \| $TITLE
        let i+=1
    done
}

_ak_modules_categories_import(){
    echo "#TODO"
    if [ ! -z $1 ]
    then
        if [ ! -d $1 ]
        then
            _ak_log_error "Folder does not exists"
            exit 4
        else
            _ak_log_info "Folder $1 exists"
            fl="$(ls -1 $1)"
            for f in $fl
            do
                _ak_modules_categories_add $1/$f
            done
        fi
    else
        _ak_log_error "No value"
        exit 6
    fi
    exit 224
}
_ak_modules_categories_add(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ -f $1 ]; then
        FILE="$1"
        _ak_log_info "Adding news from " $FILE
        DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $FILE)
        FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        cat > data <<EOF
{
   "datetime":"$DATETIME",
   "title":"$TITLE",
   "filename":"$FILE",
   "ipfs":"$FILE_IPFS_HASH",
   "detach":"$FILE_SIGNATURE"
}
EOF
    else
        _ak_log_error "File $FILE doesn't exist";
        exit 2
    fi
    _ak_zblock_pack "news/add" $(pwd)/data
    if [ $? == 0 ]
    then
        _ak_log_info "News added successfully"
    else
        _ak_log_error "error??"
        exit 1
    fi
}


if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        index) _ak_modules_categories_index; exit;;
        import) _ak_modules_categories_import $2; exit;;
        add) _ak_modules_categories_add $2; exit;;
        create) _ak_modules_categories_create; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

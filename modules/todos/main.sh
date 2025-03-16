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
##
## Brief description
##
## Usage:
##
##    -h, --help        Prints this help message
##    index             Prints an indexed table of your todos files
##    import <file>     #TODO
##    add <file>        Creates a data file from the todos file you point to
##    create            Vim is going to pop up, you will write and save your
##                      todosletter and it's going to be saved
##
fullprogrampath="$(realpath $0)"
PROGRAM="ak-module-$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
descriptionString="Quick description"
source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock
source $AK_LIBDIR/_ak_utils

ZTODOSDIR="$AK_WORKDIR/todos"
TEMP="/tmp/aktmp"
if [ ! -d $ZTODOSDIR ]; then
    mkdir $ZTODOSDIR
    cd $ZTODOSDIR
    _ak_log_info "ztodosdir created along with git repo"
else
    _ak_log_info "ztodosdir found"
fi

function _ak_modules_todos_create(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    export TODOS_FILE="$(_ak_datetime_unix)"
    vi $TODOS_FILE
    _ak_log_info "Renaming..."
    TITLE="$(head -n 1 $TODOS_FILE)"
    TO_FILE=$TODOS_FILE-$(echo $TITLE | tr '[:upper:]' '[:lower:]' | sed -e 's/ /\_/g' )
    IPFS_FILE=$(_ak_ipfs_add $TODOS_FILE)
    mv $TODOS_FILE $ZTODOSDIR/$TO_FILE
    _ak_modules_todos_add $ZTODOSDIR/$TO_FILE
    _ak_log_info "Adding to git repo..."
    cd $ZTODOSDIR
    # rm -rf $TEMP
}

function _ak_modules_todos_index(){
    FILES="$(ls -1 $ZTODOSDIR)"
    i=0
    for FILE in $FILES
    do
        DATE=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $ZTODOSDIR/$FILE)
        echo $i \| $DATE \| $TITLE
        let i+=1
    done
}

function _ak_modules_todos_import(){
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
                _ak_modules_todos_add $1/$f
            done
        fi
    else
        echo "No value"
        exit 6
    fi
    exit 224
}

function _ak_modules_todos_add(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ -f $1 ]; then
        FILE="$1"
        _ak_log_info "Adding todos from $FILE"
        DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $FILE)
        FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        cat > data <<EOF
{
   "datetime":"$TODOS_FILE",
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
    _ak_zblock_pack "todos/add" $(pwd)/data
    if [ $? == 0 ]
    then
        _ak_log_info "Todos added successfully"
    else
        _ak_log_error "error?? _ak_zblock_pack failed"
        exit 1
    fi
}

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        index) _ak_modules_todos_index; exit;;
        import) _ak_modules_todos_import $2; exit;;
        add) _ak_modules_todos_add $2; exit;;
        create) _ak_modules_todos_create; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

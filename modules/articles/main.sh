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
##     -h, --help        Prints this help message
##     index             Prints an indexed table of your articles files
##     import <file>     TODO
##     add <file>        Creates a data file from the articles file you point to
##     create            Vim is going to pop up, you will write and save your
##                       articlesletter and it's going to be saved
##
fullprogrampath="$(realpath $0)"
PROGRAM="ak-module-$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
descriptionString="Articles module for Arching Kaos"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_utils
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

ZARTICLESDIR="$AK_WORKDIR/articles"
TEMP="/tmp/aktmp"
if [ ! -d $ZARTICLESDIR ]; then
    mkdir $ZARTICLESDIR
    cd $ZARTICLESDIR
    _ak_log_info "zarticlesdir created"
else
    _ak_log_info "zarticlesdir found"
fi

function _ak_modules_articles_create(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    export ARTICLES_FILE="$(_ak_datetime_human)"
    if [ -z $EDITOR ]
    then
        _ak_log_error "No $EDITOR found. Exiting..."
        exit 1
    fi
    $EDITOR $ARTICLES_FILE
    _ak_log_info "Renaming..."
    TITLE="$(head -n 1 $ARTICLES_FILE)"
    TO_FILE=$ARTICLES_FILE-$(echo $TITLE | tr '[:upper:]' '[:lower:]' | sed -e 's/ /\_/g' )
    IPFS_FILE=$(_ak_ipfs_add $ARTICLES_FILE)
    mv $ARTICLES_FILE $ZARTICLESDIR/$TO_FILE
    sed -e 's,Qm.*,'"$IPFS_FILE"',g' $ZARTICLESDIR/README
    _ak_modules_articles_add $ZARTICLESDIR/$TO_FILE
    _ak_log_info "Adding to git repo..."
    cd $ZARTICLESDIR
    rm -rf $TEMP
}

function _ak_modules_articles_index(){
    FILES="$(ls -1 $ZARTICLESDIR)"
    i=0
    for FILE in $FILES
    do
        DATE=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $ZARTICLESDIR/$FILE)
        echo $i \| $DATE \| $TITLE
        let i+=1
    done
}

function _ak_modules_articles_import(){
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
                _ak_modules_articles_add $1/$f
            done
        fi
    else
        echo "No value"
        exit 6
    fi
    exit 224
}

function _ak_modules_articles_add(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ -f $1 ]; then
        FILE="$1"
        echo "Adding articles from " $FILE
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
        echo "File $FILE doesn't exist";
        exit 2
    fi
    _ak_zblock_pack "articles/add" $(pwd)/data
    if [ $? == 0 ]
    then
        echo "Articles added successfully"
    else
        echo "error??"
        exit 1
    fi
}

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        index) _ak_modules_articles_index; exit;;
        import) _ak_modules_articles_import $2; exit;;
        add) _ak_modules_articles_add $2; exit;;
        create) _ak_modules_articles_create; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

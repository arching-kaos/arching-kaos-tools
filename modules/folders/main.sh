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
## The following creates a folder data message
##
##
##    -h, --help                  Prints this help message
##     add <folder>               Try ak-folders add <folder>
##
fullprogrampath="$(realpath $0)"
PROGRAM="ak-module-$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
descriptionString="Module for adding folders"
ZFOLDERSDIR="$AK_WORKDIR/folders"
TEMP="/tmp/aktmp"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_zblock

if [ ! -d $ZFOLDERSDIR ]; then
    mkdir $ZFOLDERSDIR
    _ak_log_error "error $ZFOLDERSDIR not found or/and could not be created"
else
    _ak_log_info "Found $ZFOLDERSDIR"
    exit 1
fi
TEMPASSIN="$(_ak_make_temp_directory)"
cd $TEMPASSIN


_ak_modules_folders_add(){
    CRP="$(pwd)"
    FOLDERNAME="$1"
    _ak_modules_folders_main $FOLDERNAME $CRP
    cat data | jq -M
}

_ak_modules_folders_main(){
    FOLDERNAME="$1"
    CRP="$2"
    echo "Adding $FOLDERNAME"
    _ak_log_info "Copying $1 to temporary folder"
    cp -r $2/$1 $1
    if [ $? == 0 ]; then
        _ak_log_info "Copied successfully"
    else
        _ak_log_error "Error copying..."
    fi

    FOLDER="$1"

    _ak_log_info "Adding $FOLDER to IPFS..."
    FOLDER_IPFS_HASH=$(_ak_ipfs_add $FOLDER)
    if [ $? == 0 ]; then
        _ak_log_info "done"
    else
        _ak_log_error "error"
    fi
    _ak_log_warning "Folders are not signing..."

    printf '{"timestamp":"%s","foldername":"%s","ipfs":"%s"}' $(date -u +%s) $FOLDERNAME $FOLDER_IPFS_HASH

    echo "Printing data..."
    cat data
    echo "Publishing..."

    _ak_zblock_pack folders/add $(pwd)/data
    if [ $? == 0 ]
    then
        echo "cool"
    else
        echo "not?"
        exit 2
    fi
}

_ak_modules_folders_title(){
    echo "$PROGRAM - Folder block creator"
}

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        add) _ak_modules_folders_add $2; exit;;
        *) _ak_usage; exit;;
    esac
else _ak_usage
fi

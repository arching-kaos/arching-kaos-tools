#!/usr/bin/env bash
## sm files
##
##  -h, --help              Prints this help message
##  --add <file>            Adds file to zchain as a zblock
##  --index                 List files
##  --full-index            List all files
##  --ls-map-files          List map files
##
ZFILESDIR="$AK_WORKDIR/files"
pwd > .pwd
CRD=$(cat .pwd)

fullprogrampath="$(realpath $0)"
PROGRAM="$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
descriptionString="Module to files in zchain"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$PROGRAM/lib.sh

if [ ! -d $ZFILESDIR ]
then
    mkdir $ZFILESDIR
    if [ $? -eq 0 ]
    then
        _ak_log_info "Folder $ZFILESDIR created!"
    else
        _ak_log_error "Failed to create $ZFILESDIR folder"
        exit 1
    fi
    cd $ZFILESDIR
else
    _ak_log_info "$ZFILESDIR found!"
fi



if [ ! -z $1 ]
then
    case $1 in
        -h | --help) _ak_usage; exit;;
        --add) _ak_sm_files_add $2; exit;;
        --index) _ak_sm_files_index; exit;;
        --full-index) _ak_sm_files_full_index; exit;;
        --ls-map-files) _ak_sm_files_ls_mapfiles; exit;;
        *) _ak_usage; exit;;
    esac
else
    _ak_usage
fi


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
PROGRAM="ak-module-$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
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


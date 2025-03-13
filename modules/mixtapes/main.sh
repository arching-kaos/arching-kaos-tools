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
## The following creates a mixtape data message
##
## Usage:
##
##  -a <artist> <title> <file>            Adds a file with tags artist and title
##  -h, --help                            Prints this help message
##  -s, --specs
##
# We can extend it by calling the _ak_zblock_pack.sh mixtape/add data ## ORIGINAL LINE
fullprogrampath="$(realpath $0)"
MODULE="$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
PROGRAM="ak-module-$MODULE"
descriptionString="AK mixtape block creator"
source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$MODULE/lib.sh

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
        -l | --local-index) _ak_modules_mixtapes_index; exit;;
        -i | --import) _ak_modules_mixtapes_import $2; exit;;
        -a | --add) _ak_modules_mixtapes_add_from_file $2 $3 $4; exit;;
        -c | --create) _ak_modules_mixtapes_create; exit;;
        -r | --read) _ak_modules_mixtapes_read $2; exit;;
        -s | --specs) _ak_modules_mixtapes_specs $2; exit;;
        -x | --html) _ak_modules_mixtapes_html $2; exit;;
        -f | --find-now) _ak_modules_mixtapes_find_now; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

#!/usr/bin/env bash
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
PROGRAM="$(realpath $0 | rev | cut -d '/' -f 2 | rev)"
descriptionString="AK mixtape block creator"
source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$PROGRAM/lib.sh

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
        * ) _ak_usage;;
    esac
else _ak_usage
fi

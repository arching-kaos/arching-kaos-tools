#!/usr/bin/env bash
##
##    -h, --help                  Prints this help message
##    -l, --local-index           Prints an indexed table of your news files
##    -i, --import <file>         TODO
##    -a, --add <file>            Creates a data file from the news file you
##                                point to
##    -r, --read <zblock>         Reads a zblock as a news data
##    -r, --read local_latest     Reads the latest zblock found on your local
##                                zchain
##    -c, --create                Vim is going to pop up, you will write and
##                                save your newsletter and it's going to bei
##                                saved
##    -s, --specs                 Print specs of data block
##    -x, --html <zblock>         Returns an appropriate html element from a
##                                NEWS zblock
##
fullprogrampath="$(realpath $0)"
PROGRAM="$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
descriptionString="Module to read, create and add zblocks"

source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$PROGRAM/lib.sh

if [ ! -z $1 ]
then
    case $1 in
        -h | --help) _ak_usage; exit;;
        -l | --local-index) _ak_modules_news_index; exit;;
        -i | --import) _ak_modules_news_import $2; exit;;
        -a | --add) _ak_modules_news_add_from_file $2; exit;;
        -c | --create) _ak_modules_news_create; exit;;
        -r | --read) _ak_modules_news_read $2; exit;;
        -s | --specs) _ak_modules_news_specs $2; exit;;
        -x | --html) _ak_modules_news_html $2; exit;;
        * ) _ak_usage;;
    esac
else
    _ak_usage
fi

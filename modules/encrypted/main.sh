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
##     Produces and reads encrypted zblocks
##
##     -h, --help                  Prints this help message
##     -l, --local-index           Prints an indexed table of your encrypted files
##     -i, --import <file>         #TODO
##     -a, --add <file>            Creates a data file from the encrypted file you point to
##     -r, --read <zblock>         Reads a zblock as a encrypted data
##     -c, --create                Vim is going to pop up, you will write and save your
##                                 encryptedletter and it's going to be save
##     -s, --specs                 Print specs of data block
##
fullprogrampath="$(realpath $0)"
MODULE="$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
PROGRAM="ak-module-$MODULE"
descriptionString="Module to read, create and add 'encrypted' zblocks"

source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$MODULE/lib.sh

if [ ! -z $1 ]; then
    case $1 in
        -h | --help) _ak_usage; exit;;
#        -l | --local-index) _ak_modules_encrypted_index; exit;;
        -l | --local-index) _ak_not_implemented $*; exit;;
#        -i | --import) _ak_modules_encrypted_import $2; exit;;
        -i | --import) _ak_not_implemented $*; exit;;
#        -a | --add) _ak_modules_encrypted_add_from_file $2; exit;;
        -a | --add) _ak_not_implemented $*; exit;;
        -c | --create) _ak_modules_encrypted_create; exit;;
#        -c | --create) _ak_not_implemented $*; exit;;
#        -r | --read) _ak_modules_encrypted_read $2; exit;;
        -r | --read) _ak_not_implemented $*; exit;;
#        -s | --specs) _ak_modules_encrypted_specs $2; exit;;
        -s | --specs) _ak_not_implemented $*; exit;;
        * ) _ak_usage;;
    esac
else
    _ak_usage
fi

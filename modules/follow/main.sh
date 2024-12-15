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
## You can maintain a list of friendly zchains or ids
##
## Usage:
##
##    -h, --help                  Prints this help message
##    -f, --follow                Adds a ... to your follow list
##    -l, --list                  Shows a list of your followings
##    -u, --unfollow              Unfollows a ...
##
fullprogrampath="$(realpath $0)"
MODULE="$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
PROGRAM="ak-module-$MODULE"
descriptionString="Following stuff"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$MODULE/lib.sh

if [ ! -z $1 ]
then
    case $1 in
        -h | --help) _ak_usage; exit;;
        -f | --follow) _ak_follow_follow $2; exit;;
        -l | --list) _ak_follow_list $2; exit;;
        -u | --unfollow) _ak_follow_unfollow $2; exit;;
        * ) _ak_usage;;
    esac
else _ak_usage
fi

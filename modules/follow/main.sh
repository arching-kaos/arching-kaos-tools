#!/bin/bash
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
PROGRAM="$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
descriptionString="Following stuff"

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_script
source $AK_MODULESDIR/$PROGRAM/lib.sh

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

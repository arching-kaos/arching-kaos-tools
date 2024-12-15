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
PROGRAM="ak-module-$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
source $AK_LIBDIR/_ak_script
_ak_not_implemented
exit 1

title(){
    echo "AK Roadmap tool"
}

usage(){
    title
}

search(){
    cd $HOME/projects
    PRJS="$(ls -1 .)"
    for prj in $PRJS
    do
        if [ -f $prj/ROADMAP.md ];
        then
            echo " - Roadmap found in $prj"
        fi
    done
}

if [ ! -z $1 ];
then
    case $1 in
        -h | --help) usage; exit;;
        search) search; exit;;
        *) usage; exit;;
    esac
else
    usage
    exit 0
fi

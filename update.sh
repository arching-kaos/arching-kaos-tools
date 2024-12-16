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
## Updates bin files
##
fullprogrampath="$(realpath $0)"
PROGRAM="$(basename $0)"
descriptionString="Arching Kaos Tools Updater"

source ./lib/_ak_log || source $AK_LIBDIR/_ak_log

find $AK_BINDIR -type l | while read link
do
    if [ ! -f $link ]
    then
        _ak_log_info "Non working link: $(basename $link) removing..."
        rm $link
        if [ $? -ne 0 ]
        then
            _ak_log_warning "FAILED!"
        else
            _ak_log_info "Succeed!"
        fi
    fi
done

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
    if [ ! -L $AK_BINDIR/$b ]
    then
        _ak_log_info "Non existing link: $(basename $b) creating..."
        ln -s $(pwd)/bin/$b $AK_BINDIR/$b
        if [ $? -ne 0 ]
        then
            _ak_log_warning "FAILED!"
        else
            _ak_log_info "Succeed!"
        fi
    fi
done

# Updates lib files
find $AK_LIBDIR -type l | while read link
do
    if [ ! -f $link ]
    then
        _ak_log_info "Non working link: $(basename $link) removing..."
        rm $link
        if [ $? -ne 0 ]
        then
            _ak_log_warning "FAILED!"
        else
            _ak_log_info "Succeed!"
        fi
    fi
done

find $AK_MODULESDIR -type l | while read link
do
    if [ ! -d $link ]
    then
        _ak_log_info "Non working link: $(basename $link) removing..."
        rm $link
        if [ $? -ne 0 ]
        then
            _ak_log_warning "FAILED!"
        else
            _ak_log_info "Succeed!"
        fi
    fi
done

# Find scripts and create symlinks
libfiles=$(ls -1 $(pwd)/lib)
for l in $libfiles
do
    if [ ! -L $AK_LIBDIR/$l ]
    then
        _ak_log_info "Non existing link: $(basename $l) creating..."
        ln -s $(pwd)/lib/$l $AK_LIBDIR/$l
        if [ $? -ne 0 ]
        then
            _ak_log_warning "FAILED!"
        else
            _ak_log_info "Succeed!"
        fi
    fi
done

# Find modules and create symlinks
modfiles=$(ls -1 $(pwd)/modules)
for m in $modfiles
do
    if [ ! -L $AK_MODULESDIR/$m ]
    then
        _ak_log_info "Non existing link: $(basename $m) creating..."
        ln -s $(pwd)/modules/$m $AK_MODULESDIR/$m
        if [ $? -ne 0 ]
        then
            _ak_log_warning "FAILED!"
        else
            _ak_log_info "Succeed!"
        fi
    fi
done

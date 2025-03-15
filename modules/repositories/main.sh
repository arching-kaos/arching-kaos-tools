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
source $AK_LIBDIR/_ak_zblock
source $AK_LIBDIR/_ak_utils
PROGRAM="ak-module-$(realpath $0 | rev |cut -d '/' -f 2 | rev)"
REPODIR="$HOME/projects"
BAREDIR="$HOME/bare"
REPOSTORE="$HOME/.arching-kaos/repostore"
if [ ! -d $BAREDIR ]; then mkdir $BAREDIR; fi
if [ ! -d $REPODIR ]; then echo "no $REPODIR" && exit; fi
if [ ! -f $REPOSTORE ]; then touch $REPOSTORE; fi
_ak_modules_repositories_import(){
    REPOS="$(ls -1 $REPODIR)"
    for PROJECT in $REPOS
    do
        cd $BAREDIR
        # Can be as well be
            # git clone --bare $REPODIR/$PROJECT/.git
        # or whatever form git let's you use
        git clone --bare http://git.h.kaotisk-hund.com/$PROJECT/.git
        if [ $? == 0 ]
        then
            cd $PROJECT.git
            git repack -a
            IPFS="$(_ak_ipfs_add .)"
            _ak_ipfs_key_gen "$PROJECT.git"
            _ak_ipfs_name_publish --key="$PROJECT.git" /ipfs/$IPFS
            cd $HOME/bare
        else
            echo "$PROJECT not a git repo"
        fi
    done
}

_ak_modules_repositories_update(){
    if [ ! -z $1 ]
    then
        USING="$1"
        REPO="$REPODIR/$1/.git"
        BARE="$BAREDIR/$1.git"
        BARENAME="$1.git"
        if [ -d $BARE ]
        then
            cd $BARE
            git pull
            git repack -a
            IPFS="$(_ak_ipfs_add .)"
            _ak_ipfs_name_publish --key="$BARENAME" /ipfs/$IPFS
            echo "DONE"
        else
            echo "NO BARE TO UPDATE"
            echo "updating all..."
        fi
    else
        BARES="$(ls -1 $BAREDIR)"
        cd $BAREDIR
        for PROJECT in $BARES
        do
            cd "$PROJECT"
            git pull
            git repack -a
            IPFS="$(_ak_ipfs_add .)"
            _ak_ipfs_name_publish --key="$PROJECT" /ipfs/$IPFS
            cd $BAREDIR
        done
    fi
}

append-if-needed(){
    under="$1"
    file="$HOME/.arching-kaos/repos"
    lines="$(cat $file)"
    found="no"
    for line in $lines
    do
        if [ $found == "yes" ]
        then
            echo "found $found"
            break
        else
            if [ "$line" == "$under" ]
            then
                found="yes"
                echo "found $found"
                break
            fi
        fi
    done
    if [ $found == "no" ]
    then
        echo $under > $file
    fi
}

_ak_modules_repositories_add(){
    PROJECT="$1"
    PROJECTDIR="$REPODIR/$PROJECT"
    BAREGITDIR="$BAREDIR/$PROJECT.git"
    if [ -d $PROJECTDIR ]
    then
        cd $HOME/bare
        git clone --bare $PROJECTDIR/.git
        if [ $? == 0 ]
        then
            cd $BAREGITDIR
            git repack -a
            IPFS="$(_ak_ipfs_add .)"
            try=_ak_ipfs_key_gen "$PROJECT.git"
            if [ $? == 0 ]
            then
                _ak_ipfs_name_publish --key="$PROJECT.git" /ipfs/$IPFS
                printf '{"project":"%s.git","ipns":"%s"}' $PROJECT $try > data
                _ak_zblock_pack "repos/add" $PWD/data
                echo "Done"
            fi
        fi
    else
        echo "$PROJECT not a git repo"
    fi
}

_ak_modules_repositories_index(){
    _ak_ipfs_key_list_full | grep -e '\.git'
}

set-as-profile(){
    IPFS=$(_ak_ipfs_add $REPOSTORE)
    if [ $? == 0 ]
    then
        profile set repositories $IPFS
    else
        echo error
    fi
}

_ak_modules_repositories_publish(){
    if [ ! -z $1 ]
    then
        echo "Filtering for $1..."
        index | grep "$1" > $REPOSTORE
        set-as-profile
    else
        echo "Publishing all..."
        index > $REPOSTORE
        set-as-profile
    fi
}

usage(){
    echo "-h, --help"
    echo "index | add | publish | update"
    exit
}

if [ ! -z $1 ]
then
    case $1 in
        -h | --help) usage; exit;;
        index) _ak_modules_repositories_index; exit;;
        add) _ak_modules_repositories_add "$2"; exit;;
        publish) _ak_modules_repositories_publish "$2"; exit;;
        update) _ak_modules_repositories_update "$2"; exit;;
        *) echo "No command $1";usage; exit;;
    esac
else
    usage
fi

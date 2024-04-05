#!/bin/bash
source $AK_LIBDIR/_ak_zblock
REPODIR="$HOME/projects"
BAREDIR="$HOME/bare"
REPOSTORE="$HOME/.arching-kaos/repostore"
if [ ! -d $BAREDIR ]; then mkdir $BAREDIR; fi
if [ ! -d $REPODIR ]; then echo "no $REPODIR" && exit; fi
if [ ! -f $REPOSTORE ]; then touch $REPOSTORE; fi
import(){
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

update(){
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

add(){
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

index(){
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

publish(){
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
        index) index; exit;;
        add) add "$2"; exit;;
        publish) publish "$2"; exit;;
        update) update "$2"; exit;;
        *) echo "No command $1";usage; exit;;
    esac
else
    usage
fi

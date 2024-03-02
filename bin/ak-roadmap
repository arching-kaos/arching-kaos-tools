#!/bin/bash
echo "$(basename $0) - Not implemented"
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

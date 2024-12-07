#!/usr/bin/env bash
podman_dir="podman"
now="$(date -u +%s)"

_build_container(){
    if [ ! -z $1 ] && [ -n "$1" ]
    then
        file="$podman_dir/ContainerFile.$1"
        distro="$(printf "%s" "$file"|cut -d '.' -f 2)"
        build_log="$now-podman-$distro-build_log"
        printf "Building %s container..." "$distro"
        podman build -f $file -t arching-kaos-tools-$distro . >> $build_log 2>&1
        if [ $? -ne 0 ]
        then
            printf "\tFailed!\n"
        else
            printf "\tSuccess!\n"
        fi
        tail -n 2 $build_log
    fi
}

_build_all_containers(){
    for file in $podman_dir/*
    do
        _build_container "$(basename $file | cut -d '.' -f 2)"
    done
}

if [ ! -z $1 ] && [ -n "$1" ]
then
    _build_container $1
else
    _build_all_containers
fi

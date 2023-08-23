#!/bin/bash
podman_dir="podman"
now="$(date -u +%s)"
build_log="$now-build_log"
for file in $podman_dir/*
do
    distro="$(printf "%s" "$file"|cut -d '.' -f 2)"
    printf "Building %s container..." "$distro"
    podman build -f $file -t arching-kaos-tools-$distro . >> $build_log 2>&1
    if [ $? -ne 0 ]
    then
        printf "\tFailed!\n"
    else
        printf "\tSuccess!\n"
    fi
done

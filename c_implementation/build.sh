#!/usr/bin/env bash
if [ ! -d $PWD/lib ]
then
    mkdir $PWD/lib
fi

find build_tree -type f | while read build_script
do
    bash ${build_script}
done

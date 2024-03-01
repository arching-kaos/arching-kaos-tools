#!/bin/bash

find $AK_BINDIR -type l | while read link
do
    if [ ! -f $link ]
    then
        echo "Non working link: $(basename $link) removing..."
        rm $link
    fi
done

# Find scripts and create symlinks
binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
    if [ ! -L $AK_BINDIR/$b ] ; then ln -s $(pwd)/bin/$b $AK_BINDIR/$b ;fi
done

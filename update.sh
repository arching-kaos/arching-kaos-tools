#!/bin/bash

# Find scripts and create symlinks

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
    if [[ ! -L $AK_BINDIR/$b ]] ; then ln -s $(pwd)/bin/$b $AK_BINDIR/$b ;fi
done

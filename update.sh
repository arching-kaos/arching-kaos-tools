#!/bin/bash

# Find scripts and create symlinks

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
	if [[ ! -L $BINDIR/$b ]] ; then ln -s $(pwd)/bin/$b $BINDIR/$b ;fi
done

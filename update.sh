#!/bin/bash

# Updates bin files
find $AK_BINDIR -type l | while read link
do
    if [ ! -f $link ]
    then
        echo "Non working link: $(basename $link) removing..."
        rm $link
    fi
done

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
    if [ ! -L $AK_BINDIR/$b ]
    then
        echo "Non existing link: $(basename $b) creating..."
        ln -s $(pwd)/bin/$b $AK_BINDIR/$b
    fi
done

# Updates lib files
find $AK_LIBDIR -type l | while read link
do
    if [ ! -f $link ]
    then
        echo "Non working link: $(basename $link) removing..."
        rm $link
    fi
done

find $AK_MODULESDIR -type l | while read link
do
    if [ ! -d $link ]
    then
        echo "Non working link: $(basename $link) removing..."
        rm $link
    fi
done

# Find scripts and create symlinks
libfiles=$(ls -1 $(pwd)/lib)
for l in $libfiles
do
    if [ ! -L $AK_LIBDIR/$l ]
    then
        echo "Non existing link: $(basename $l) creating..."
        ln -s $(pwd)/lib/$l $AK_LIBDIR/$l
    fi
done

# Find modules and create symlinks
modfiles=$(ls -1 $(pwd)/modules)
for m in $modfiles
do
    if [ ! -L $AK_MODULESDIR/$m ]
    then
        echo "Non existing link: $(basename $m) creating..."
        ln -s $(pwd)/modules/$m $AK_MODULESDIR/$m
    fi
done

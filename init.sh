#!/bin/bash
echo "INIT started"
if [[ -f $AK_ZGENESIS ]] ; then echo "$(ipfs add -q $AK_GENESIS)" > $AK_ZGENESIS;fi
if [[ ! -f $AK_ZCHAIN ]] ; then echo "$(ipfs key gen zchain)" > $AK_ZCHAIN;fi
if [[ ! -f $AK_ZLATEST ]] ; then cp $AK_ZGENESIS $AK_ZLATEST;fi
if [[ ! -f $AK_ZCHAINASC ]] ; then gpg -bao $AK_ZCHAINASC $AK_ZCHAIN;fi
if [[ ! -f $AK_ZZCHAIN ]] ; then echo $(ipfs add -q $AK_ZCHAINASC) > $AK_ZZCHAIN;fi
if [[ ! -f $AK_GENESISASC ]] ; then gpg -bao $AK_GENESISASC $AK_GENESIS;fi
if [[ ! -f $AK_ZGENESISASC ]] ; then echo $(ipfs add -q $AK_GENESISASC) > $AK_ZGENESISASC;fi
echo "Checking for /zarchive in IPFS FS..."
ipfs files ls /zarchive > /dev/null 2>&1
if [ $? != 0 ]; then
	ipfs files mkdir /zarchive > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Error"
	else
		echo "Created"
	fi
else
	echo "...Found"
fi
echo "Looking for /zlatest..."
ipfs files stat /zlatest > /dev/null 2>&1
if [ $? != 0 ]; then
	ipfs files cp /ipfs/$(cat $AK_ZGENESIS) /zlatest
	if [ $? != 0 ]; then
		echo "Problem copying $AK_ZGENESIS to /zlatest"
	else
		echo "Success"
	fi
else
	echo "...Found"
fi

# TODO GPG/PGP setup
# eg gpg2 --full-key-generate and/or gpg2 --set-default key
# or just question the user if they are going to use their
# existing one if any.



# TODO The thing is done, we are sitting on a genesis.
# We also have an IPNS name to use.

# Find scripts and create symlinks

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
	if [[ ! -L $AK_BINDIR/$b ]] ; then ln -s $(pwd)/bin/$b $AK_BINDIR/$b ;fi
done

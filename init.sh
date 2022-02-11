#!/bin/bash
#source ./config.sh
echo "INIT started"
#echo This is our work dir: $WORKDIR
if [[ ! -d $WORKDIR ]] ; then mkdir $WORKDIR ;fi
if [[ ! -d $CONFIGDIR ]] ; then mkdir $CONFIGDIR ;fi
if [[ ! -d $BINDIR ]]; then mkdir $BINDIR ;fi
if [[ ! -d $ZBLOCKDIR ]]; then mkdir $ZBLOCKDIR ;fi
if [[ ! -d $BLOCKDIR ]]; then mkdir $BLOCKDIR ;fi
if [[ ! -d $DATADIR ]]; then mkdir $DATADIR ;fi
if [[ ! -d $ARCHIVESDIR ]]; then mkdir $ARCHIVESDIR ;fi
if [[ ! -f $LOGSFILE ]]; then touch $LOGSFILE ;fi
if [[ ! -f $GENESIS ]] ; then touch $GENESIS;fi
if [[ ! -f $ZGENESIS ]] ; then echo "$(ipfs add -q $GENESIS)" > $ZGENESIS;fi
if [[ ! -f $ZCHAIN ]] ; then echo "$(ipfs key gen zchain)" > $ZCHAIN;fi
if [[ ! -f $ZLATEST ]] ; then cp $ZGENESIS $ZLATEST;fi
if [[ ! -f $ZCHAINASC ]] ; then gpg -bao $ZCHAINASC $ZCHAIN;fi
if [[ ! -f $ZZCHAIN ]] ; then echo $(ipfs add -q $ZCHAINASC) > $ZZCHAIN;fi
if [[ ! -f $GENESISASC ]] ; then gpg -bao $GENESISASC $GENESIS;fi
if [[ ! -f $ZGENESISASC ]] ; then echo $(ipfs add -q $GENESISASC) > $ZGENESISASC;fi
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
	ipfs files cp /ipfs/$(cat $ZGENESIS) /zlatest
	if [ $? != 0 ]; then
		echo "Problem copying $ZGENESIS to /zlatest"
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
	if [[ ! -L $BINDIR/$b ]] ; then ln -s $(pwd)/bin/$b $BINDIR/$b ;fi
done

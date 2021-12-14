#!/bin/bash
#source ./config.sh
echo "INIT started"
#echo This is our work dir: $WORKDIR
if [[ ! -d $WORKDIR ]] ; then mkdir $WORKDIR ;fi
if [[ ! -d $CONFIGDIR ]] ; then mkdir $CONFIGDIR ;fi
if [[ ! -d $BINDIR ]]; then mkdir $BINDIR ;fi
if [[ ! -d $ARCHIVESDIR ]]; then mkdir $ARCHIVESDIR ;fi
if [[ ! -f $GENESIS ]] ; then touch $GENESIS;fi
if [[ ! -f $ZGENESIS ]] ; then echo "$(ipfs add -q $GENESIS)" > $ZGENESIS;fi
if [[ ! -f $ZCHAIN ]] ; then echo "$(ipfs key gen zchain)" > $ZCHAIN;fi
if [[ ! -f $ZLATEST ]] ; then cp $ZGENESIS $ZLATEST;fi
if [[ ! -f $ZCHAINASC ]] ; then gpg2 -bao $ZCHAINASC $ZCHAIN;fi
if [[ ! -f $ZZCHAIN ]] ; then echo $(ipfs add -q $ZCHAINASC) > $ZZCHAIN;fi
if [[ ! -f $GENESISASC ]] ; then gpg2 -bao $GENESISASC $GENESIS;fi
if [[ ! -f $ZGENESISASC ]] ; then echo $(ipfs add -q $GENESISASC) > $ZGENESISASC;fi
ipfs files ls /zarchive > /dev/null 2>&1
if [ $? != 0 ]; then
	ipfs files mkdir /zarchive
fi
ipfs files stat /ZLATEST > /dev/null 2>&1
if [ $? != 0 ]; then
	ipfs files cp /ipfs/$(cat $ZGENESIS) /ZLATEST
fi

# TODO GPG/PGP setup
# eg gpg2 --full-key-generate and/or gpg2 --set-default key
# or just question the user if they are going to use their
# existing one if any.



# TODO The thing is done, we are sitting on a genesis.
# We also have an IPNS name to use.



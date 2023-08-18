#!/bin/bash

# TODO GPG/PGP setup:: possibly done
# eg gpg2 --full-key-generate and/or gpg2 --set-default key
# or just question the user if they are going to use their
# existing one if any.
ak_gpg_check_or_create(){
    gpg2 --homedir $AK_GPGHOME --list-keys | grep kaos@kaos.kaos -1
    if [ "$?" -ne "0" ]
    then
        gpg2 --homedir $AK_GPGHOME --batch --passphrase '' --quick-key-gen kaos@kaos.kaos rsa3072 sign 0
        AK_FINGERPRINT="$(gpg2 --homedir $AK_GPGHOME --list-keys | grep kaos@kaos.kaos -1 | head -n 1 | awk '{print $1}')"
        gpg2 --homedir $AK_GPGHOME --batch --passphrase '' --quick-add-key $AK_FINGERPRINT rsa3072 encrypt 0
    fi
}

ipfs_zarchive_check_or_mkdir(){
    printf "Checking for /zarchive in IPFS FS..."
    ipfs files ls /zarchive > /dev/null 2>&1
    if [ $? != 0 ]; then
        ipfs files mkdir /zarchive > /dev/null 2>&1
        if [ $? != 0 ]; then
            printf "\tError!\n"
            exit 1
        else
            printf "\tCreated!\n"
        fi
    else
        printf "\tFound\n"
    fi
}

ipfs_zlatest_check_or_create(){
    printf "Looking for /zlatest..."
    ipfs files stat /zlatest > /dev/null 2>&1
    if [ $? != 0 ]; then
        ipfs files cp /ipfs/$(cat $AK_ZGENESIS) /zlatest
        if [ $? != 0 ]; then
            printf "\tProblem copying %s to /zlatest!\n" "$AK_ZGENESIS"
            exit 1
        else
            printf "\tSuccess!\n"
        fi
    else
        printf "\tFound!\n"
    fi
}

printf "Initialization started... \n"

ak_gpg_check_or_create

if [[ -f $AK_ZGENESIS ]] ; then printf "%s" "$(ipfs add -q $AK_GENESIS)" > $AK_ZGENESIS;fi
if [[ ! -f $AK_ZCHAIN ]] ; then printf "%s" "$(ipfs key gen zchain)" > $AK_ZCHAIN;fi
if [[ ! -f $AK_ZLATEST ]] ; then cp $AK_ZGENESIS $AK_ZLATEST;fi
if [[ ! -f $AK_ZCHAINASC ]] ; then gpg2 --homedir $AK_GPGHOME -bao $AK_ZCHAINASC $AK_ZCHAIN;fi
if [[ ! -f $AK_ZZCHAIN ]] ; then printf "%s" "$(ipfs add -q $AK_ZCHAINASC)" > $AK_ZZCHAIN;fi
if [[ ! -f $AK_GENESISASC ]] ; then gpg2 --homedir $AK_GPGHOME -bao $AK_GENESISASC $AK_GENESIS;fi
if [[ ! -f $AK_ZGENESISASC ]] ; then printf "%s" "$(ipfs add -q $AK_GENESISASC)" > $AK_ZGENESISASC;fi

ipfs_zarchive_check_or_mkdir

ipfs_zlatest_check_or_create

# TODO The thing is done, we are sitting on a genesis.
# We also have an IPNS name to use.

# Find scripts and create symlinks

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
    if [[ ! -L $AK_BINDIR/$b ]]
    then
        printf "Creating symlink to %s..." "$b"
        ln -s $(pwd)/bin/$b $AK_BINDIR/$b
        if [ "$?" -ne "0" ]
        then
            if [ -L $AK_BINDIR/$b ]
            then
                printf "\tAlready exists!\n"
                exit 1
            fi
            printf "\tFailed!\n"
            exit 1
        fi
        printf "\tOK!\n"
    fi
done

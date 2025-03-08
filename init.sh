#!/usr/bin/env bash
#set -x
source lib/_ak_ipfs
source lib/_ak_settings
source lib/_ak_gpg

# TODO GPG/PGP setup:: possibly done
# eg gpg2 --full-key-generate and/or gpg2 --set-default key
# or just question the user if they are going to use their
# existing one if any.
ak_gpg_check_or_create(){
    gpg2 --homedir $AK_GPGHOME --list-keys | grep kaos@kaos.kaos -B 1
    if [ $? -ne 0 ]
    then
        gpg2 --homedir $AK_GPGHOME --batch --passphrase '' --quick-gen-key kaos@kaos.kaos rsa3072 sign 0
        AK_FINGERPRINT="$(gpg2 --homedir $AK_GPGHOME --list-keys | grep kaos@kaos.kaos -B 1 | head -n 1 | awk '{print $1}')"
        _ak_settings_set "gpg.fingerprint" "$AK_FINGERPRINT"
        gpg2 --homedir $AK_GPGHOME --batch --passphrase '' --quick-add-key $AK_FINGERPRINT rsa3072 encrypt 0
    fi
}

ipfs_zarchive_check_or_mkdir(){
    printf "Checking for /zarchive in IPFS FS..."
    _ak_ipfs files ls /zarchive > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        _ak_ipfs files mkdir /zarchive > /dev/null 2>&1
        if [ $? -ne 0 ]; then
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
    _ak_ipfs files stat /zlatest > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        _ak_ipfs files cp /ipfs/$(cat $AK_ZGENESIS) /zlatest
        if [ $? -ne 0 ]; then
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

if [ -f $AK_ZGENESIS ] ; then printf "%s" "$(_ak_ipfs add -q $AK_GENESIS)" > $AK_ZGENESIS;fi
if [ ! -f $AK_ZCHAIN ]
then
    _ak_ipfs key list | grep zchain
    if [ $? -ne 0 ]
    then
        printf "%s" "$(_ak_ipfs key gen zchain)" > $AK_ZCHAIN
    else
        printf "%s" "$(_ak_ipfs key list -l | grep zchain | awk '{ print $1 }')" > $AK_ZCHAIN
    fi
fi

if [ ! -f $AK_ZLATEST ] ; then cp $AK_ZGENESIS $AK_ZLATEST;fi
if [ ! -f $AK_ZCHAINASC ] ; then gpg2 --homedir $AK_GPGHOME -bao $AK_ZCHAINASC $AK_ZCHAIN;fi
if [ ! -f $AK_ZZCHAIN ] ; then printf "%s" "$(_ak_ipfs add -q $AK_ZCHAINASC)" > $AK_ZZCHAIN;fi
if [ ! -f $AK_GENESISASC ] ; then gpg2 --homedir $AK_GPGHOME -bao $AK_GENESISASC $AK_GENESIS;fi
if [ ! -f $AK_ZGENESISASC ] ; then printf "%s" "$(_ak_ipfs add -q $AK_GENESISASC)" > $AK_ZGENESISASC;fi

_ak_init_file_as_json_array $AK_ZPAIRSFILE
_ak_init_file_as_json_array $AK_ZPEERSFILE
_ak_init_file_as_json_array $AK_ZBLOCKSFILE

ipfs_zarchive_check_or_mkdir

ipfs_zlatest_check_or_create

# Find scripts and create symlinks

binfiles=$(ls -1 $(pwd)/bin)
for b in $binfiles
do
    if [ ! -L $AK_BINDIR/$b ]
    then
        printf "Creating symlink to %s..." "$b"
        ln -s $(pwd)/bin/$b $AK_BINDIR/$b
        if [ $? -ne 0 ]
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

# Find libs and create symlinks
libfiles=$(ls -1 $(pwd)/lib)
for b in $libfiles
do
    if [ ! -L $AK_LIBDIR/$b ]
    then
        printf "Creating symlink to %s..." "$b"
        ln -s $(pwd)/lib/$b $AK_LIBDIR/$b
        if [ $? -ne 0 ]
        then
            if [ -L $AK_LIBDIR/$b ]
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

# Find modules and create symlinks
modfiles=$(ls -1 $(pwd)/modules)
for m in $modfiles
do
    if [ ! -L $AK_MODULESDIR/$m ]
    then
        printf "Creating symlink to %s..." "$m"
        ln -s $(pwd)/modules/$b $AK_MODULESDIR/$m
        if [ $? -ne 0 ]
        then
            if [ -L $AK_MODULESDIR/$m ]
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

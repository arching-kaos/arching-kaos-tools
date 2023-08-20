#!/bin/bash
printf "Arching Kaos Tools - Uninstaller\n"
echo '--------------------------------'
if [ ! -d "$AK_WORKDIR" ] ; then printf "No arching-kaos found... Aborting...\n"; exit 1; fi
printf "Backing up your GPG keyring..."
tar cfz $AK_ROOT/aknet-gpg-keyring-backup-`date -u +%Y%m%d`.tar.gz $AK_GPGHOME > /dev/null 2>&1
if [ $? -ne 0 ]
then
    printf "\tFailed! Aborting...\n"
    exit 1
fi
printf "\tOK!\n"

printf "Removing %s..." "$AK_WORKDIR"
rm -rf $AK_WORKDIR
if [ $? -ne 0 ]
then
    printf "\tFailed! Aborting...\n"
    exit 1
fi
printf "\tOK!\n"

printf "Unsetting sourcing from .bashrc ..."
sed -i.bak -e 's/source.*arching-kaos\/rc//g' $HOME/.bashrc
if [ $? -ne 0 ]
then
    printf "\tFailed! Aborting...\n"
    exit 1
fi
printf "\tOK!\n"

printf "Resourcing .bashrc..."
source $HOME/.bashrc
if [ $? -ne 0 ]
then
    printf "\tFailed! Aborting...\n"
    exit 1
fi
printf "\tOK!\n"

#!/bin/bash
source ./config.sh
printf "%s" $(pwd) > wam
WHEREAMI="$(cat wam)"
if [ ! -d $AK_WORKDIR ] ; then mkdir $AK_WORKDIR ;fi
if [ ! -d $AK_CONFIGDIR ] ; then mkdir $AK_CONFIGDIR ;fi
if [ ! -d $AK_BINDIR ]; then mkdir $AK_BINDIR ;fi
if [ ! -d $AK_ZBLOCKDIR ]; then mkdir $AK_ZBLOCKDIR ;fi
if [ ! -d $AK_BLOCKDIR ]; then mkdir $AK_BLOCKDIR ;fi
if [ ! -d $AK_DATADIR ]; then mkdir $AK_DATADIR ;fi
if [ ! -d $AK_ARCHIVESDIR ]; then mkdir $AK_ARCHIVESDIR ;fi
if [ ! -f $AK_LOGSFILE ]; then touch $AK_LOGSFILE ;fi
if [ ! -f $AK_GENESIS ]; then touch $AK_GENESIS;fi
if [ ! -d $AK_MINEDBLOCKSDIR ]; then mkdir $AK_MINEDBLOCKSDIR; fi
if [ ! -f $AK_ZBLOCKSFILE ]; then mkdir $AK_ZBLOCKSFILE; fi
if [ ! -f $AK_ZPAIRSFILE ]; then mkdir $AK_ZPAIRSFILE; fi
if [ ! -d $AK_GPGHOME ]; then mkdir $AK_GPGHOME && chmod 700 -R $AK_GPGHOME; fi

touch $AK_WORKDIR/logs
logthis(){
	echo "Install script: $1" >> $AK_WORKDIR/logs
}

HAK=".arching-kaos"
logthis "Searching for $HAK folder and files"
if [ ! -d $HOME/$HAK ]; then
	mkdir $HOME/$HAK
	logthis "$HAK created in $HOME";
fi
logthis "Searching for rc"
if [ ! -f $HOME/$HAK/rc ]; then
	echo export PATH=$PATH:$HOME/$HAK/bin > $HOME/$HAK/rc
	cat config.sh >> $HOME/$HAK/rc
	logthis "New rc export to file";
fi
logthis "Searching for shell"
if [ $SHELL == "/usr/bin/zsh" ]; then
	SHELLRC=".zshrc"
	logthis "ZSH found";
elif [ $SHELL == "/usr/bin/bash" ]; then
	SHELLRC='.bashrc'
	logthis "BASH found";
else
	logthis "Unknown shell... defaulting to bash"
	SHELLRC='.bashrc'
fi
logthis "Searching if rc is already there"
grep "source $HOME/$HAK/rc" $HOME/$SHELLRC > /dev/null 2>&1
if [ $? == 0 ]; then
	logthis "Already installed";
else
	echo "source $HOME/$HAK/rc" >> $HOME/$SHELLRC
	logthis "$HAK installed at $HOME and sourced it in $SHELLRC"
	source $HOME/$HAK/rc;
fi
sh ipfs-check-install-setup-init-update
source ./config.sh
source $HOME/$SHELLRC
sh init.sh

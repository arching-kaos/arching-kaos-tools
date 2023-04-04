#!/bin/bash
source ./config.sh
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

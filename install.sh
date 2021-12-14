#!/bin/bash
logthis(){
	logger -t arching-kaos $1
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
	logthis "Unknown shell... skipping installation"
	exit;
fi
logthis "Searching if rc is already there"
grep "source ~/$HAK/rc" $HOME/$SHELLRC > /dev/null 2>&1
if [ $? == 0 ]; then
	logthis "Already installed";
else
	echo "source ~/$HAK/rc" >> $HOME/$SHELLRC
	logthis "$HAK installed at $HOME and sourced it in $SHELLRC";
fi
sh init.sh
sh ipfs-check-install-setup-init-update

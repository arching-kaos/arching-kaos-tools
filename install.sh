#!/bin/bash
clear
printf "Arching Kaos Tools Installer\n"
printf "============================\n"
printf "Welcome to our ever involving installer\n"
printf "We will be as verbose as possible, yet minimal\n"
printf "Our default behaviour is to ask the less is needed\n"
printf "\n"
printf "For minimum overall friction, we will ask sudo access only if it's\n"
printf "needed for a missing package.\n"
printf "\n"
printf "We discourage running the installer with sudo.\n"
printf "\n"
printf "Installation starts in..."
countdown=5
printf " %s" "$countdown"
countdown="$(expr $countdown - 1)"
sleep 1
while [ $countdown -gt 0 ]
do
    if [ $countdown -lt 10 ]
    then
        printf "\b\b %s" "$countdown"
    else
        printf "\b\b%s" "$countdown"
    fi
    countdown="$(expr $countdown - 1)"
    sleep 1
done
printf "\b\b starting!!!"
sleep 1
printf "\n"
packageManager=""
installCommand=""
dontAskFlag=""
checkPkgManager(){
    declare -a pkgmanagers=("dnf" "apt" "zypper" "pacman" "apk")
    for pkgm in "${pkgmanagers[@]}"
    do
        printf "Searching for package manager..."
        which $pkgm 2> /dev/null 1>&2
        if [ $? -eq 0 ]
        then
            printf '\tFound %s\n' "$pkgm"
            packageManager="$(which $pkgm)"
            installCommand="install"
            dontAskFlag="-y"
            break
        fi
    done
    if [ "$packageManager" == "" ]
    then
        printf "Could not find package manager\n"
        printf "In case you missing a package, you will be informed to install \
            it manually.\n"
    fi
}
checkPkgManager

sudoBin="sudo"
checkIfSudoAvailable(){
    which sudo 2> /dev/null 1>&2
    if [ $? -ne 0 ]
    then
        sudoBin=""
    fi
}
checkIfSudoAvailable

# Depedencies check and install
declare -a depedencies=("curl" "wget" "bash" "jq" "npm" "gpg" "git" "make" "screen" "gpg-agent")
for dep in "${depedencies[@]}"
do
    printf "Checking for %s..." "$dep"
    which $dep 2> /dev/null 1>&2
    if [ $? -ne 0 ]
    then
        printf "\t Not found!"
        if [ "$packageManager" != "" ]
        then
            printf "\t Attempting installation..."
            if [ "$dep" == "npm" ]
            then
                curl -o nvm_installer.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh
                if [ $? -ne 0 ]
                then
                    printf "\t Failed to download!\n"
                    exit 1
                fi
                printf "\t Downloaded!"
                bash nvm_installer.sh
                if [ $? -ne 0 ]
                then
                    printf "\t Failed to install nvm!\n"
                    exit 1
                fi
                printf "\t nvm installed!"
                printf "\t Installing latest nodejs..."
                export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
                nvm install $(nvm ls-remote|tail -n 1)
                if [ $? -ne 0 ]
                then
                    printf "\t Failed to install nodejs!\n"
                    exit 1
                fi
                printf "\t nodejs installed!\n"
            else
                $sudoBin $packageManager $installCommand $dontAskFlag $dep > /dev/null 2>&1
                if [ $? -ne 0 ]
                then
                    printf "\t Failed to install!\n"
                    exit 1
                fi
                printf "\t installed!\n"
            fi
        else
            printf "\t Don't know how to install!\n\nInstall $dep manually!\n"
            exit 1
        fi
    else
        printf "\t Found!\n"
    fi
done

# Work-around for gpg2 calls on distros that don't provide a link
which gpg2
if [ $? -ne 0 ]
then
    which gpg
    if [ $? -eq 0 ]
    then
        $sudoBin ln -s `which gpg` /usr/bin/gpg2
    fi
fi

source ./config.sh
printf "%s" $(pwd) > wam
WHEREAMI="$(cat wam)"
if [ ! -d $AK_WORKDIR ]
then
    mkdir $AK_WORKDIR
else
    printf "Error: Found %s.\n" "$AK_WORKDIR"
    printf "Please back up your previous installation\n"
    printf "and rerun ./install.sh.\n"
    exit 5
fi

if [ ! -d $AK_CONFIGDIR ] ; then mkdir $AK_CONFIGDIR ;fi
if [ ! -d $AK_BINDIR ]; then mkdir $AK_BINDIR ;fi
if [ ! -d $AK_SETTINGS ]; then mkdir $AK_SETTINGS ;fi
if [ ! -d $AK_LIBDIR ]; then mkdir $AK_LIBDIR ;fi
if [ ! -d $AK_MODULESDIR ]; then mkdir $AK_MODULESDIR ;fi
if [ ! -d $AK_ZBLOCKDIR ]; then mkdir $AK_ZBLOCKDIR ;fi
if [ ! -d $AK_BLOCKDIR ]; then mkdir $AK_BLOCKDIR ;fi
if [ ! -d $AK_DATADIR ]; then mkdir $AK_DATADIR ;fi
if [ ! -d $AK_ARCHIVESDIR ]; then mkdir $AK_ARCHIVESDIR ;fi
if [ ! -f $AK_LOGSFILE ]; then touch $AK_LOGSFILE ;fi
if [ ! -f $AK_GENESIS ]; then touch $AK_GENESIS;fi
if [ ! -d $AK_MINEDBLOCKSDIR ]; then mkdir $AK_MINEDBLOCKSDIR; fi
if [ ! -f $AK_ZBLOCKSFILE ]; then touch $AK_ZBLOCKSFILE; fi
if [ ! -f $AK_ZPAIRSFILE ]; then touch $AK_ZPAIRSFILE; fi
if [ ! -d $AK_CACHEDIR ]; then mkdir $AK_CACHEDIR; fi
if [ ! -d $AK_GPGHOME ]; then mkdir $AK_GPGHOME && chmod 700 -R $AK_GPGHOME; fi
if [ ! -d $AK_CHUNKSDIR ]; then mkdir -p $AK_CHUNKSDIR; fi
if [ ! -d $AK_LEAFSDIR ]; then mkdir -p $AK_LEAFSDIR; fi
if [ ! -d $AK_MAPSDIR ]; then mkdir -p $AK_MAPSDIR; fi

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
if [ $SHELL == "/usr/bin/zsh" ]
then
    SHELLRC=".zshrc"
    logthis "ZSH found";
elif [ $SHELL == "/usr/bin/bash" ]
then
    SHELLRC='.bashrc'
    logthis "BASH found";
else
    logthis "Unknown shell... defaulting to bash"
    SHELLRC='.bashrc'
fi

logthis "Searching if rc is already there"
grep "source $HOME/$HAK/rc" $HOME/$SHELLRC > /dev/null 2>&1
if [ $? -eq 0 ]
then
    logthis "Already installed";
else
    echo "source $HOME/$HAK/rc" >> $HOME/$SHELLRC
    logthis "$HAK installed at $HOME and sourced it in $SHELLRC"
    source $HOME/$HAK/rc;
fi

bash update.sh
bash ipfs-check-install-setup-init-update
source ./config.sh
source $HOME/$SHELLRC
bash init.sh
cd api
npm i
cd ..
make
if [ $? -ne 0 ]
then
    printf 'Building API daemon failed\n'
    exit 1
fi
ln -s $WHEREAMI/build/ak-daemon $AK_BINDIR/ak-daemon

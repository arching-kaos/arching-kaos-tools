#!/usr/bin/env bash
###
### arching-kaos-tools
### Tools to interact and build an Arching Kaos Infochain
### Copyright (C) 2021 - 2025  kaotisk
###
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation, either version 3 of the License, or
### (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
### GNU General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program.  If not, see <http://www.gnu.org/licenses/>.
###
##
## Welcome to our ever involving installer
## We will be as verbose as possible, yet minimal
##
## Our default behaviour is to ask the less is needed
##
## For minimum overall friction, we will ask sudo access only if it's
## needed for a missing package.
##
## We discourage running the installer with sudo.
##
clear

export AK_DEBUG="yes"
fullprogrampath="$(realpath $0)"
PROGRAM="$(basename $0)"
descriptionString="Arching Kaos Tools Installer"

if [ -d "${HOME}/.arching-kaos" ]
then
    printf '%s\n' "Error: Found ~/.arching-kaos directory."
    printf '%s\n' "Please backup your previous installationr and rerun ./install.sh."
    exit 1
fi

source ./config.sh
if [ $? -ne 0 ]
then
    printf "Error: Sourcing ./config.sh failed"
    exit 2
fi

printf "%s" $(pwd) > wam
WHEREAMI="$(cat wam)"
if [ ! -d $AK_WORKDIR ]
then
    mkdir $AK_WORKDIR
else
    printf "Error: Found %s.\n" "$AK_WORKDIR"
    printf "Please back up your previous installation\n"
    printf "and rerun ./install.sh.\n"
    exit 3
fi

touch $AK_LOGSFILE

source ./lib/_ak_log
source ./lib/_ak_script
_ak_usage

printf "Installation starts in..."

countdown_seconds(){
    default_countdown=5
    if [ ! -z "$1" ] && [ -n "$1" ]
    then
        if [ "$(echo -n $1 | sed -e 's/^[0-9]*$//g')" == "" ]
        then
            countdown=$1
        else
            countdown=${default_countdown}
        fi
    else
        countdown=${default_countdown}
    fi
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
}

countdown_seconds 5


_ak_check_and_create_dir $AK_CONFIGDIR
_ak_check_and_create_dir $AK_BINDIR
_ak_check_and_create_dir $AK_SETTINGS
_ak_check_and_create_dir $AK_LIBDIR
_ak_check_and_create_dir $AK_MODULESDIR
_ak_check_and_create_dir $AK_ZBLOCKDIR
_ak_check_and_create_dir $AK_BLOCKDIR
_ak_check_and_create_dir $AK_DATADIR
_ak_check_and_create_dir $AK_ARCHIVESDIR
_ak_check_and_create_dir $AK_MINEDBLOCKSDIR
_ak_check_and_create_dir $AK_CACHEDIR
_ak_check_and_create_dir $AK_CHUNKSDIR
_ak_check_and_create_dir $AK_LEAFSDIR
_ak_check_and_create_dir $AK_MAPSDIR
_ak_check_and_create_dir $AK_GPGHOME
chmod 700 $AK_GPGHOME
_ak_let_there_be_file $AK_ZLATEST_HISTORY
_ak_let_there_be_file $AK_GENESIS
_ak_let_there_be_file $AK_ZBLOCKSFILE
_ak_let_there_be_file $AK_ZPAIRSFILE

packageManager=""
installCommand=""
dontAskFlag=""
checkPkgManager(){
    declare -a pkgmanagers=("dnf" "apt" "zypper" "pacman" "apk")
    printf "Searching for package manager..."
    for pkgm in "${pkgmanagers[@]}"
    do
        printf "? ${pkgm}"
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
declare -a depedencies=("curl" "bash" "jq" "npm" "gpg" "git" "make" "screen" "gpg-agent")
for dep in "${depedencies[@]}"
do
    printf "Checking for %s..." "$dep"
    which $dep 2> /dev/null 1>&2
    if [ $? -ne 0 ]
    then
        printf "\t Not found!"
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
            export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
            [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
            printf "\t Installing latest nodejs..."
            nvm install $(nvm ls-remote|tail -n 1|sed -e 's/ *//g')
            if [ $? -ne 0 ]
            then
                printf "\t Failed to install nodejs!\n"
                exit 1
            fi
            printf "\t nodejs installed!\n"
        elif [ "$packageManager" != "" ]
        then
            printf "\t Attempting installation..."
                $sudoBin $packageManager $installCommand $dontAskFlag $dep > /dev/null 2>&1
                if [ $? -ne 0 ]
                then
                    printf "\t Failed to install!\n"
                    exit 1
                fi
                printf "\t installed!\n"
        else
            printf "\t Don't know how to install!\n\nInstall $dep manually!\n"
            exit 1
        fi
    else
        printf "\t Found!\n"
    fi
done

# Work-around for gpg2 calls on distros that don't provide a link
_ak_log_debug "Looking for gpg2 link"
which gpg2 > /dev/null 2>&1
if [ $? -ne 0 ]
then
    which gpg > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        _ak_log_debug "Making a gpg2 link"
        $sudoBin ln -s `which gpg` /usr/bin/gpg2
    fi
fi

HAK=".arching-kaos"
_ak_log_debug "Searching for $HAK directory"
if [ ! -d $HOME/$HAK ]; then
    mkdir $HOME/$HAK
    _ak_log_debug "$HAK created in $HOME";
fi

_ak_log_debug "Searching for rc"
if [ ! -f $HOME/$HAK/rc ]; then
    echo export PATH=$PATH:$HOME/$HAK/bin > $HOME/$HAK/rc
    cat config.sh >> $HOME/$HAK/rc
    _ak_log_debug "New rc export to file";
fi

_ak_log_debug "Searching for shell"
if [ -f "~/.zshrc" ]
then
    SHELLRC="${HOME}/zshrc"
    _ak_log_debug "ZSH found";
elif [ -f "${HOME}/.bashrc" ]
then
    SHELLRC="${HOME}/.bashrc"
    _ak_log_debug "BASH found";
else
    _ak_log_debug "Unknown shell... defaulting to ~/.shrc"
    SHELLRC="${HOME}/.shrc"
fi

_ak_log_debug "Searching if rc is already there"
grep "source $HOME/$HAK/rc" $SHELLRC > /dev/null 2>&1
if [ $? -eq 0 ]
then
    _ak_log_debug "Already installed";
else
    echo "source $HOME/$HAK/rc" >> $SHELLRC
    _ak_log_debug "$HAK installed at $HOME and sourced it in $SHELLRC"
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
else
    ln -s $WHEREAMI/build/ak-daemon $AK_BINDIR/ak-daemon
fi

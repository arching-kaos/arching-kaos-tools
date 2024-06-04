#!/bin/sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
git clone https://github.com/cjdelisle/cjdns
cd cjdns
./do
if [ $? -ne 0 ]
then
    echo "Failed to compile cjdns"
    exit 1
fi
cd ..

# Copy binaries to /usr/bin
sudo cp cjdns/cjdroute /usr/bin/
sudo cp cjdns/target/release/makekeys /usr/bin/
sudo cp cjdns/target/release/mkpasswd /usr/bin/
sudo cp cjdns/target/release/privatetopublic /usr/bin/
sudo cp cjdns/target/release/publictoip6 /usr/bin/
sudo cp cjdns/target/release/randombytes /usr/bin/
sudo cp cjdns/target/release/sybilsim /usr/bin/

# Copy cjdns tools to $AK_WORKDIR/bin
ln -s `realpath cjdns/tools/dumpLinks` ~/.arching-kaos/bin/dumpLinks
ln -s `realpath cjdns/tools/cexec` ~/.arching-kaos/bin/cjdns-cexec
ln -s `realpath cjdns/tools/peerStats` ~/.arching-kaos/bin/peerStats

# Systemd setup
sudo cp cjdns/contrib/systemd/cjdns.service /etc/systemd/system/
sudo cp cjdns/contrib/systemd/cjdns-resume.service /etc/systemd/system
sudo systemctl enable --now cjdns.service

# TODO Or openrc

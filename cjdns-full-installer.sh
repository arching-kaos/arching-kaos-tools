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
sudo cp cjdns/cjdroute /usr/bin/
sudo cp cjdns/target/release/makekeys /usr/bin/
sudo cp cjdns/target/release/mkpasswd /usr/bin/
sudo cp cjdns/target/release/privatetopublic /usr/bin/
sudo cp cjdns/target/release/publictoip6 /usr/bin/
sudo cp cjdns/target/release/randombytes /usr/bin/
sudo cp cjdns/target/release/sybilsim /usr/bin/
sudo cp cjdns/contrib/systemd/cjdns.service /etc/systemd/system/
sudo cp cjdns/contrib/systemd/cjdns-resume.service /etc/systemd/system
cp cjdns/tools/dumpLinks ~/.arching-kaos/bin/
sudo systemctl enable --now cjdns.service

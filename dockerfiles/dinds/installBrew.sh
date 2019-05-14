#/bin/bash

#https://github.com/Linuxbrew/brew/wiki/Alpine-Linux

apk update
apk add bash build-base curl file git gzip libc6-compat ncurses ruby ruby-dbm ruby-etc ruby-irb ruby-json sudo


adduser -D -s /bin/bash linuxbrew
echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
su -l linuxbrew


echo "\n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
export PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH

brew update
brew doctor
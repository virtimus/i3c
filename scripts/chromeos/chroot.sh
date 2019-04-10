#!/bin/bash

if [ ! -e /mnt/stateful_partition/i3c ]; then
	mkdir /mnt/stateful_partition/i3c
fi

export J=$HOME/$1

mkdir  $J
mkdir  $J/bin
sudo mount --bind /bin $J/bin
mkdir  $J/boot
sudo mount --bind /boot $J/boot
mkdir  $J/build
sudo mount --bind /build $J/build
mkdir  $J/dev
sudo mount --bind /dev $J/dev
mkdir  $J/etc
sudo mount --bind /etc $J/etc
mkdir  $J/home
sudo mount --bind /home $J/home
mkdir  $J/lib
sudo mount --bind /lib $J/lib
mkdir  $J/lib64
sudo mount --bind /lib64 $J/lib64
mkdir  $J/lost+found
sudo mount --bind /lost+found $J/lost+found
mkdir  $J/mnt
sudo mount --bind /mnt $J/mnt
mkdir  $J/opt
sudo mount --bind /opt $J/opt
mkdir  $J/proc
sudo mount --bind /proc $J/proc
mkdir  $J/root
#sudo mount --bind /root $J/root
mkdir  $J/run
sudo mount --bind /run $J/run
mkdir  $J/sbin
sudo mount --bind /sbin $J/sbin
mkdir  $J/sys
sudo mount --bind /sys $J/sys
mkdir  $J/tmp
sudo mount --bind /tmp $J/tmp
mkdir  $J/usr
sudo mount --bind /usr $J/usr
mkdir  $J/var
sudo mount --bind /var $J/var
mkdir  $J/i3c
sudo mount --bind /mnt/stateful_partition/i3c $J/i3c

sudo chroot $J /bin/bash


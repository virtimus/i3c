## Linux Mint "from scratch" experiment

I'm trying to:

- extract rootfs from official "Tara" iso image (cinnamon)
- apply the fs to a docker container
- configure/install desktop/rdp
- use as efemeral desktop environment for development

Ended with success - image is running, acces to rdp ok, package manager is working ...

## Steps:

###download mint iso (ie):
cd /tmp
curl -fSL http://ftp.icm.edu.pl/pub/Linux/dist/linuxmint/isos/stable/19/linuxmint-19-cinnamon-64bit-v2.iso -o linuxmint-19-cinnamon-64bit-v2.iso

###verify iso content (according https://linuxmint.com/verify.php)

curl -fSL https://ftp.heanet.ie/mirrors/linuxmint.com/stable/19/sha256sum.txt -o sha256sum.txt
curl -fSL https://ftp.heanet.ie/mirrors/linuxmint.com/stable/19/sha256sum.txt.gpg -o sha256sum.txt.gpg
sha256sum -b *.iso
cat sha256sum.txt
#### authenticity
gpg --keyserver keyserver.ubuntu.com --recv-key "27DE B156 44C6 B3CF 3BD7  D291 300F 846B A25B AE09"
or
gpg --keyserver keyserver.ubuntu.com --recv-key A25BAE09
gpg --list-key --with-fingerprint A25BAE09

then:
gpg --verify sha256sum.txt.gpg sha256sum.txt




###mount the iso 
mkdir /mnt/tmpmintiso
sudo mount -o loop /tmp/linuxmint-19-cinnamon-64bit-v2.iso /mnt/tmpmintiso
(warning about ro ok)
### Copy sfs out
cp /mnt/tmpmintiso/casper/filesystem.squashfs /tmp

### unsquash
cd /tmp && sudo unsquashfs filesystem.squashfs

### prepare docker image
cd /tmp/squashfs-root && sudo tar -c . | docker import - mint19


## Refs:

https://askubuntu.com/questions/222376/how-can-i-extract-the-deb-files-from-the-ubuntu-iso

http://sharadchhetri.com/2018/10/09/how-to-create-ubuntu-docker-base-image/
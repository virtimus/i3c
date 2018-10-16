## Linux Mint "from scratch" experiment

I'm trying to:

- extract rootfs from official "Tara" iso image (cinnamon)
- apply the fs to a docker container
- configure/install desktop/rdp
- use as efemeral desktop environment for development

Ended with success - image is running, acces to rdp ok, package manager is working ...

## Steps:

###mount iso 
sudo mount -o loop /i3c/data/mint/iso/linuxmint-19-cinnamon-64bit-v2.iso /mnt/tmpiso

### Copy sfs out
cp /mnt/tmpiso/casper/filesystem.squashfs /tmp

### unsquash
cd /tmp && sudo unsquashfs filesystem.squashfs

### prepare docker image
cd /tmp/squashfs-root && sudo tar -c . | docker import - mint19


## Refs:

https://askubuntu.com/questions/222376/how-can-i-extract-the-deb-files-from-the-ubuntu-iso

http://sharadchhetri.com/2018/10/09/how-to-create-ubuntu-docker-base-image/
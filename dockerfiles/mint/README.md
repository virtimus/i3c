

dev version:

apt-get install libsvn-java


https://stackoverflow.com/questions/14692353/executing-a-bash-script-upon-file-creation

apt-get install incron
echo root > /etc/incron.allow
service incron start


miraclecast
sudo apt-get install libtool  libudev-dev libudev1 libreadline-dev
https://github.com/albfan/miraclecast/wiki/Building

https://github.com/albfan/miraclecast/issues/4

gstreamer
apt-get install libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools

samba - client
 sudo mount -t cifs //vps1.i3c.cloud/ shared/ -o rw
samba server

apt-get install system-config-samba
sudo touch /etc/libuser.conf
system-config-samba

https://community.linuxmint.com/tutorial/view/1861
mount -t cifs //hostname-or-ipaddress/sharename -o username='username',domain='domainname-or-workgroup' /mnt/mysamba



cd /src
git clone https://github.com/brianb/mdbtools.git
cd mdbtools
sudo apt-get update
sudo apt-get install -y  libtool automake autoconf bison flex txt2man iodbc unixodbc libgnomeui-dev
autoreconf -i -f
./configure
#./configure --with-unixodbc=/usr/local
su -
cd /src/mdbtools 
make install
#no gmdb2 - installing kexi...
sudo apt-get install kexi kexi-data kexi-mysql-driver kexi-postgresql-driver kexi-web-form-widget libkf5kexiv2-dev libkf5kexiv2-15.0.0

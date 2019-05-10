#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Start: i3c/bootstrap.sh ..."
echo "------------------------------------------------------------------------"
CONTAINER=i3c
RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

i3cHome='/i3c/i3c';	

sudo apt-get install -y curl git

sudo sh -c 'echo "export I3C_HOME=/i3c/i3c" > /etc/profile.d/i3c.sh'

if [ ! -e /i ]; then
   ln -s $i3cHome/i3c.sh /i
fi   

if [ "$RUNNING" == "true" ]; then
    echo "I3C_FINAL - $CONTAINER is running."
    exit 0
fi

#dtnow=$(date +%Y%m%d%H%M%S);
#if [ -e /i ]; then	
# 	mv /i /i.$dtnow.bak	
#fi
#if [ -e /i3c ]; then	
# 	mv /i3c /i3c.$dtnow.bak	
#fi

if [ ! -e /i3c ]; then
	mkdir /i3c
fi
if [ ! -e /i3c/log ]; then
	mkdir /i3c/log
fi
if [ ! -e /i3c/data ]; then	
	mkdir /i3c/data
fi	

#if [ ! -e "/log" ]; then
#    ln -s /i3c/log /log
#fi

if [ ! -e /i3c/i3c ]; then
	cd /i3c
	git clone https://github.com/virtimus/i3c.git
	cd i3c
	echo ". /i3c/i3c/env.sh" >> ~/.bashrc
else
	cd /i3c/i3c
	git pull
fi	
find -name '*.sh' -exec  chmod a+x {} \;
./i3c-install/bootstrap.sh 
#> /log/bootstrap-install.log 2>&1

echo "------------------------------------------------------------------------"
echo "Started: i3c-install/bootstrap.sh. Look at [/i3c|/var]/log/bootstrap-install.log for results."
echo "------------------------------------------------------------------------"

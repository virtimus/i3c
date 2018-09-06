#!/bin/bash

if [ ! -e /i3c ]; then

	secs=10;
	echo "###################################################################################";
	echo "";
	echo " i3c.cloud bootstrap-wsl.sh script - running installation of docker components ... "
	echo "";
	echo " Press 'q' to quit installation, any other key to continue. $secs timeout.  "
	echo "";
	echo "###################################################################################";
	read -n 1 -t $secs -p "Input Selection:" mainmenuinput
	case "$mainmenuinput" in
		q)
		exit 0;
		;;
		*)
		echo "";
		echo "Setup processing ..."
	esac

	sudo apt-get update
	sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get -y install docker-ce
	echo "###################################################################################";
	echo "";
	echo "Making root i3c folder (/i3c) ..."
	ln -s /mnt/c/i3cRoot /i3c
	echo "###################################################################################";
	echo "";
	echo "Installing /i3c/env.sh script ..."	
	#. /i3c/env.sh
	echo ". /i3c/env.sh" >> ~/.bashrc
	echo "###################################################################################";
	echo "";
	echo "Runing main i3c/bootstrap.sh script ..."	
	curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.sh | bash
	
fi

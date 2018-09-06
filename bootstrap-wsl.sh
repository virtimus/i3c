#!/bin/bash

if [ ! -e /i3c ]; then
	secs=10;
	echo "###################################################################################";
	echo " i3c.cloud bootstrap-wsl.sh script - running installation of docker components ... "
	echo ""
	echo " Press 'q' to quit installation, any other key to continue. $secs timeout.  "
	echo "###################################################################################";
	read -n 1 =t $secs -p "Input Selection:" mainmenuinput
	switch ($mainmenuinput)
	case "$mainmenuinput" in
		q)
		exit 0;
		;;
		*)
		echo "Setup processing ..."
	esac

	sudo apt-get update
	sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
	
	echo "ln -s /mnt/c/i3cRoot /i3c"
	#ln -s /mnt/c/i3cRoot /i3c
	
	
fi

#!/bin/bash
 



case "$1" in
	startup)
	
		if [ ! -e /src/kantu/.docker ]; then
			cp -rpT /src/kantu.backup /src/kantu
			touch /src/kantu/.docker
		fi
		

		#cp /run/secrets/kantu/*.json /src/kantu/src/config/
		cd /src/kantu
		npm run build && npm run build-ff
		cd /src
		#-d /src/kantu
		./make-kantu.sh
		#cd /src/kantu/dist_ff
		#cd /src/kantu/src
		#//mkdir -p /usr/share/mozilla/extensions/kantu@i3c.pl
		mkdir -p /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
		#cp -rpT /src/kantu/dist_ff /usr/share/mozilla/extensions/kantu@i3c.pl
		cd /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
		ln -sf /src/kantu/dist_ff kantu@i3c.pl
		#mkdir -p /usr/share/mozilla/extensions/i3c@i3c.pl
		#cp -rpT /src/i3cExt /usr/share/mozilla/extensions/i3c@i3c.pl
		ln -sf /src/i3cExt i3c@i3c.pl
		#cd /src/kantu/dist_ff
		#web-ext run	
		firefox
		
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-kantu: ${@:2}"
		;;
	help)
		echo "Usage:"	
		echo "======================================"
		;;
	*)
		. ${I3C_HOME}/run.sh
		;;		
esac
#!/bin/bash

#echo "Starting /run-xrdp-mint.sh script ...";

case "$1" in
	dpkg-get-sel)
		dpkg --get-selections
		;;
	journal)
		journalctl -xb
		;;	
	startup)
		#dbus-daemon --system --fork
		service dbus start		
		nohup /usr/bin/docker-entrypoint.sh supervisord &	
		echo "==== /run-startup.sh ..."
		. /run-startup.sh
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-xrdp-mint.sh: ${@:2}"
		;;
	help)
		echo "Usage(run-xrdp-mint):"	
		echo "======================================"
		echo "dpkg-get-sel - list of selected software packages"
esac

#. ${I3C_HOME}/run.sh
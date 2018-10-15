#!/bin/bash

echo "Starting /run-xrdp-ubuntu.sh script ...";

case "$1" in
	dpkg-get-sel)
		dpkg --get-selections
		;;
	startup)
		/usr/bin/docker-entrypoint.sh supervisord &	
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-xrdp-ubuntu.sh: ${@:2}"
		;;
	help)
		echo "Usage(run-xrdp-ubuntu):"	
		echo "======================================"
		echo "dpkg-get-sel - list of selected software packages"
esac

#. ${I3C_HOME}/run.sh
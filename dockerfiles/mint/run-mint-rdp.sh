#!/bin/bash

case "$1" in
	dpkg-get-sel)
		dpkg --get-selections
		;;
	journal)
		journalctl -xb
		;;	
	startup)
		. ${I3C_HOME}/init.sh	
		. /run-defaults.sh	
		/usr/bin/docker-entrypoint.sh supervisord &
		. ${I3C_HOME}/clean.sh		
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-mint-rdp.sh: ${@:2}"
		;;
	help)
		echo "Usage(run-mint-rdp):"	
		echo "======================================"
		echo "dpkg-get-sel - list of selected software packages"
		;;
	*)
		. ${I3C_HOME}/run.sh
		;;		
esac


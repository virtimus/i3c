#!/bin/bash

case "$1" in
	adduser)
		sudo useradd -m -s /bin/bash -g user $2
		;;
	addsuser)
		sudo useradd -m -s /bin/bash -g root $2
		sudo echo "$2    ALL=(ALL) ALL" >> /etc/sudoers
		;;
	update-locale)
		sudo update-locale LANG=$2
		;;
	dpkg-get-sel)
		dpkg --get-selections
		;;
	journal)
		journalctl -xb
		;;	
	startup)
		. ${I3C_HOME}/init.sh	
		. /run-startup.sh	
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
		if [ -e /i3c/data/run.sh ]; then
		   . /i3c/data/run.sh "$@"	
		else
			. ${I3C_HOME}/run.sh "$@"
		fi		
		;;		
esac


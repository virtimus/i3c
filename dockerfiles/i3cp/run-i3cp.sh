#!/bin/bash

#dnsmasq

_init(){
	
	if [ ! -e /var/log/nginx ]; then
		mkdir /var/log/nginx
	fi	
	#if [ ! -e /app/nginx.tmpl ]; then
	#	cp -rp /app.backup/* /app
	#fi
	
}


case "$1" in
	reload)
		 nginx -s reload
		 ;;	
	startup)
		_init
		#	while true; do
		#		sleep 20
		#	done
		#this guy is memory eater ...	
		#sudo /etc/init.d/clamav-daemon stop 
		#service clamav-freshclam stop
		#mv -f /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.bak 
		forego start -r
		echo "WARNING! check if init was done (/r init)"
		while true; do
			sleep 20
			#correcting stupid problem i had no time to track
			#find /etc/apache2/sites-available -name "*.err" | while read -r line; do mv $line ${line%.*}; done
			#/usr/local/ispconfig/server/server.sh 2>&1 			
			#/usr/local/ispconfig/server/server.sh 2>&1  
		done
		;;
	echo)
		echo "Echo from /run-ispc: ${@:2}"
		;;
	help)
		echo "Usage:"	
		echo "======================================"
		;;
	*)
		. ${I3C_HOME}/run.sh
		;;		
esac




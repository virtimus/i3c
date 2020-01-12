#!/bin/bash

case "$1" in
	startup)
		if [ ! -e /mosquitto/config/mosquitto.conf ]; then
			cp -rp /mosquitto/config.backup/* /mosquitto/config
		fi
		echo 'start mosquitto'
		/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-mqtt.sh: ${@:2}"
		;;
	*)
		echo "/r Usage(run-mqtt):"	
		echo "======================================"
		echo "docker exec ehpl/r echo 'Hello World!'"
		;;
esac
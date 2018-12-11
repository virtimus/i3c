#!/bin/bash

case "$1" in
	startup)
		. ${I3C_HOME}/init.sh
		echo "MYSQL_ROOT_PASSWORD:$MYSQL_ROOT_PASSWORD"
		. /usr/local/bin/docker-entrypoint.sh mysqld
		. ${I3C_HOME}/clean.sh
		;;
	*)
		. ${I3C_HOME}/run.sh
		;;
esac

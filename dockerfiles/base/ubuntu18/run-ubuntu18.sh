#!/bin/bash

echo "Starting /run_ubuntu18 script ...";

case "$1" in
	startup)
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-ubuntu18: ${@:2}"
		;;
	help)
		echo "Usage:"	
		echo "======================================"
		echo "- add run.sh script to Your project."
		echo "- include or '. /run-ubuntu18.sh' in the script"
		echo "- add Your operations in Your run.sh"
		echo "- add Your operation before including if You want to override"
		echo "- add "
		echo "      COPY ./run-mydecent.sh /run-mydecent.sh && ln -sfn /run-mydecent.sh /r"
		echo "      RUN chmod a+x /run-mydecent.sh"
		echo " to Your dockerfile."
esac

. ${I3C_HOME}/run.sh
	
		
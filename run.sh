#!/bin/bash

echo "=================================================================="
echo " i3c.Cloud $i3cVersion"
echo " On $(lsb_release -a | grep Description:)"
echo "=================================================================="

#one command for all
alias i-apk='/r install';

case "$1" in
	startup)
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run.sh: ${@:2}"
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
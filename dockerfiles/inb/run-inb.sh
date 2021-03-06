#!/bin/bash

inbPath=/data/notebook 
withWatch=true;

case "$1" in
		secret)
		cat /i3c/.secrets/.secrets/$2;
		;;
	stop)
		cd $inbPath
		echo "Stoping inb ..."
		make stop
		;;	
	startup)
		if [ ! -e $inbPath/.docker ]; then
			if [ ! -e $inbPath ]; then
				mkdir $inbPath
			fi
			cp -rpT /data.notebook.backup $inbPath
			touch $inbPath/.docker			
		fi
		if [ -e $inbPath/.docker ]; then
			rm -R /data.notebook.backup
		fi
		ln -sf /i3c/i3c/i3c.sh /i
		/i sc _init
		if [ ! -e $inbPath/notebooks ]; then 
			mkdir $inbPath/notebooks
		fi
		cd $inbPath/notebooks
		
		#some custom defaults
		jupyter nbextension enable scroll_down/main
		
		#put /root/.jupyter in volume to control the config
		echo "n\n" | jupyter notebook --generate-config
		
		#alias python='python3'
		if [ "$withWatch" = true ]; then
			echo ""
			(npm run build:watch > /dev/null 2>&1) &
		fi	
		python3 -m notebook --port 8888 --ip=0.0.0.0 --allow-root
		#//make run
		while true; do
			sleep 1000
		done
		;;
	echo)
		echo "Echo from /run-inb: ${@:2}"
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
		;;
	*)
		. /run-ubuntu18.sh
		;;		
esac
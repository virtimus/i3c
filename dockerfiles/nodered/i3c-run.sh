#!/bin/bash


dParams="-d -p 1880:1880 \
		 -v /var/run/docker.sock:/var/run/docker.sock" 


#doCommand=false

i3cAfter(){
	#docker exec i3cp sh -c "cd /servicebot-deploy/ && docker-compose up -d"
	#echo "=======================runing link"
	docker exec -u 0 nodered sh -c 'ln -s /i3c/i3c.sh /i'
	docker exec -u 0 nodered sh -c 'chmod a+rw /var/run/docker.sock'
	if [ ${i3cConfig[keepRunning]} -eq 1 ]; then
		echo '#generated from i3c/nodered\n /i crun nodered' > /i3c/data/i3c/periodic/15min/checkNodeRedIsRunning
	fi	
	echo "access nodeRed at http:[host]:1880"
}
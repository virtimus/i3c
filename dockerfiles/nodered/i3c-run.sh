#!/bin/bash


dParams="-d -p 1880:1880"
#		 -v /var/run/docker.sock:/var/run/docker.sock" 


#doCommand=false

i3cAfter(){
	#docker exec i3cp sh -c "cd /servicebot-deploy/ && docker-compose up -d"
	#echo "=======================runing link"
	#docker exec -u 0 nodered sh -c 'ln -s /i3c/i3c.sh /i'
	echo "access nodeRed at http:[host]:1880"
}
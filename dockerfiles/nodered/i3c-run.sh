#!/bin/bash
portMap=""
volumeMap="-v $i3cDataDir/$cName/nr.data:/data"
#are we in PWD?
if [ ! "x$PWD_ENV" == "x" ]; then 
   portMap="-p 1880:1880"	
   volumeMap=""
fi

#-d -p 1880:1880 \
dParams="-d $portMap -e VIRTUAL_PORT=1880 \
	$volumeMap" 
addIParams=true

#doCommand=false

i3cAfter(){
	#docker exec i3cp sh -c "cd /servicebot-deploy/ && docker-compose up -d"
	#echo "=======================runing link"
	docker exec -u 0 $cName sh -c 'ln -s /i3c/i3c/i3c.sh /i'
	docker exec -u 0 $cName sh -c 'chmod a+rw /var/run/docker.sock'
	
	docker cp $i3cHome/dockerfiles/nodered/scripts/zipfolder.sh $cName:/zipfolder
	docker exec -u 0 $cName sh -c 'chmod a+x /zipfolder'
	if [ ${i3cConfig[keepRunning]} -eq 1 ]; then
		echo '#generated from i3c/nodered\n /i crun '$cName > /i3c/data/i3c/periodic/15min/checkNodeRedIsRunning
	fi	
	echo "access nodeRed at http:[host]:1880"
}

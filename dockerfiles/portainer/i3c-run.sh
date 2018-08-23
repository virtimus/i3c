#!/bin/bash
#--restart always

cName=portainer #//block other instances
portMap=""
if [ ! "x$PWD_ENV" == "x" ]; then 
   portMap="-p 9000:9000"	
fi
addIParams=true
dParams="-d \
	$portMap \
	-e VIRTUAL_PORT=9000 \
	-v /tmp/portainer:/data"

rCommand="--no-analytics"	

#docker run -d --name $cName \
#		-p 9000:9000 \
#		-e I3C_LOCAL_ENDPOINT=$I3C_LOCAL_ENDPOINT \
#		-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
#		-e VIRTUAL_PORT=9000 \
#		-v /var/run/docker.sock:/var/run/docker.sock \
#		-v /tmp/portainer:/data \
#		i3c/$cName --no-analytics


#doCommand=false

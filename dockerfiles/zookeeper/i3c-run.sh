#!/bin/bash
#-v /var/run/docker.sock:/var/run/docker.sock:ro \
#
cName=zookeeper
iName=zookeeper  

dParams="-d \
		-p 2181:2181 \
		-e VIRTUAL_PORT=2181"
		
#docker run -d --name $cName \
#		-p 2181:2181 \
#		--dns=$(ip i3cp) \
#		-v $i3cDataDir/$iName:/data \
#		-v $i3cHome:/i3c \
#		-v $i3cLogDir/$iName:/log \
#		-e I3C_HOST=$i3cHost \
#		-e I3C_HOME=/i3c \
#		-e I3C_DATA_DIR=/data \
#		-e I3C_LOG_DIR=/log \
#		-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
#		-e VIRTUAL_PORT=2181 \
#		i3c/$iName:$i3cVersion


		 
#addIParams=true
#doCommand=false
#!/bin/bash
#docker run -d --name vagrant \
#		-v $i3cDataDir/vagrant:/i3c/data \
#		-v $i3cHome:/i3c/i3c \
#		-v $i3cLogDir/vagrant:/i3c/log \
#		-v /var/run/docker.sock:/var/run/docker.sock \
#		-e I3C_HOME=/i3c \
#		-e I3C_DATA_DIR=/data \
#		-e I3C_LOG_DIR=/log \
#		i3c/vagrant:$i3cVersion 

dParams="-d" 
addIParams=true
		
#doCommand=false		
#!/bin/bash
#		-v /var/run/docker.sock:/var/run/docker.sock \
#		-p 8500:8500 

docker run -d --name consul \
		-v $i3cDataDir/consul:/i3c/data \
		-v $i3cHome:/i3c/i3c \
		-v $i3cLogDir/consul:/i3c/log \
		-e I3C_HOME=/i3c/i3c \
		-e I3C_DATA_DIR=/i3c/data \
		-e I3C_LOG_DIR=/i3c/log \
		-e VIRTUAL_HOST=consul.dtb.h,consul.i3c.h,consul.i3c.l \
		-e VIRTUAL_PORT=8500 \
		-e VIRTUAL_PROTO=http \
		i3c/consul:$i3cVersion 
		
doCommand=false		
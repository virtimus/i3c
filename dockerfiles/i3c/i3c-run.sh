#!/bin/bash

cName=i3c
docker run -d --name $cName \
		--dns=$(ip i3cp) \
		-v $i3cDataDir/$cName:/data \
		-v $i3cRoot:$i3cRoot \
		-v $i3cLogDir/$cName:/log \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
		-e VIRTUAL_PORT=80 \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=$i3cHome \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/$cName

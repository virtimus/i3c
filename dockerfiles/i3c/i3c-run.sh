#!/bin/bash

docker run -d --name i3c \
		--dns=$(ip i3cp) \
		-v $i3cDataDir/i3c:/data \
		-v $i3cRoot:$i3cRoot \
		-v $i3cLogDir/i3c:/log \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=$i3cHome \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/i3c
#!/bin/bash
docker run -d --name vagrant \
		-v $i3cDataDir/vagrant:/data \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/vagrant:/log \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/vagrant:$i3cVersion 
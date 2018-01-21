#!/bin/bash
#--restart always

cName=portainer

docker run -d --name $cName \
		-p 9000:9000 \
		-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
		-e VIRTUAL_PORT=9000 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/portainer:/data \
		i3c/$cName
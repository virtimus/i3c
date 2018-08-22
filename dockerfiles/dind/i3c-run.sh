#!/bin/bash
#-v /var/lib/docker:/var/lib/docker 
#--dns=$(ip i3cp) 
cName=dind  
docker run -d --name $cName \
		-p 9001:9000 \
		--privileged \
		-v $i3cDataDir/$cName:/i3c/data \
		-v $i3cRoot:$i3cRoot \
		-v $i3cLogDir/$cName:/i3c/log \
		-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
		-e VIRTUAL_PORT=9000 \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=/i3c/i3c \
		-e I3C_DATA_DIR=/i3c/data \
		-e I3C_LOG_DIR=/i3c/log \
		i3c/$cName:$i3cVersion 
#-s aufs		
docker exec $cName sh -c "ln -s /i3c/i3c/i3c.sh /i"	

doCommand=false	

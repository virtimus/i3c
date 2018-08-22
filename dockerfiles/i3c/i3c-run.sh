#!/bin/bash

#		-v $i3cRoot:$i3cRoot \ security problem
cName=i3c

dParams="-d \
--dns=$(ip i3cp) \
-v $i3cDataDir/$cName/periodic:/etc/periodic"
		
addIParams=true	

i3cAfter(){
	
	/i execd i3c crond
	
}	

#docker run -d --name $cName \
#	--dns=$(ip i3cp) \
#	-v $i3cDataDir/$cName/periodic:/etc/periodic \
#	-v $i3cDataDir/$cName:/i3c/data \
#	-v $i3cLogDir/$cName:/i3c/log \
#	-v /var/run/docker.sock:/var/run/docker.sock \
#	-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
#	-e I3C_LOCAL_ENDPOINT=$I3C_LOCAL_ENDPOINT \
#	-e VIRTUAL_PORT=80 \
#	-e I3C_HOST=$i3cHost \
#	-e I3C_HOME=$i3cHome \
#	-e I3C_DATA_DIR=/i3c/data \
#	-e I3C_LOG_DIR=/i3c/log \
#	i3c/$cName

		
#doCommand=false

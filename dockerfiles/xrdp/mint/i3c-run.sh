
addIParams=true;
dParams="-d --privileged --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 \
	$addParams \
	-v $i3cDataDir:/i3c/i3c.data \
	-v $i3cLogDir:/i3c/i3c.log \
	-v $uData/home:/home \
	-v $uData/etc/ssh:/etc/ssh"
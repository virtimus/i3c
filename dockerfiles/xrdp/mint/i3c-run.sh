
addIParams=true;
dParams="-d --privileged --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 \
	$addParams \
	-v $uData/home:/home \
	-v $uData/etc/ssh:/etc/ssh"
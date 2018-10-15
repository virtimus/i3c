

dParams="-d --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 \
	-v $uData/home:/home \
	-v $uData/etc/ssh:/etc/ssh"


dParams="-d --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 \
	--secret masterKey \
	-e ROOT_PASS=masterKey \
	-v /opt:/opt \
	-v /src:/src \
	-v /ins:/ins \
	-v $uData/i3c.local:/i3c/i3c.local \
	-v $uData/root:/root \
	-v $uData/home:/home \
	-v $uData/etc/ssh:/etc/ssh"
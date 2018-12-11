
#	-v /tmp/.X11-unix:/tmp/.X11-unix \
#	--device /dev/video0 \
#	-e DISPLAY=unix$DISPLAY \
#		-v /dev:/dev \
#	-v $uData/etc/sudoers:/etc/sudoers \
#	-v $uData/etc/passwd:/etc/passwd \
# --net host
dParams="-d --hostname mintDCserver --shm-size 1g -p 3389:3389 -p 2222:22 $addParams \
	--dns=$(_ip i3cp) \
	--secret masterKey \
	--secret tmpKey \
	-e ROOT_PASS=masterKey \
	-v /opt:/opt \
	-v /src:/src \
	-v /ins:/ins \
	-v $uData/i3c.local:/i3c/i3c.local \
	-v $uData/root:/root \
	-v $uData/home:/home \
	-v $uData/etc/ssh:/etc/ssh"
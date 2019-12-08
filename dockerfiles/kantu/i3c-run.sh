
#--net host

#xhost +
#	-v $uData/Downloads:/root/Downloads \
dParams="-d $addParams \
	--secret kantu \
	--net host \
	--cap-add SYS_ADMIN \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	--device /dev/snd \
	--device /dev/dri \
	-v /dev/shm:/dev/shm \
	-v $uData/root:/root \
	-v $uData/srcKantu:/src/kantu \
	-v $uData/srcI3cExt:/src/i3cExt \
	"
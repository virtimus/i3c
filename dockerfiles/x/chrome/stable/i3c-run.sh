

#--cpuset-cpus 0 --memory 512mb
#--security-opt seccomp=$HOME/chrome.json \
dParams="-d --net host  \
	--cap-add SYS_ADMIN \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	-v $HOME/Downloads:/home/chrome/Downloads \
	-v $HOME/.config/google-chrome/:/data \
	--device /dev/snd \
	--device /dev/dri \
	-v /dev/shm:/dev/shm \
	";
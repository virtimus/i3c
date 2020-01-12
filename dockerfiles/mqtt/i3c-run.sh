
dParams="-d -p 1883:1883 -p 8883:8883 -p 9001:9001 \
	-v $uData/config:/mosquitto/config \
	-v $uData/data:/mosquitto/data \
	-v $uLog:/mosquitto/log"
	
#	
	
i3cAfter(){
	sudo ln -sf $uLog $uData/log
	
}
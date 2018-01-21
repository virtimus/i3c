#!/bin/bash
#-v /var/run/docker.sock:/var/run/docker.sock:ro \
#
cName=i3cp
iName=i3cp  
docker run -d --name $cName \
		-p 80:80 \
		-p 443:443 \
		--cap-add=NET_ADMIN \
		-v $i3cDataDir/$iName:/data \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/$iName:/log \
		-v /var/run/docker.sock:/tmp/docker.sock:ro \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/$iName:$i3cVersion 

#i3cpIp=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' i3cp);
i3cpIp=$(ip i3cp); 
echo 'i3cpIp:'$i3cpIp
#export I3C_IP="$i3cpIp"
#address=/dtb.h/192.168.3.136
docker exec i3cp sh -c "echo 'address=/$i3cHost/'\$(/sbin/ip route|awk '/default/ { print \$3 }') >> /etc/dnsmasq.conf"
docker exec i3cp sh -c "echo 'address=/i3cp.$i3cHost/$i3cpIp' >> /etc/dnsmasq.conf"
docker exec i3cp sh -c "dnsmasq"
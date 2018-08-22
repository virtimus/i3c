#!/bin/bash
#-v /var/run/docker.sock:/var/run/docker.sock:ro \
#

dCommand='docker run -d'
dParams="-p 80:80 \
		-p 443:443 \
		--cap-add=NET_ADMIN \
		-v $i3cDataDir/$cName/certs:/etc/nginx/certs \
		-v /var/run/docker.sock:/tmp/docker.sock:ro" 

i3cAfter(){
	#i3cpIp=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' i3cp);
	i3cpIp=$(ip i3cp); 
	echo 'i3cpIp:'$i3cpIp
	#export I3C_IP="$i3cpIp"
	#address=/dtb.h/192.168.3.136
	docker exec i3cp sh -c "echo 'address=/$i3cHost/'\$(/sbin/ip route|awk '/default/ { print \$3 }') >> /etc/dnsmasq.conf"
	docker exec i3cp sh -c "echo 'address=/i3cp.$i3cHost/$i3cpIp' >> /etc/dnsmasq.conf"
	docker exec i3cp sh -c "dnsmasq"
}
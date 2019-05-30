#!/bin/bash
#-v /var/run/docker.sock:/var/run/docker.sock:ro \
#
#		-v $uData/log:/var/log \

#-v $uData/vhost.d:/etc/nginx/vhost.d \
#-v $i3cScriptDir/i3cpsettings.conf:/etc/nginx/conf.d/i3cpsettings.conf\

#check if we have default cert provided!!!!!
#		-v $uData/app:/app \

#dCommand='docker run -d'
#		-v $uData/conf.d:/etc/nginx/conf.d \
dParams="-d -p 80:80 \
		-p 443:443 \
		$addParams \
		--cap-add=NET_ADMIN \
		-v $uData/vhost.d:/etc/nginx/vhost.d \
		-v $uData/conf.p:/etc/nginx/conf.p \
		-v $uData/certs:/etc/nginx/certs \
		-v $uLog:/var/log \
		-v /var/run/docker.sock:/tmp/docker.sock:ro" 

i3cAfter(){
	
	/i cp $i3cScriptDir/i3cpsettings.conf i3cp:/etc/nginx/conf.d/i3cpsettings.conf
	#if [ ! -e $uData/conf.d ]; then
	#	mkdir $uData/conf.d 
	#fi
	#/i cp $uData/conf.d/* i3cp:/etc/nginx/conf.d/
	/i execd i3cp nginx -s reload
	
	#i3cpIp=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' i3cp);
	i3cpIp=$(ip i3cp); 
	echo 'i3cpIp:'$i3cpIp
	#export I3C_IP="$i3cpIp"
	#address=/dtb.h/192.168.3.136
	docker exec i3cp sh -c "echo 'address=/$i3cHost/'\$(/sbin/ip route|awk '/default/ { print \$3 }') >> /etc/dnsmasq.conf"
	docker exec i3cp sh -c "echo 'address=/i3cp.$i3cHost/$i3cpIp' >> /etc/dnsmasq.conf"
	docker exec i3cp sh -c "echo 'address=/$i3cExHost/'\$(/sbin/ip route|awk '/default/ { print \$3 }') >> /etc/dnsmasq.conf"
	docker exec i3cp sh -c "echo 'address=/i3cp.$i3cExHost/$i3cpIp' >> /etc/dnsmasq.conf"	
	docker exec i3cp sh -c "dnsmasq"
}
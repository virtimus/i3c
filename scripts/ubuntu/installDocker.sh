#!/bin/bash

SYSID=$(. /etc/os-release; echo "$ID")
if [ $SYSID == 'linuxmint' ]; then
	SYSID='ubuntu';
fi

SYSREL=$(lsb_release -cs)
if [ $SYSREL == 'tara' ]; then
	SYSREL='bionic';
fi
	
apt-get update && \
		apt-get -y install apt-transport-https \
     	ca-certificates \
     	curl \
     	gnupg2 \
     	software-properties-common && \
		curl -fsSL https://download.docker.com/linux/$SYSID/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
		add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/$SYSID \
  	 	$SYSREL \
   		stable" && \
		apt-get update && \
		apt-get -y install docker-ce
		
		
export DOCKER_COMPOSE_VERSION=1.22.0	
	
curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose			
#!/bin/bash

#dnsmasq

if [ ! -e /var/log/nginx ]; then
	mkdir /var/log/nginx
fi	

forego start -r
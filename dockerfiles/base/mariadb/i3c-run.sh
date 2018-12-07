#!/bin/bash

#	-v $uData/data:/var/lib/mysql \
#
#	-p 3306:3306 \
dParams="-d \
	-v $uData/data:/var/lib/mysql \
	--secret masterKey \
	-e MYSQL_ROOT_PASSWORD=masterKey \
	"
	
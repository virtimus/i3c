#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

service dbus start

#install some tools for txt conversion service
if [ ! -e /i3c/.shared/mint/toTxt ]; then
	mkdir /i3c/.shared/mint/toTxt
fi
if [ ! -e /i3c/.shared/mint/toTxtOut ]; then
	mkdir /i3c/.shared/mint/toTxtOut
fi
chmod -R a+w /i3c/.shared/mint

apt-get install -y incron xpdf
echo root > /etc/incron.allow
incrontab /incrontab
service incron start



#mintlocale

if [ -e /i3c/.overrides/run-startup.sh ]; then
	. /i3c/.overrides/run-startup.sh
fi

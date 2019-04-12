#!/bin/bash

service dbus start

chmod -R a+w /i3c/.shared/mint

sudo groupadd -g 999 dockerh
sudo usermod -a -G dockerh mb

ln -sf /i3c/i3c/i3c.sh /i

if [ -e /i3c/.overrides/run-startup.sh ]; then
	. /i3c/.overrides/run-startup.sh
fi

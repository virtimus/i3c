#!/bin/bash
sleep 10


#chmod -R a+w /i3c/.shared/mint


#sudo usermod -a -G dockerh mb
sudo chgrp dockerh /i3c

ln -sf /i3c/i3c/i3c.sh /i

if [ -e /i3c/.overrides/run-startup.sh ]; then
	. /i3c/.overrides/run-startup.sh
fi

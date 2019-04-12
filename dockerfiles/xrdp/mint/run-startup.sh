#!/bin/bash
sleep 5


#chmod -R a+w /i3c/.shared/mint


#sudo usermod -a -G dockerh mb
sudo chgrp -R dockerh /i3c
sudo chmod -R g+w /i3c

ln -sf /i3c/i3c/i3c.sh /i

if [ -e /i3c/.overrides/run-startup.sh ]; then
	. /i3c/.overrides/run-startup.sh
fi

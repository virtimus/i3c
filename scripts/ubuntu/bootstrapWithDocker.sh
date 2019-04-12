#!/bin/bash

curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/scripts/ubuntu/installDocker.sh | bash
ret=$?;
if [ $ret -ne 0 ]; then  
	echo "Docker instalaction failed ?"
fi
curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.sh | bash
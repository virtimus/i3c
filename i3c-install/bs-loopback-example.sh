#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Runing: i3c-install/bs-loopback-example.sh ..."


cd /i3c

git clone https://github.com/virtimus/i3c-loopback

export I3C_UDF_HOME=/i3c/i3c-loopback

/i rebuild lb-example
/i rerun lb-example

echo "End: i3c-install/bs-loopback-example.sh ..."
echo "------------------------------------------------------------------------"
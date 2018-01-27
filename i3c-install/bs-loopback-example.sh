#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Runing: i3c-install/bs-loopback-example.sh ..."

curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.sh | bash >> /log/bootstrap.log 2>&1

cd /i3c

git clone https://github.com/virtimus/i3c-loopback

export I3C_UDF_HOME=/i3c/i3c-loopback

/i rebuild lb-example
/i rerun lb-example

echo "End: i3c-install/bs-loopback-example.sh ..."
echo "------------------------------------------------------------------------"
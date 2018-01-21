#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Start: i3c/bootstrap.sh ..."
echo "------------------------------------------------------------------------"
CONTAINER=i3c
RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

if [ "$RUNNING" == "true" ]; then
    echo "I3C_FINAL - $CONTAINER is running."
    exit 0
fi

mkdir /i3c
mkdir /i3c/log
mkdir /i3c/data

cd /i3c
git clone https://github.com/virtimus/i3c.git
cd i3c
find -name '*.sh' -exec  chmod a+x {} \;
nohup ./i3c-install/bootstrap.sh > ./../log/bootstrap.log 2>&1 &

echo "------------------------------------------------------------------------"
echo "Started: i3c/bootstrap.sh. Look at /i3c/log/bootstrap.log for results."
echo "------------------------------------------------------------------------"

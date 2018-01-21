#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Runing: i3c-install/bootstrap.sh ..."

echo "------------------------------------------------------------------------"
echo " SET ENV VARIABLES: -----------------"
set
echo " IP ROUTE: --------------------------"
/sbin/ip route
echo "-------------------------------------"
CONTAINER=i3c
RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

#if [ $? -eq 1 ]; then
#  echo "UNKNOWN - $CONTAINER does not exist."
#  exit 3
#fi
 
if [ "$RUNNING" == "true" ]; then
    echo "FINAL - $CONTAINER is already running."
    exit 0
fi

i3cHome='/i3c/i3c';	

ln -s $i3cHome/i3c.sh /i

echo "-------------------------"
echo "/i rebuild base/alpine ..."
/i rebuild base/alpine

echo "-------------------------"
echo "/i rebuild i3cp ..."
/i rebuild i3cp

echo "-------------------------"
echo "/i rerun i3cp ..."
/i rerun i3cp 

# unfotunatelly haven't found a way for automatic detecting docker host ip from env
# the ip is needed to build pwd service external url
# manually one can do this with:
# export PWD_HOST_IP=$(ip -f inet -o addr show eth1 | awk '{print $4}'|sed 's:/[^/]*$::')
#if [ ! "x$PWD_SESSION_ID" = "x" ]; then
#  exHostIp=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' i3cp);
#  exHostUrl='ip'$exHostIp'-'$PWD_SESSION_ID'-80.direct.labs.play-with-docker.com'
#  echo 'exHostURL:'$exHostUrl
#  exit 0
#fi

echo "-------------------------"
echo "/i rebuild i3c ..."
/i rebuild i3c 
#>> /log/i3c-rebuild.log

echo "-------------------------"
echo "/i rerun i3c ..."
/i rerun i3c 
#>> /log/i3c-rerun.log
#cd $(dirname $0)

echo "------------------------------------------------------------------------"
echo "End: i3c-install/bootstrap.sh ..."
echo "------------------------------------------------------------------------"

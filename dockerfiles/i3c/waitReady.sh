#!/bin/sh
seconds=30000
if [ "x$1" != "x" ]; then
   seconds=$1
fi
while [ ! -e /i && seconds > 0 ] 
do
    echo "i3c/waitReady.sh - waiting for /i to appear ..."
    sleep 1000
    seconds -= 1000
done

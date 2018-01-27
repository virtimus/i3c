#!/bin/bash
seconds=30
if [ "x$1" != "x" ]; then
   seconds=$1
fi
cursecs=0
while [ ! -e /i ] && [ "$cursecs" -lt "$seconds" ]
do
    echo "i3c/waitReady.sh - waiting $cursecs/$seconds for /i to appear ..."
    sleep 5
    cursecs=$(($cursecs + 5))
done
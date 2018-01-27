#!/bin/sh
while [ ! -e /i && seconds < $1 ] 
do
    echo "i3c/waitReady.sh - waiting for /i to appear ..."
    sleep 1000
	seconds += 1000
    #/bin/bash
done
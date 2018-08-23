#!/bin/bash

filename=$(basename -- "$1")

cd $1
if [ ! -e $2 ]; then
        mkdir $2
fi

zip -r $2/$filename.zip .


echo "|ZIPPEDTO: "$2/$filename".zip\n";
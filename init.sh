#!/bin/bash

echo "=================================================================="
echo " i3c.Cloud $i3cVersion  $I3C_CNAME:${I3C_HOME}/init.sh"
echo "=================================================================="

if [ -e /i3c/.secrets/i3c-secrets.sh ]; then
	. /i3c/.secrets/i3c-secrets.sh
fi
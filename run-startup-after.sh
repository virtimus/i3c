#!/bin/bash

echo "=================================================================="
echo " i3c.Cloud $i3cVersion  $I3C_CNAME:${I3c_HOME}/clean.sh"
echo "=================================================================="

if [ -e /i3c/.secrets/i3c-secrets-clean.sh ]; then
	. /i3c/.secrets/i3c-secrets-clean.sh
fi


dParams="-d -p 8080:8080 --name lportal --net host \
-v /i3c/lportal/lr:/etc/liferay/mount \
-v /i3c/lportal/openncp-configuration:/opt/openncp-configuration \
-e EPSOS_PROPS_PATH=/opt/openncp-configuration/"
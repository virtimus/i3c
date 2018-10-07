
if [ "x$i3cSshPass" == "x"]; then
	i3cSshPass='';
fi	

#-p 8022:8022
#-e VIRTUAL_PORT=8022 \
dParams="-d -p 2222:22  \
	-e FILTERS={\"name\":[\"^/i3c$\"]} -e AUTH_MECHANISM=cAuth \
	-e AUTH_USER=i3c -e AUTH_PASSWORD=$i3cSshPass \
	"
addIParams=true;
	
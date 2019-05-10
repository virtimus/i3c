
_cloneOrPull https://github.com/i3c-cloud/dockprom.git dockprom

cd $uData/dockprom

ADMIN_USER=admin ADMIN_PASSWORD=admin docker-compose up -d

doCommand=false;
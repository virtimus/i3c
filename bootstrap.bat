@echo off
REM tODO: dockerToolBox install

REM info if You have any mounter drives on win - should pin them to bash also
ReM ie D:// => /mnt/d/
REM ln -s /mnt/c/DiskD /mnt/d

if DOCKER_TOOLBOX_INSTALL_PATH == "" (
	echo "Set DOCKER_TOOLBOX_INSTALL_PATH env variable."
	exit 1;
)

set STEP="Runing lxrun /install /y ..."
set LUSERNAME=root
call lxrun /install /y

call "lxrun /setdefaultuser %LUSERNAME% /y"
REM -i "D:\tools\DockerToolbox\start.sh
set STEP="Runing bootstrap-wsl.sh in dockerToolbox ..."

set dtInstallPath='%VBOX_INSTALL_PATH%'
if NOT "%VBOX_MSI_INSTALL_PATH%" == "" (
	set dtInstallPath='%VBOX_MSI_INSTALL_PATH%'
)

set mypath=%cd%
set RND=%RANDOM%
D:
cd D:\tools\DockerToolbox
call "C:\Program Files\Git\bin\bash.exe" --login -i "%DOCKER_TOOLBOX_INSTALL_PATH%\start.sh" "curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap-dtb.sh?d=%RND% | bash -l -c \"WINUSERNAME='%USERNAME%' LUSERNAME='%LUSERNAME%' exec -l bash\""

Rem "/c/i3cRoot/i3c/bootstrap-wsl.sh"

echo "###################################################################################";
echo "";
echo " Preinstallation of i3c.Cloud ended.
echo "";
echo " Run Bash Ubuntu on Windows shell to continue.
echo ""; 
echo "###################################################################################";
cd %mypath%

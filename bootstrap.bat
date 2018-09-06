ReM @echo off
set STEP="Runing lxrun /install /y ..."
set LUSERNAME=root
set wslBash=C:/Windows/System32/bash.exe
set dtBash=C:/Program Files/Git/bin/bash.exe
set i3cRootDir=/mnt/c/i3cRoot
set i3cRootDirWin=C:/i3cRoot
call lxrun /install /y

call "lxrun /setdefaultuser %LUSERNAME% /y"
REM -i "D:\tools\DockerToolbox\start.sh
if DOCKER_TOOLBOX_INSTALL_PATH == "" (
	rem echo "Set DOCKER_TOOLBOX_INSTALL_PATH env variable."
	rem exit 1;

	set STEP="Installing dockerToolbox ..."
	rem call %wslBash% -c "curl -L https://download.docker.com/win/stable/DockerToolbox.exe --output %i3cRootDir%/DockerToolbox.exe"
	call "%i3cRootDirWin%/DockerToolbox.exe"
)


REM https://download.docker.com/win/stable/DockerToolbox.exe
REM tODO: dockerToolBox install

REM info if You have any mounter drives on win - should pin them to bash also
ReM ie D:// => /mnt/d/
REM ln -s /mnt/c/DiskD /mnt/d

if DOCKER_TOOLBOX_INSTALL_PATH == "" (
	echo "Set DOCKER_TOOLBOX_INSTALL_PATH env variable."
	exit 1;
)


set STEP="Runing bootstrap-wsl.sh in dockerToolbox ..."

set dtInstallPath='%VBOX_INSTALL_PATH%'
if NOT "%VBOX_MSI_INSTALL_PATH%" == "" (
	set dtInstallPath='%VBOX_MSI_INSTALL_PATH%'
)

set mypath=%cd%
set RND=%RANDOM%
D:
cd D:\tools\DockerToolbox
call "%dtBash%" --login -i "%DOCKER_TOOLBOX_INSTALL_PATH%\start.sh" "curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap-dtb.sh?d=%RND% | bash -l -c \"WINUSERNAME='%USERNAME%' LUSERNAME='%LUSERNAME%' exec -l bash\""

call "%wslBash%" -c ". /mnt/c/i3cRoot/env.sh"

Rem "/c/i3cRoot/i3c/bootstrap-wsl.sh"

echo "###################################################################################";
echo "";
echo " Preinstallation of i3c.Cloud ended.
echo "";
echo " Run Bash Ubuntu on Windows shell to continue.
echo ""; 
echo "###################################################################################";
cd %mypath%

@echo off
REM tODO: dockerToolBox install

REM info if You have any mounter drives on win - should pin them to bash also
ReM ie D:// => /mnt/d/
REM ln -s /mnt/c/DiskD /mnt/d

set STEP="Runing lxrun /install /y ..."
set LUSERNAME=root
call lxrun /install /y
echo "test3"
call "lxrun /setdefaultuser %LUSERNAME% /y"
REM -i "D:\tools\DockerToolbox\start.sh
set STEP="Runing bootstrap-wsl.sh in dockerToolbox ..."
echo "test5"
set dtInstallPath='%VBOX_INSTALL_PATH%'
if NOT "%VBOX_MSI_INSTALL_PATH%" == "" (
	set dtInstallPath='%VBOX_MSI_INSTALL_PATH%'
)

set mypath=%cd%
D:
cd D:\tools\DockerToolbox
call "C:\Program Files\Git\bin\bash.exe" --login -i "D:\tools\DockerToolbox\start.sh" "cat /c/i3cRoot/i3c/bootstrap-dtb.sh | bash -l -c \"WINUSERNAME='%USERNAME%' LUSERNAME='%LUSERNAME%' exec -l bash\""

Rem "/c/i3cRoot/i3c/bootstrap-wsl.sh"

echo "###################################################################################";
echo "";
echo " Preinstallation of i3c.Cloud ended.
echo "";
echo " Run Bash Ubuntu on Windows shell to continue.
echo ""; 
echo "###################################################################################";
cd %mypath%

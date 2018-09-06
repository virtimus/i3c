REM tODO: dockerToolBox install

REM info if You have any mounter drives on win - should pin them to bash also
ReM ie D:// => /mnt/d/
REM ln -s /mnt/c/DiskD /mnt/d

set STEP="Runing lxrun /install /y ..."
set LUSERNAME=root
lxrun /install /y
lxrun /setdefaultuser %LUSERNAME% /y
REM -i "D:\tools\DockerToolbox\start.sh
set STEP="Runing bootstrap-wsl.sh in dockerToolbox ..."

set dtInstallPath='%VBOX_INSTALL_PATH%'
if NOT "%VBOX_MSI_INSTALL_PATH%" == "" (
	set dtInstallPath='%VBOX_MSI_INSTALL_PATH%'
)

D:
cd D:\tools\DockerToolbox
call "C:\Program Files\Git\bin\bash.exe" --login -i "D:\tools\DockerToolbox\start.sh" "cat /c/i3cRoot/i3c/bootstrap-dtb.sh | bash -l -c \"WINUSERNAME='%USERNAME%' LUSERNAME='%LUSERNAME%' exec -l bash\""

Rem "/c/i3cRoot/i3c/bootstrap-wsl.sh"

C:
cd C:/i3cRoot/i3c 
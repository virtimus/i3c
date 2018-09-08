@echo off
echo ###################################################################################
echo.
echo    BOOTSTRAP.BAT - start ...
echo ###################################################################################
set STEP="Setting variables ..."

set LUSERNAME=root
set wslBash=C:/Windows/System32/bash.exe
set dtBash=C:/Program Files/Git/bin/bash.exe
set tmpDirWin=C:\tmp
set tmpDir=/mnt/c/tmp
set i3cRootDirWin=C:/i3cRoot
if NOT "%I3C_ROOT%" == "" (
   set i3cRootDirWin=%I3C_ROOT%
)

set RND=%RANDOM%

set STEP="Runing lxrun /install /y ..."
call lxrun /install /y

call "lxrun /setdefaultuser %LUSERNAME% /y"

set STEP="Making i3cRoot & tmp if not exist ..."
if NOT exist "%i3cRootDirWin%" (
	mkdir "%i3cRootDirWin%"
)
if NOT exist "%tmpDirWin%" (
	mkdir "%tmpDirWin%"
)
REM do we have docker installed?

set dpath=
for /f "tokens=*" %%a in ('where docker ^| findstr /R /C:"docker"') do @set dpath=%%a
if "%DOCKER_TOOLBOX_INSTALL_PATH%" == "" (
	if NOT "%dpath%" == "" (
		for /F %%i in ("%dpath%") do set basename=%%~dpi;		
		set DOCKER_TOOLBOX_INSTALL_PATH=%basename%
	)
)

echo DOCKER_TOOLBOX_INSTALL_PATH: %DOCKER_TOOLBOX_INSTALL_PATH%

if "%DOCKER_TOOLBOX_INSTALL_PATH%" == "" (
	echo ###################################################################################
	echo.
	echo   Installing dockerToolbox ...
	echo.
	rem exit 1;

	set STEP="Installing dockerToolbox ..."
	if exist "%tmpDir%/DockerToolbox.exe" (
		echo DockerToolbox.exe already downloaded;
	) else (
		call %wslBash% -c "curl -L https://download.docker.com/win/stable/DockerToolbox.exe --output $tmpDir$/DockerToolbox.exe";
	)
	call  "%tmpDirWin%/DockerToolbox.exe"
	call %wslBash% -c "curl -L https://raw.githubusercontent.com/virtimus/i3c/master/resetvars.vbs?d=%RND% --output $tmpDir$/resetvars.vbs";
	call %wslBash% -c "curl -L https://raw.githubusercontent.com/virtimus/i3c/master/resetvars.bat?d=%RND% --output $tmpDir$/resetvars.bat";
	call "%tmpDirWin%/resetvars.bat"
)


REM https://download.docker.com/win/stable/DockerToolbox.exe
REM tODO: dockerToolBox install

REM info if You have any mounter drives on win - should pin them to bash also
ReM ie D:// => /mnt/d/
REM ln -s /mnt/c/DiskD /mnt/d

if "%DOCKER_TOOLBOX_INSTALL_PATH%" == "" (
	echo Docker not installed
	echo Set DOCKER_TOOLBOX_INSTALL_PATH env variable.
	exit /B 1;
)


set STEP="Runing bootstrap-wsl.sh in dockerToolbox ..."

set dtInstallPath='%VBOX_INSTALL_PATH%'
if NOT "%VBOX_MSI_INSTALL_PATH%" == "" (
	set dtInstallPath='%VBOX_MSI_INSTALL_PATH%'
)

set mypath=%cd%
set mydrive=%CD:~0,2%

REM D:
REM cd D:\tools\DockerToolbox
call "%dtBash%" --login -i "%DOCKER_TOOLBOX_INSTALL_PATH%\start.sh" "curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap-dtb.sh?d=%RND% | bash -l -c \"WINUSERNAME='%USERNAME%' LUSERNAME='%LUSERNAME%' I3C_ROOT_WIN='%i3cRootDirWin%' exec -l bash\""

call "%wslBash%" -c ". /mnt/c/i3cRoot/env.sh"

Rem "/c/i3cRoot/i3c/bootstrap-wsl.sh"

echo ###################################################################################
echo.
echo   Preinstallation of i3c.Cloud ended.
echo.
echo   Run Bash Ubuntu on Windows shell to continue.
echo.   
echo ###################################################################################
%mydrive%
cd %mypath%

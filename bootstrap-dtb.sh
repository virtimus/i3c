#!/bin/bash

#set

_fixWinPath(){
	name=$1;
	value=$2;
	#cho $name': '$value
	valuer=${value//\\/\/}
	valuer=${valuer,[A-Z]}
	valuer=${valuer/:/}
	valuer='/'$valuer
	#cho $name': '$valuer
	if [ "$3" == "1" ]; then
		if [ ! -e $valuer ]; then
			echo "Problem with $name ($value:$valuer).";
			echo "Check if folder exists on Your host machine and is properly linked/mounted to bash shell.";
			exit 1;
		fi
	fi
	eval "$name='$valuer'"
	return 0;
}
dtInstallPath=$VBOX_INSTALL_PATH
if [ "x$dtInstallPath" == "x" ]; then 
	dtInstallPath=$VBOX_MSI_INSTALL_PATH;
fi
if [ "x$dtInstallPath" == "x" ]; then 
	echo "Problem with VBOX_INSTALL_PATH/VBOX_MSI_INSTALL_PATH.";
	echo "Check if DockerToolBox/VirtualBox is installed.";
	exit 1;
fi

STEP="Processing environment paths ..."
_fixWinPath 'VBOX_INSTALL_PATH' $dtInstallPath 1;
echo 'VBOX_INSTALL_PATH: '$VBOX_INSTALL_PATH;
_fixWinPath 'DOCKER_TOOLBOX_INSTALL_PATH' $DOCKER_TOOLBOX_INSTALL_PATH 1;
echo 'DOCKER_TOOLBOX_INSTALL_PATH: '$DOCKER_TOOLBOX_INSTALL_PATH;
_fixWinPath 'DOCKER_CERT_PATH' $DOCKER_CERT_PATH 1;
echo 'DOCKER_CERT_PATH: '$DOCKER_CERT_PATH;
#_fixWinPath 'DOCKER_HOST' $WINDHOST;
echo 'DOCKER_HOST: '$DOCKER_HOST;
#_fixWinPath 'DOCKER_MACHINE_NAME' $WINDMNAME;
echo 'DOCKER_MACHINE_NAME: '$DOCKER_MACHINE_NAME;
#_fixWinPath 'DOCKER_TLS_VERIFY' $WINDTVERIFY;
echo 'DOCKER_TLS_VERIFY: '$DOCKER_TLS_VERIFY; 

echo 'WINUSERNAME: '$WINUSERNAME;
echo 'LUSERNAME: '$LUSERNAME;

STEP="Merging environment paths into .bashrc ..."
rPath=/c/Users/$WINUSERNAME/AppData/Local/lxss/$LUSERNAME;
echo 'Bash profile path: '$rPath;
tPath=$rPath/.i3cbashrc
tPath2=/c/Users/$WINUSERNAME/AppData/Local/lxss/$LUSERNAME/.i3cbashrc.tmp
	
	echo "export DOCKER_HOST='$DOCKER_HOST'" > $tPath
	echo "export DOCKER_MACHINE_NAME='$DOCKER_MACHINE_NAME'" >> $tPath
	echo "export DOCKER_TLS_VERIFY=$DOCKER_TLS_VERIFY" >> $tPath
	echo "export VBOX_INSTALL_PATH='/mnt$VBOX_INSTALL_PATH'" >> $tPath
	echo "export DOCKER_CERT_PATH='/mnt$DOCKER_CERT_PATH'" >> $tPath
	echo "export DOCKER_TOOLBOX_INSTALL_PATH='/mnt$DOCKER_TOOLBOX_INSTALL_PATH'" >> $tPath
	echo "export WINUSERNAME='$WINUSERNAME'" >> $tPath
	printf "if [ ! -e /i3c ]; then\n curl -sSL https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap-wsl.sh | bash -i;\n fi\n" >> $tPath
	

tPathT=/c/Users/$WINUSERNAME/AppData/Local/lxss/$LUSERNAME/.bashrc

exs=$(grep '### BEGIN I3C AUTOCONF ###' $tPathT);
if [ "x$exs" == "x" ]; then
	echo "### BEGIN I3C AUTOCONF ###" >> $tPathT
	cat  $tPath >> $tPathT 
	echo "### END I3C AUTOCONF ###" >> $tPathT
else 
	echo "Section present."
	#nc=$(cat $tPath);
	#perl -0777 -i -pe "s/(### BEGIN I3C AUTOCONF ###\\n).*(\\n### END I3C AUTOCONF ###)/\$1$nc\$2/s" $tPathT
lead='^### BEGIN I3C AUTOCONF ###$'
tail='^### END I3C AUTOCONF ###$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r $tPath
        }; /$tail/p; d }" $tPathT > $tPath2
dtnow=(date +%Y%m%d%H%M%S);
cp 	$tPathT $tPathT.$dtnow.bak
cat $tPath2 > $tPathT
rm $tPath2
#echo $ret > $tPathT	
fi
echo "end."

#!/bin/bash

set -x
	args=("$@")
	echo "args: ${args[@]:2}"
	
i3cHost=i3c.l
i3cInHost=i3c.l
i3cExHost=i3c.h
if [ "x$I3C_LOCAL_ENDPOINT" != "x" ]; then
    i3cExHost=$I3C_LOCAL_ENDPOINT
fi
#i3cHostIp=$(/sbin/ip route|awk '/default/ { print $3 }');	
i3cRoot='/i3c'
i3cDataDir=$i3cRoot'/data'
i3cHome=$i3cRoot'/i3c'; #'/i3c'
i3cLogDir=$i3cRoot'/log'
i3cVersion=v0
i3cDfFolder=dockerfiles
i3cDfHome=$i3cHome
#i3cDfDir=$i3cHome$i3cDfFolder
if [ "x$I3C_UDF_HOME" = "x" ]; then
   I3C_UDF_HOME=$i3cDataDir'/i3c.user'
fi
i3cUdfHome=$I3C_UDF_HOME
#i3cUdfDir=$i3cDataDir'/i3cd/i3c-crypto/dockerfiles'
i3cUdiFolder=dockerimages
i3cUdiHome=$i3cDataDir'/i3cd'
i3cDfcHome=''

load(){
case "$1" in	
	*)
		docker load -i $i3cUdiHome/$i3cUdiFolder/$1.i3ci
		docker tag 	i3c-tmp-save i3c/$1
esac
}

save(){
case "$1" in	
	*)
		docker commit $1 i3c-tmp-save		
		docker save -o $i3cUdiHome/$i3cUdiFolder/$1.i3ci i3c-tmp-save 
esac
}

_procVars(){
		if [ -e $i3cDfHome/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cDfHome
			. $i3cDfHome/$i3cDfFolder/$cName/i3c-$sCommand.sh $@;
		fi
		if [ -e $i3cDfHome.local/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cDfHome'.local'
			. $i3cDfHome.local/$i3cDfFolder/$cName/i3c-$sCommand.sh $@;
		fi		
		if [ -e $i3cUdfHome/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome$i3cUdfHome
			. $i3cUdfHome/$i3cDfFolder/$cName/i3c-$sCommand.sh $@;
		fi
		if [ -e $i3cUdfHome.local/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome$i3cUdfHome'.local'
			. $i3cUdfHome.local/$i3cDfFolder/$cName/i3c-$sCommand.sh $@;
		fi
}

_imageClonePullForBuild(){
appName=$2
dfFolder=$(basename $i3cDfcHome)
if [ ! -e $i3cDataDir/$dfFolder/$cName/$iName ]; then
	cd $i3cDataDir
	mkdir $dfFolder
	cd $dfFolder
	mkdir $cName
	cd $cName
	git clone $1/$appName.git
	mv $appName $iName
else
	cd $i3cDataDir/$dfFolder/$cName/$iName
	git pull
fi
i3cDfHome=$i3cDataDir/$dfFolder
i3cDfFolder=$cName
}


build(){
case "$1" in	
	*)	
#	if [ -e $i3cUdfHome/$i3cDfFolder/$1/i3c-build.sh ]; then
#		i3cDfHome=$i3cUdfHome 
#	fi
#	if [ -e $i3cDfHome/$i3cDfFolder/$1/i3c-build.sh ]; then
#		. $i3cDfHome/$i3cDfFolder/$1/i3c-build.sh
#	else
		doCommand=true
		dCommand='docker build'
		sCommand=build
		cName=$1
		
	if [ -e $i3cUdfHome/$i3cDfFolder/$1 ]; then
		i3cDfHome=$i3cUdfHome 
	fi		
		
		_procVars $@;
		
		iName=$1
		cName=$1
		
		
		
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName
		fi
		if [ $doCommand == true ]; then
			$dCommand -t $i3cImage:$i3cVersion -t $i3cImage:latest $i3cDfHome/$i3cDfFolder/$iName/.
		fi
#	fi		
esac

}

run(){
#echo 'run:'$@;	
case "$1" in
	*)
		doCommand=true
		cName=$1
		iName=$1
		dCommand='docker run'
		sCommand=run
		
		_procVars $@;
		
		#check if need to proces base files
		if [ "$1" == "$iName" ]; then
			cName=$1;#cName here is readonly
		else
			cName=$iName
			_procVars $@
			cName=$1
			_procVars $@;
		fi
		if [ "x$i3cParams" = "x" ]; then
			i3cParams="-v $i3cDataDir/$cName:/data \
				-v $i3cHome:/i3c \
				-v $i3cLogDir/$cName:/log \
				-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
				-e I3C_LOCAL_ENDPOINT=$I3C_LOCAL_ENDPOINT \
				-e I3C_HOST=$i3cHost \
				-e I3C_HOME=/i3c \
				-e I3C_DATA_DIR=/data \
				-e I3C_LOG_DIR=/log"				
		fi
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName
		fi			
		if [ $doCommand == true ]; then		
			$dCommand --name $1 \
			$i3cParams \
			$dParams \
			$i3cImage:$i3cVersion \
			$rCommand 			
		fi
		if [ -n "$(type -t i3cAfter)" ] && [ "$(type -t i3cAfter)" = function ]; then
			i3cAfter $@;
		fi
		
esac
#docker exec  $1 sh -c "echo \$(/sbin/ip route|awk '/default/ { print \$3 }')' $i3cHost' >> /etc/hosts"
}

#echo "echo \$(/sbin/ip route|awk '/default/ { print \$3 }')' $i3cHost' >> /etc/hosts"

rm(){
case "$1" in			
	*)
		docker rm $1;
esac
}

psa(){
	docker ps -a
}

rmidangling(){
   docker rmi $(docker images -a -q --filter "dangling=true")
}

start(){
case "$1" in	
	*)
		docker start $1;
esac
}

stop(){
case "$1" in		
	*)
		docker stop $1;
esac
}

pid(){
	docker inspect --format '{{ .State.Pid }}' "$@"
}

ip(){
	docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

logs(){
	exec docker logs "$@"
}

exec(){
case "$1" in	
	*)
		docker exec -it $1 ${@:2};
esac
}

exe(){
case "$1" in	
	*)
		echo "docker exec $1 ${@:2}";
esac
}


case "$1" in
	build)
 		build $2;
        ;;	
	run)
 		run ${@:2};
        ;;	
	runb)
 		runb $2;
        ;;	
	start)
 		start $2;
        ;;
	stop)
 		stop $2;
        ;;		
	rm)
 		rm $2;
        ;;	
	psa)
 		psa $2;
        ;;	        
    rmi)
    	rmidangling $2;
    	;;    
    rebuild)
    	rm $2;
    	build $2;    
        ;;
    rerun)
		stop $2;
    	rm $2;
    	run ${@:2};    
        ;;		
	pid)
		pid $2;
		;;
	ip)
		ip $2;
		;;
	exec)
		exec ${@:2};
		;;	
	exe)
		exe ${@:2};
		;;
	save)
		save $2;
		;;
	load)
		load $2;
		;;								
	logs)
		logs $2;
		;;	
	*)
			echo "Usage: $0 build|run|runb|start|stop|rm|psa|rmi|rebuild|rerun|pid|ip|exec|exe|save|load|logs|help...";
			echo "Help with command: $0 help [commmand]";
esac
 	

#tu skrypty





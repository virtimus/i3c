#!/bin/bash

set -x
	args=("$@")
	echo "args: ${args[@]:2}"

case "$1" in
	gstorec)
		git config credential.helper store
		exit 0
		;;
	gcachec)
		
		timeoutSec="172800"; # 2 days
		if [ ! "x$2" = "x" ]; then 
			timeoutSec=$2
		fi	
		git config credential.helper cache --timeout=$timeoutSec
		exit 0
		;;	
	*)
	#noop
esac	


	
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
i3cUdiFolder=.dockerimages
#i3cUdiHome=$i3cDataDir'/i3cd'
i3cSharedFolder=.shared
	
i3cDfcHome=''
dockerBin='docker'

#asoc array for user configs (run-config.sh)
declare -A i3cConfig
if [ -e $i3cHome/i3c-config.sh ]; then
	. $i3cHome/i3c-config.sh
fi
if [ -e $i3cHome.local/i3c-config.sh ]; then
	. $i3cHome.local/i3c-config.sh
fi
if [ -e $i3cUdfHome/i3c-config.sh ]; then
	. $i3cUdfHome/i3c-config.sh
fi	
if [ -e $PWD/i3c-config.sh ]; then
	. $PWD/i3c-config.sh
fi

i3cUdiHome=$i3cRoot
if [ ! -e $i3cUdiHome/$i3cUdiFolder ]; then
	mkdir $i3cUdiHome/$i3cUdiFolder
fi

i3cSharedHome=$i3cRoot
if [ ! -e $i3cSharedHome/$i3cSharedFolder ]; then
	mkdir $i3cSharedHome/$i3cSharedFolder
fi


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
doFirstFound=0
doLastFound=0
i3cScriptDir=''	
if [ $sCommand -eq 'run' -o $sCommand -eq 'build']; then
	doLastFound=1
fi	
	
		if [ -e $i3cDfHome/$i3cDfFolder/$iName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cDfHome
			i3cScriptDir=$i3cDfHome/$i3cDfFolder/$iName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirstFound -eq 1 ]; then
				return 0
			fi	
		fi
		if [ -e $i3cDfHome.local/$i3cDfFolder/$iName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cDfHome'.local'
			i3cScriptDir=$i3cDfHome.local/$i3cDfFolder/$iName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirstFound -eq 1 ]; then
				return 0
			fi			
		fi		
		if [ -e $i3cUdfHome/$i3cDfFolder/$iName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cUdfHome
			i3cScriptDir=$i3cUdfHome/$i3cDfFolder/$iName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirstFound -eq 1 ]; then
				return 0
			fi			
		fi
		if [ -e $i3cUdfHome.local/$i3cDfFolder/$iName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cUdfHome'.local'
			i3cScriptDir=$i3cUdfHome.local/$i3cDfFolder/$iName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirstFound -eq 1 ]; then
				return 0
			fi			
		fi
		if [ $doLastFound -eq 1 ]; then
			if [ $i3cScriptDir -ne '' ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi	
		fi				
return 1		
}

_imageClonePullForBuild(){
appName=$2
dfFolder=$(basename $i3cDfcHome)
if [ ! -e $i3cDataDir/$dfFolder/$cName/$appName ]; then
	cd $i3cDataDir
	mkdir $dfFolder
	cd $dfFolder
	mkdir $cName
	cd $cName
	git clone --depth 1 $1/$appName.git
else
	cd $i3cDataDir/$dfFolder/$cName/$appName
	git pull
fi
i3cDfHome=$i3cDataDir/$dfFolder
i3cDfFolder=$cName
}

cloneUdfAndRun(){
	cd $i3cRoot
	git clone $1/$2
	i3cUdfHome=$i3cRoot/$2
	rebuild $3
	rerun $3
}

#up with composer (if file present)
up(){
case "$1" in
	*)
		doCommand=true
		dCommand='docker-compose up'
		sCommand=up
		cName=$1
		
	if [ -e $i3cDfHome.local/$i3cDfFolder/$1/docker-compose.yml ]; then
		i3cDfHome=$i3cDfHome'.local' 
	fi		
	if [ -e $i3cUdfHome/$i3cDfFolder/$1/docker-compose.yml ]; then
		i3cDfHome=$i3cUdfHome 
	fi
	if [ -e $i3cUdfHome.local/$i3cDfFolder/$1/docker-compose.yml ]; then
		i3cDfHome=$i3cUdfHome'.local' 
	fi	
		
		_procVars $@;
		
		iName=$1
		cName=$1
		
		
		
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName
		fi
		if [ "x$iPath" = "x" ]; then		
			iPath=$iName
		fi		
		if [ $doCommand == true ]; then
			$dCommand $dParams 
			#-t $i3cImage:$i3cVersion -t $i3cImage:latest $i3cDfHome/$i3cDfFolder/$iPath/.
		fi	
esac
}

#build with docker
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
		iName=$1
		
	if [ -e $i3cDfHome.local/$i3cDfFolder/$1/dockerfile ]; then
		i3cDfHome=$i3cDfHome'.local' 
	fi		
	if [ -e $i3cUdfHome/$i3cDfFolder/$1/dockerfile ]; then
		i3cDfHome=$i3cUdfHome 
	fi
	if [ -e $i3cUdfHome.local/$i3cDfFolder/$1/dockerfile ]; then
		i3cDfHome=$i3cUdfHome'.local' 
	fi	
		
		_procVars $@;
		
		iName=$1
		cName=$1
		
		
		
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName
		fi
		if [ "x$iPath" = "x" ]; then		
			iPath=$iName
		fi		
		if [ $doCommand == true ]; then
			#check dependencies	
			if [ -e $i3cDfHome/$i3cDfFolder/$iPath/dockerfile ]; then 
			fromClause="$(cat  $i3cDfHome/$i3cDfFolder/$iPath/dockerfile | sed  -e '/^FROM i3c/!d')"
				while read -r line; do
					if [ -n "$line" ]; then
						line="${line/FROM i3c\//}"
    					echo "==================================================="
    					echo " REBUILDING Base image: $line ..."
    					echo "==================================================="
    					/i rebuild $line
    				fi
				done <<< "$fromClause"
				$dCommand $dParams -t $i3cImage:$i3cVersion -t $i3cImage:latest $i3cDfHome/$i3cDfFolder/$iPath/.
			fi
		fi
#	fi		
esac

}

_checkRunning(){
docker inspect -f {{.State.Running}} $1 | grep 'true' > /dev/null
if [ $? -eq 0 ]; then
  echo "checkRunning: Process $1 is running."
  return 0;
else
  echo "checkRunning: Process $1 is not running."
  return 1;
fi
}


crun(){
	_checkRunning $1;
	if [ $? -eq 1 ]; then
		rerun $@;
	fi			
}

run(){
#echo 'run:'$@;	
case "$1" in
	*)
		doCommand=true
		cName=$1
		iName=$1
		dCommand='docker run'
		
		#configure run
		sCommand=run-config
		_procVars $@;
		
		sCommand=run
		_procVars $@;
		
		#check if need to proces base files
		if [ "$1" == "$iName" ]; then
			cName=$1;#cName here is readonly
		#else
		#	cName=$iName
		#	_procVars $@
		#	cName=$1
		#	_procVars $@;
		fi
		if [ "x$i3cParams" = "x" ]; then
			
i3cParams="-v $i3cDataDir/$cName:/i3c/data \
	-v $i3cHome:/i3c/i3c \
	-v $i3cLogDir/$cName:/i3c/log \
	-v $i3cSharedHome/$i3cSharedFolder:/i3c/.shared \
	-e VIRTUAL_HOST=$cName.$i3cInHost,$cName.$i3cExHost \
	-e I3C_LOCAL_ENDPOINT=$I3C_LOCAL_ENDPOINT \
	-e I3C_HOST=$i3cHost \
	-e I3C_HOME=/i3c/i3c \
	-e I3C_DATA_DIR=/i3c/data \
	-e PWD_ENV=$PWD_ENV \
	-e I3C_LOG_DIR=/i3c/log"
	
	# make sure shared subfolder is created
	if [ ! -e $i3cSharedHome/$i3cSharedFolder/$cName ]; then
		mkdir $i3cSharedHome/$i3cSharedFolder/$cName
	fi	   
					
		fi
		#if choosen - add /i config
		i3iParams='';
		if [ $addIParams == true ]; then
			i3iParams="	-v $i3cUdiHome/$i3cUdiFolder:$i3cUdiHome/$i3cUdiFolder \
						-v /var/run/docker.sock:/var/run/docker.sock"
		fi	
		
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName
		fi	
		if [ "x$rCommand" = "x" ]; then
			rCommand=${@:2};
		fi
		if [ $doCommand == true ]; then		
			$dCommand --name $1 \
			$i3cParams \
			$i3iParams \
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

_ps(){
	docker ps
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
	docker logs "$1"
}

exsh(){
	quoted_args="$(printf " %q" "${@:2}")"
	docker exec -it $1 sh -c "${quoted_args}";
}

exshd(){
	quoted_args="$(printf " %q" "${@:2}")"
	docker exec $1 sh -c "${quoted_args}";
}

exec(){
case "$1" in	
	*)
		//quoted_args="$(printf " %q" "${@:2}")"
		//docker exec -it $1 "${quoted_args}";
		docker exec -it $1 ${@:2};
esac
}

execd(){
case "$1" in	
	*)
		docker exec $1 ${@:2};
esac
}

exe(){
case "$1" in	
	*)
		docker exec $1 ${@:2};
esac
}

rebuild(){
    	rm $1;
    	build $1; 
}

rerun(){
	stop $1;
    	rm $1;
    	run $@;
}

#get new certificate
cert(){
	
if [ ! -e $i3cDataDir/.certs ]; then
	mkdir $i3cDataDir/.certs
fi
if [ ! -e $i3cDataDir/.certslib ]; then
	mkdir $i3cDataDir/.certslib
fi		
	
#configure run
cnName=$1;
fullDomain=$cnName.$i3cExHost
stop i3cp

docker run -it --rm --name certbot -p 80:80 -p 443:443 -v $i3cDataDir/.certs:/etc/letsencrypt -v  $i3cDataDir/.certslib:/var/lib/letsencrypt certbot/certbot certonly --register-unsafely-without-email --standalone -d $fullDomain

cp $i3cDataDir/.certs/live/$fullDomain/cert.pem $i3cDataDir/i3cp/certs/$fullDomain.crt
cp $i3cDataDir/.certs/live/$fullDomain/privkey.pem $i3cDataDir/i3cp/certs/$fullDomain.key

#restart i3cp

rerun i3cp

}

case "$1" in
	up)
		up ${@:2};
		;;
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
	ps)
 		_ps $2;
        ;;		
	psa)
 		psa $2;
        ;;	        
    rmi)
    	rmidangling $2;
    	;;	    
    rb|rebuild)
    	rebuild ${@:2};    
        ;;
    rr|rerun)
		rerun ${@:2};    
	    ;;
	rbrr)
	    rebuild ${@:2};
	    rerun ${@:2};
	    ;;	
    crun)
    	crun ${@:2};
    	;;  	
	pid)
		pid $2;
		;;
	ip)
		ip $2;
		;;
	exsh)
		exsh ${@:2};
		;;
	exshd)
		exshd ${@:2};
		;;		
	exec)
		exec ${@:2};
		;;
	execd)
		execd ${@:2};
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
	clur|cloneUdfAndRun)
		cloneUdfAndRun ${@:2};
		;;	
	cert)
		cert $2 $3;
		;;		
	*)
			echo "Basic usage: $0 up|build|run|runb|start|stop|rm|ps|psa|rmi|rebuild|rerun|pid|ip|exec|exe|save|load|logs|cloneUdfAndRun|help...";
			echo "cmdAliases:"
			echo "rb=rebuild"
			echo "rr=rerun"
			echo "rbrr=rebuild and rerun"
			echo "Help with command: $0 help [commmand]";
			echo "====================="
			echo "Some usefull shortcuts:"
			echo "gstorec - git config credential.helper store"			
esac
 	

#tu skrypty





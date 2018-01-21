#!/bin/bash

set -x
	args=("$@")
	echo "args: ${args[@]:2}"
	
i3cHost=i3c.l
i3cInHost=i3c.l
i3cExHost=i3c.h
#i3cHostIp=$(/sbin/ip route|awk '/default/ { print $3 }');	
i3cRoot='/i3c'
i3cDataDir=$i3cRoot'/data'
i3cHome=$i3cRoot'/i3c'; #'/i3c'
i3cLogDir=$i3cRoot'/log'
i3cVersion=v0
i3cDfDir=$i3cHome/dockerfiles
i3cUdfDir=$i3cDataDir'/i3cd/dockerfiles'
#i3cUdfDir=$i3cDataDir'/i3cd/i3c-crypto/dockerfiles'
i3cUdiDir=$i3cDataDir'/i3cd/dockerimages'

load(){
case "$1" in	
	*)
		docker load -i $i3cUdiDir/$1.i3ci
		docker tag 	i3c-tmp-save i3c/$1
esac
}

save(){
case "$1" in	
	*)
		docker commit $1 i3c-tmp-save		
		docker save -o $i3cUdiDir/$1.i3ci i3c-tmp-save 
esac
}

build(){
case "$1" in	
	*)
	if [ -f $i3cUdfDir/$1/i3c.json ]; then
		i3cDfDir=$i3cUdfDir 
	fi
	if [ -f $i3cDfDir/$1/i3c-build.sh ]; then
		. $i3cDfDir/$1/i3c-build.sh
	else	
		docker build -t i3c/$1:$i3cVersion -t i3c/$1:latest $i3cDfDir/$1/.
	fi		
esac

}

run(){
#echo 'run:'$@;	
case "$1" in
	i3cd)
		docker run -d --name i3cd \
		--dns=$(ip i3cp) \
		-v $i3cDataDir/i3cd:/data \
		-v $i3cRoot:$i3cRoot \
		-v $i3cLogDir/i3cd:/log \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=$i3cHome \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/i3cd 
		;;			
	*)
		if [ -f $i3cUdfDir/$1/i3c.json ]; then
			i3cDfDir=$i3cUdfDir 
		fi
		. $i3cDfDir/$1/i3c-run.sh $@;
esac
#docker exec  $1 sh -c "echo \$(/sbin/ip route|awk '/default/ { print \$3 }')' $i3cHost' >> /etc/hosts"
}

#echo "echo \$(/sbin/ip route|awk '/default/ { print \$3 }')' $i3cHost' >> /etc/hosts"

rm(){
case "$1" in
	i3cd)
		docker rm i3cd
		;;			
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
	i3cd)
		docker start i3cd
		;;		
	*)
		docker start $1;
esac
}

stop(){
case "$1" in
	i3cd)
		docker stop i3cd
		;;		
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
	i3cd)
		docker exec -it i3cd $2
		;;		
	*)
		docker exec -it $1 ${@:2};
esac
}

exe(){
case "$1" in
	i3cd)
		docker exec i3cd $2
		;;		
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





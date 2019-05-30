

addIParams=true;
i3cDataRoot='';

dParams="-d --privileged -p 8899:8888 \
		-v $uData/config:/root/.jupyter \
		-v $i3cRoot:$i3cRoot \
		$addParams \
		";
		
		
i3cAfter(){
	out=''
	while [ "x$out" == "x" ]; do
		echo "i3cNotebook starting ..."
		sleep 2
		out=$(/i logsd inb 2>&1 | grep -Pom1 'token=\K[^"]+')
	done
	echo "Open at localhost:8899, accesToken:"
	echo $out
		
}		
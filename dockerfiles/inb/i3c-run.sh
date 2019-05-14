

addIParams=true;

dParams="-d --privileged -p 8899:8888 \
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
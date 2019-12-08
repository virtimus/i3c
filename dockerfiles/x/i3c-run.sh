


echo "Runnning a dockerfile from x-lib, args: $@"

#allow local acces to xhost
xhost local:root

name=$uData/jessfraz_dockerfiles/$3

#check if we have overriden config
localScriptDir=$i3cScriptDir/$3
localScript=$localScriptDir/i3c-run.sh
if [ -e $localScript ]; then
	i3cScriptDir=$localScriptDir;
	iName=$2/$3
	echo "iName:$iName"
	cName=$(_sanitCName $iName)
	echo "cName:$cName"	
	. $localScript "$@";
else
	#original one(from makefile): script=$(sed -n '/docker run/,/^#$/p' "$name/Dockerfile" | head -n -1 | sed "s/#//" | sed "s#\\\\##" | tr '\n' ' ' | sed "s/\$@//" | sed 's/""//')
	script=$(sed -n '/docker run/,/^#$/p' "$name/Dockerfile" | head -n -1 | sed "s/#//" | sed "s#\\\\##" | sed -e 's/#.*$//' -e '/^$/d' | tr '\n' ' ' | sed "s/\$@//" | sed 's/""//')
	#echo "name:$name"
	echo "script:$script"
	eval "$script"
	doCommand=false;
fi


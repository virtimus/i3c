#!/bin/bash
#################################################################################  
#
#  					R&D platform in a single bash script ! 
#
#############################################################################################
#
#  !This software is free to use & modify as long as You will preserve this copyright notice! 
#
#  Copyright (c) 2014-2016 Mark Bisz (virtimus@gmail.com)
#
########################################################################################################
#curl -s http://cbsg.sourceforge.net/cgi-bin/live | grep -Eo '^<li>.*</li>' | sed s,\</\\?li\>,,g | shuf -n 1
RED='\033[0;31m'
LRED='\033[1;31m'
LYELLOW='\033[1;93m'
LGREEN='\033[1;92m'
NC='\033[0m' # No Color

# @description echo encapsulation
# @arg noarg
function _echo(){
	echo "$@"	
}

#@desc set -x  encapsulation
# @arg noarg
_setverbose() {
	set -x	
}

#
# echo filtered in verbose mode
#
_echov(){
if [ $i3cVerbose -ge 1 ]; then 	
	echo "$@"	
fi	
}

_echoe(){
(>&2 echo -e "${LRED}$@${NC}")
}

_echow(){
(>&2 echo -e "${LYELLOW}$@${NC}")
}

_echoi(){
(>&2 echo -e "${LGREEN}$@${NC}")
}

_mkdir(){
mkdir -p $1
if [ -e $1 ]; then
	chmod -R g+w $1
fi
return "$?"	
}

#get options
# A POSIX variable

#cho "input: '$@'"
# Initialize our own variables:
i3cOutputFile=""
i3cVerbose=0
i3cShowHelp=0
declare -A i3cOpt
i3cOpt[v]=0
i3cOpt[h]=0
i3cOpt[f]=""
i3cOptStr='';
declare -A i3cOptO
declare -A i3cOptStrs
#process options
doOpt=true;
#this has to be rewritten like those:
#https://github.com/gliderlabs/docker-alpine/blob/master/builder/scripts/mkimage-alpine.bash
#repeat until we have options with optional o required assiciated arguments
while $doOpt; do
	doOpt=false;
	OPTIND=1         # Reset in case getopts has been used previously in the shell.
	ind=0
	while getopts "h?vcof:" opt; do
		doOpt=false
	    case "$opt" in
	    c)	shift
	        ((ind++))
	        i3cOpt[c]=$1;
			shift
	        ((ind++))
	        doOpt=true;	    
	    	#. $1;
	    	;;	
	    h)  i3cShowHelp=1
	    	i3cOpt[h]=1 
	    	doOpt=false;
	        ;;
	    v)  i3cVerbose=1
	    	i3cOpt[v]=1
	        shift
	        ((ind++))
	        case $1 in
	          *[!0-2]* | "") ;;
	          *) 
	          	 i3cVerbose=$1;
	          	 i3cOpt[v]=$1; 
	          	 shift 
			     ((ind++))
			     doOpt=true;
			     ;;
	        esac          
	        ;;
	    f)  i3cOutputFile=$OPTARG
	    	i3cOpt[f]=1
	    	doOpt=false;
	        ;;
	    o)  shift
	        ((ind++))
	        i3cOptStr=$i3cOptStr' -o '$1;
	        doOpt=true;
	        echo 'argsgromo:'"$@"
	        IFS=':' read -ra ADDR <<< "$1"
	        if [ ${ADDR[1]+x} ]; then
	        	oname=${ADDR[0]}
	        	oval=${ADDR[1]}
	        else
	        	IFS='=' read -ra ADDR <<< "$1"
	        	oname=${ADDR[0]}
	        	oval=${ADDR[1]}
	        fi	
			shift 
			((ind++))        
	    	i3cOptO[${oname}]=$oval;
	    	;;          
	    *)
	    	#_echo "Unknown option:"$opt  
	    	i3cOpt[$opt]=1 
	    	doOpt=false; 
	    esac
	done
	if [ $((OPTIND-1-$ind)) -ge 0 ]; then
		shift $((OPTIND-1-$ind))
	fi
	[ "${1:-}" = "--" ] && shift
	
	#xit 0
	
	#args=("$@")
	_echov "args:" "$@"
	if [ $i3cVerbose -ge 2 ]; then
	for var in "$@"
	do
	    echo "$var"
	done
	fi
done

#cho 'i3cOptO[vFrom]'${i3cOptO[vFrom]}

if [ $i3cVerbose -ge 2 ]; then
	_setverbose
fi

if [ "x${i3cOpt[c]}" != "x" ]; then
	. "${i3cOpt[c]}";
fi

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
	gapi)
		cat /i | ./../i3c-dev-shdoc/shdoc > ./../i3c/i3c-cli-api.md
		exit 0
		;;		
	*)
	#noop
esac	

#domena glowna	
i3cHost=i3c.l

#host internal domain
i3cInHost=i3c.l

#host external domains
i3cExHost=i3c.h

#set from env if present
if [ "x$I3C_LOCAL_ENDPOINT" != "x" ]; then
    i3cExHost=$I3C_LOCAL_ENDPOINT
fi

#i3cHostIp=$(/sbin/ip route|awk '/default/ { print $3 }');	

#i3c platform root folder
i3cRoot="${I3C_ROOT}";
if [ "x${I3C_ROOT}" == "x" ]; then 
	#_echoe "FATAL ERROR: I3C_ROOT is not set. i3c.Cloud needs this to point to i3c working files ()."	
	#currently just /i3c as default & working
	i3cRoot='/i3c'
	
fi

if [ -e $i3cRoot/.env ]; then
	. $i3cRoot/.env 
fi

# some defaults ...
# platform amd64/arm64/armel/armhf/i386/mips/mips64el/mipsel/ppc64el/s390x
# dpkg-architecture --query DEB_BUILD_GNU_TYPE buildpack-deps:buster
i3cPlatform=amd64
if [ "x$I3C_PLATFORM" != "x" ]; then
	i3cPlatform=$I3C_PLATFORM
else
	hPlatform=$(uname --m)
	case "$hPlatform" in
		x86_64)
			i3cPlatform=amd64
		;;
		aarch64)
			i3cPlatform=arm64
		;;		
	esac
	export I3C_PLATFORM=$i3cPlatform
fi

#i3c platform data dir (containers have access here)
i3cDataDir=$i3cRoot'/i3c.data'

#container internal data root
i3cDataRoot='/i3c'

#i3c platform secrets dir (should be unmounted after start)
i3cSecretsDir=$i3cRoot'/.secrets'

#i3c overrides dir - for local scripts overriding defaults
i3cOverridesDir=$i3cRoot'/.overrides'

#i3c platform home dir
i3cHome="${I3C_HOME}";
if [ "x${I3C_HOME}" == "x" ]; then 
	#_echoe "FATAL ERROR: I3C_HOME is not set. i3c.Cloud needs this to point to i3c project files (https://github.com/i3c-cloud/i3c)."	
	#currently just [root]/i3c as default & working
	i3cHome=$i3cRoot'/i3c'; #'/i3c'
fi	


#log dir (normally containers should log here into subfolders)
i3cLogDir=$i3cRoot'/i3c.log'

#platform version
i3cVersion=v0

#folder name for imagedef collections
i3cDfFolder=dockerfiles

#folder name for service collections
i3cSvcFolder=services

#default home uset for priority in path search
i3cDfHome=$i3cHome
#i3cDfDir=$i3cHome$i3cDfFolder

#user imagedef home (second priority in search)
if [ "x$I3C_UDF_HOME" = "x" ]; then
   I3C_UDF_HOME=$i3cDataDir'/i3c.user'
   #I3C_UDF_HOME=$i3cHome'.local'
fi
i3cUdfHome=$I3C_UDF_HOME

declare -A i3cDFHomes
declare -A i3cDFFroms

#@description autoconfigure i3c user home dir
#  (currently only if imagedef folder exists
#
#@arg $1 - operation (create/readUHome/read/store)
#@arg $2 - folder
#@arg $3 - [optional] subfolder
_autoconf(){
#cho "_autoconf:$1:$2"	
case "$1" in
	create)
		if [ -e $2 ]; then
			if [ ! -e $2/.gitignore ]; then
				echo "/.i3c" > $2/.gitignore
				ret=$?;
				if [ ! $ret -eq 0 ]; then
					return $ret;
				fi	
			fi
			if [ ! -e $2/.i3c ]; then 
				echo "i3cVersionAD=$i3cVersion" > $2/.i3c
				ret=$?;
				if [ ! $ret -eq 0 ]; then
					return $ret;
				fi
				echo "i3cRootAD=$i3cRoot" >> $2/.i3c
				ret=$?;
				if [ ! $ret -eq 0 ]; then
					return $ret;
				fi
				#cho "i3cUdfHome=$2" > $2/.i3c
				_mkdir $2/$i3cDfFolder
				ret=$?;
				if [ ! $ret -eq 0 ]; then
					return $ret;
				fi
				if [ "x$3" != "x" ]; then
					_mkdir $2/$i3cDfFolder/$3
					ret=$?;
					if [ ! $ret -eq 0 ]; then
						return $ret;
					fi 
				fi	
				return 0;
			else
				return 99;
			fi
		else
			return 98;		
		fi
		;;
	readUHome)
		currDir=$2;
		if [ -e $currDir'/.i3c' ]; then
			#. $currDir/.i3c
			i3cUdfHome=$currDir
		fi
		;;
	read)
		currDir=$2;
		if [ -e $currDir'/.i3c' ]; then
			. $currDir/.i3c
			#i3cUdfHome=$currDir
		fi
		;;
	readOptStrs)
		#cho '${i3cOptStrs[$2]}'${i3cOptStrs[$2]}
		if [ "x${i3cOptStrs[$2]}" != "x" ]; then
			optStr="${i3cOptStrs[$2]}";
			IFS=' ' read -ra ADDR <<< "$optStr"
			for K in "${!ADDR[@]}"; do
				os=${ADDR[$K]};
				if [ "x$os" != "x" ] && [ "$os" != "-o" ];then
					IFS=':' read -ra ADDR <<< "$os"
	        		oname=${ADDR[0]}
	        		oval=${ADDR[1]}
	        		if [ "x${i3cOptO[$oname]}" == "x" ]; then
	        			i3cOptO[$oname]=$oval;
	        		fi	 
				fi	
			done	
		fi
		#cho '$i3cOptO[vFrom]'${i3cOptO[vFrom]}
		;;		
	#TODO: real update	
	store)
		echo "#stored by i3c.sh version:"$i3cVersion > $i3cHome/.i3c
		for K in "${!i3cDFHomes[@]}"; do
			#echo $K; 
			#echo 	${i3cDFHomes[$K]}
			echo "i3cDFHomes["$K"]="${i3cDFHomes[$K]} >> $i3cHome/.i3c
		done	
		for K in "${!i3cDFFroms[@]}"; do
			#echo $K; 
			#echo 	${i3cDFHomes[$K]}
			echo "i3cDFFroms["$K"]="${i3cDFFroms[$K]} >> $i3cHome/.i3c
		done
		for K in "${!i3cOptStrs[@]}"; do
			#echo $K; 
			#echo 	${i3cDFHomes[$K]}
			echo "i3cOptStrs["$K"]='${i3cOptStrs[$K]}'" >> $i3cHome/.i3c
		done					
		;;						
	*)
		echo "Unknown autoconf operation:"$1;	
esac
#scho "_autoconf:end:$1"
}


currDir=$(pwd)
_autoconf readUHome $currDir 
_autoconf read $i3cHome 

#echo "currDir:"$currDir" udfHOme:"$i3cUdfHome;


#user folder to for saving/loading images (can grow big)	
#i3cUdfDir=$i3cDataDir'/i3cd/i3c-crypto/dockerfiles'
declare -r i3cUdiFolder=.dockerimages

#this folder shared between runnig containers 
#i3cUdiHome=$i3cDataDir'/i3cd'
declare -r i3cSharedFolder=.shared
	
#final (calculated) home dir for imagedef !tobe moved to i3cConfig	
i3cDfcHome=''

#docker binary name
declare -r dockerBin='docker'

#asoc array for user configs (run-config.sh)
declare -A i3cConfig;

#processing root config scripts
_procConfig(){

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
}

_procConfig;

#homedir for saved/loaded images
i3cUdiHome=$i3cRoot
if [ ! -e $i3cUdiHome/$i3cUdiFolder ]; then
	_mkdir $i3cUdiHome/$i3cUdiFolder
fi

#homedir for .shared folder
i3cSharedHome=$i3cRoot
if [ ! -e $i3cSharedHome/$i3cSharedFolder ]; then
	_mkdir $i3cSharedHome/$i3cSharedFolder
fi

	

#@desc load an image stored in imagedef dir into local docker repo 
#@arg $1 - image to load (appName)
load(){
	cName=$1
	scName=$(_sanitCName $cName)
	    doRm=''
		if [ ! -e $i3cUdiHome/$i3cUdiFolder/$scName.i3ci ]; then 
			if [ -e $i3cUdiHome/$i3cUdiFolder/$scName.i3czi ]; then
				unzip $i3cUdiHome/$i3cUdiFolder/$scName.i3czi -d $i3cUdiHome/$i3cUdiFolder
				doRm=$i3cUdiHome/$i3cUdiFolder/$scName.i3ci
				rm $i3cUdiHome/$i3cUdiFolder/sha256.txt
			else
				echo "Saved image $cName not found."
			fi	
		fi	
	
		$dockerBin load -i $i3cUdiHome/$i3cUdiFolder/$scName.i3ci
		$dockerBin tag 	i3c-tmp-save i3c/$cName
		$dockerBin tag 	i3c-tmp-save i3c/$cName:v0
		echo "Image loaded & tagged as i3c/$cName."
		if [ "x$doRm" != "x" ]; then 
			rm $doRm
		fi			
}

#@desc save an image from local repo into imagedef dir (.i3ci)
#@arg $1 - appdef to save
save(){
	cName=$1
	scName=$(_sanitCName $cName)
	echo "Commiting $scName ..."
	$dockerBin commit $scName i3c-tmp-save	
	echo "Saving $i3cUdiHome/$i3cUdiFolder/$scName.i3ci ..."	
	$dockerBin save -o $i3cUdiHome/$i3cUdiFolder/$scName.i3ci i3c-tmp-save 
}

savei(){
	iName=$1
	siName=$(_sanitCName $iName)
	echo "Saving $i3cUdiHome/$i3cUdiFolder/$siName.i3ci ..."
	$dockerBin save -o $i3cUdiHome/$i3cUdiFolder/$siName.i3ci $iName 
}

#@desc save an image from local repo into imagedef dir as zipped (.i3czi)
#@arg $1 - appdef to save
savez(){
	cName=$1
	scName=$(_sanitCName $cName)
	save "$@"
	cd $i3cUdiHome/$i3cUdiFolder
	sha256=$(docker inspect $scName | grep '\"Image\": \"sha256:' | cut -d '"' -f4);
	echo $sha256 > sha256.txt
	echo "Creating zip file $i3cUdiHome/$i3cUdiFolder/$scName.i3czi ..."
	zip $scName.i3czi $scName.i3ci sha256.txt
	if [ $? -eq 0 ];then
		rm $i3cUdiHome/$i3cUdiFolder/$scName.i3ci
		rm $i3cUdiHome/$i3cUdiFolder/sha256.txt 
	fi 	
}

saveiz(){
	iName=$1
	siName=$(_sanitCName $iName)
	savei "$@"
	cd $i3cUdiHome/$i3cUdiFolder
	echo "Creating zip file $i3cUdiHome/$i3cUdiFolder/$siName.i3czi ..."
	zip $siName.i3czi $siName.i3ci
	if [ $? -eq 0 ];then
		rm $i3cUdiHome/$i3cUdiFolder/$siName.i3ci 
	fi 	
}



_procHomes(){
#i3cScriptDir='';
#i3cDfcHome='';	
line=$1;
sFile=$2;
			if [ "x${i3cDFHomes[$line]}" != "x" ]; then
				if [ -e ${i3cDFHomes[$line]}/$i3cDfFolder/$line/$sFile ]; then
					i3cDfcHome=${i3cDFHomes[$line]}
					i3cScriptDir=${i3cDFHomes[$line]}/$i3cDfFolder/$line
				fi
			fi
}

_procFroms(){
sFile=$1;
#scho '$cName:'$cName;
		if [ "x${i3cDFFroms[$cName]}" != "x" ]; then 
			line="${i3cDFFroms[$cName]}";
			#//ine="${line/\/i3c\//}"
			if [ "x${i3cDFHomes[$line]}" != "x" ]; then
				_procHomes $line $sFile;
			else
				echo "[procVars] ERROR: Home dir for inherited ${i3cDFFroms[$cName]} not found."
			fi	 					
		fi
	
}

_service(){
		cName=$1
		 
		if [ -e $i3cDfHome.local/$i3cSvcFolder/$cName/i3c-run.sh ]; then
			i3cDfcHome=$i3cDfHome'.local'
			i3cScriptDir=$i3cDfHome.local/$i3cSvcFolder/$cName
			. $i3cScriptDir/i3c-run.sh $@;
		else
			echo "No file:$i3cDfHome.local/$i3cSvcFolder/$cName/i3c-run.sh";
			exit 1;	
		fi
		ret=$?;
		return $ret;	 		
}

#@desc processing different i3c platform config files 
# (normally process 'i3c-[command].sh' files according to current priorities
#@arg $@ -some args for taget script
_procVars(){
local sCommand=$1;
#local cName=$2;	
local doFirsFound=0;
local doLastFound=0;
i3cScriptDir=''	
if [ "$sCommand" == 'run' ] || [ "$sCommand" == 'build' ]; then
	doLastFound=1
fi	
		_procFroms i3c-$sCommand.sh;

		if [ "x$i3cScriptDir" != "x" ]; then
					if [ $doLastFound -eq 0 ]; then
						. $i3cScriptDir/i3c-$sCommand.sh $@;
					fi
					if [ $doFirsFound -eq 1 ]; then
						return 0
					fi
		fi
		
		_procHomes $cName i3c-$sCommand.sh;

		if [ "x$i3cScriptDir" != "x" ]; then
					if [ $doLastFound -eq 0 ]; then
						. $i3cScriptDir/i3c-$sCommand.sh $@;
					fi
					if [ $doFirsFound -eq 1 ]; then
						return 0
					fi
		fi		
	
		if [ -e $i3cDfHome/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cDfHome
			i3cScriptDir=$i3cDfHome/$i3cDfFolder/$cName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirsFound -eq 1 ]; then
				return 0
			fi	
		fi
		if [ -e $i3cDfHome.local/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cDfHome'.local'
			i3cScriptDir=$i3cDfHome.local/$i3cDfFolder/$cName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirsFound -eq 1 ]; then
				return 0
			fi			
		fi		
		if [ -e $i3cUdfHome/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cUdfHome
			i3cScriptDir=$i3cUdfHome/$i3cDfFolder/$cName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirsFound -eq 1 ]; then
				return 0
			fi			
		fi
		if [ -e $i3cUdfHome.local/$i3cDfFolder/$cName/i3c-$sCommand.sh ]; then
			i3cDfcHome=$i3cUdfHome'.local'
			i3cScriptDir=$i3cUdfHome.local/$i3cDfFolder/$cName
			if [ $doLastFound -eq 0 ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
			fi
			if [ $doFirsFound -eq 1 ]; then
				return 0
			fi			
		fi
		if [ $doLastFound -eq 1 ]; then
			if [ "$i3cScriptDir" != '' ]; then
				. $i3cScriptDir/i3c-$sCommand.sh $@;
				return 0;
			fi	
		fi
						
return 1		
}

_procI3cAfter(){
	ret=0;
	if [ -n "$(type -t i3cAfter)" ] && [ "$(type -t i3cAfter)" = function ]; then
		i3cAfter "$@";
		ret=$?;
		unset -f i3cAfter;
	fi	
	if [ $ret -eq 0 ]; then
		if [ -e $i3cOverridesDir/$cName/i3c-$sCommand-after.sh ]; then
			. $i3cOverridesDir/$cName/i3c-$sCommand-after.sh "$@"
		fi
	fi
	return $ret;
}

_procI3cParams(){
lOpts='';
if [ "x${i3cOptO[timeSync]}" != "x" ]; then
	lOpts="$lOpts -v /etc/localtime:/etc/localtime:ro";
fi	
cNameSanit="$(_sanitCName $cName)"
_vHostList="$cNameSanit.$i3cInHost,$cNameSanit.$i3cExHost";	
if [ "x$addVHost" != "x" ]; then
	_vHostList="$_vHostList,$addVHost";
fi	
if [ "x$onlyVHost" != "x" ]; then
	_vHostList=$onlyVHost;
fi
secOverridesPath=" -v $i3cSecretsDir/$cName:/i3c/.secrets -v $i3cOverridesDir/$cName:/i3c/.overrides ";
if [ "$addIParams" == true ]; then
	secOverridesPath=" -v $i3cSecretsDir:$i3cSecretsDir -v $i3cOverridesDir:$i3cOverridesDir ";
fi
			
i3cParams=" $lOpts \
	-v $i3cDataDir/$cName:$i3cDataRoot/data \
	-v $i3cDataDir/$cName:/data \
	-v $i3cHome:/i3c/i3c \
	-v $i3cLogDir/$cName:$i3cDataRoot/log \
	-v $i3cLogDir/$cName:/log \
	-v $i3cSharedHome/$i3cSharedFolder:/i3c/.shared \
	$secOverridesPath \
	-e VIRTUAL_HOST=$_vHostList \
	-e I3C_ROOT=/i3c \
	-e I3C_LOCAL_ENDPOINT=$I3C_LOCAL_ENDPOINT \
	-e I3C_HOST=$i3cHost \
	-e I3C_CNAME=$cName \
	-e I3C_HOME=/i3c/i3c \
	-e I3C_DATA_DIR=/data \
	-e PWD_ENV=$PWD_ENV \
	-e I3C_LOG_DIR=/log"
	
#setup default secrets 
if [ -e $i3cScriptDir/i3c-secrets.sh ] && [ ! -e $i3cSecretsDir/$cName/i3c-secrets.sh ]; then	
	if [ ! -e $i3cSecretsDir/$cName ]; then
		_mkdir $i3cSecretsDir/$cName
	fi	
	sudo cp $i3cScriptDir/i3c-secrets.sh $i3cSecretsDir/$cName/i3c-secrets.sh
fi
if [ -e $i3cScriptDir/i3c-secrets-clean.sh ] && [ ! -e $i3cSecretsDir/$cName/i3c-secrets-clean.sh ]; then
	if [ ! -e $i3cSecretsDir/$cName ]; then
		_mkdir $i3cSecretsDir/$cName
	fi	
	sudo cp $i3cScriptDir/i3c-secrets-clean.sh $i3cSecretsDir/$cName/i3c-secrets-clean.sh	
fi	
	

			
}

#@desc given an git repo and folder take docker imagedef for later build and pull to local repo
# !todo - option -b for automatic build and use from /i level (requires extractind _buildint from build)

#@arg $1 repo url (ie https://github.com/swagger-api)
#@arg $2 folder name inside the repo

#@example 1
#   used ie in i3c-build.sh scripts:
#   i3c-openapi/swagger-editor
_imageClonePullForBuild(){
appName=$2
dfFolder=$(basename $i3cDfcHome)
if [ ! -e $i3cDataDir/$dfFolder/$cName/$appName ]; then
	cd $i3cDataDir
	_mkdir $dfFolder
	cd $dfFolder
	_mkdir $cName
	cd $cName
	git clone --depth 1 $1/$appName.git
else
	echo "folder $i3cDataDir/$dfFolder/$cName/$appName exists - pulling ..."
	cd $i3cDataDir/$dfFolder/$cName/$appName
	git pull
fi
i3cDfHome=$i3cDataDir/$dfFolder
i3cDfFolder=$cName
}

#not tested
_status(){
dret=$($dockerBin ps --filter "name=^/$1$" --format '{{.Names}}');
#echo "dretRunning:$dret"
[[ ! $dret ]] || { echo "running" && return; }
dret="$($dockerBin ps -a --filter "name=^/$1$" --format '{{.Names}}')";
#echo "dretExists:$dret"
[[ ! $dret ]] || { echo "exists" && return; }
echo "notFound"	
}

_running(){
[ ! "$(_status $1)" == "running" ] || echo "is running"
}

#@desc given a git repo and folder name clone (or pull) sources 

#@arg $1 repo url (ie https://github.com/swagger-api)
#@arg $2 target folder name (in $uData dir)
_cloneOrPull(){

appName=$cName;
folder=$i3cDataDir/$appName/$2
cdr=$(pwd)    
    if [ ! -e $i3cDataDir/$appName/$2 ]; then
    	if [ ! -e $i3cDataDir/$appName ]; then
    		_mkdir $i3cDataDir/$appName
    	fi
    	cd $i3cDataDir/$appName
    	git clone $1 $2
	else
		cd 	$i3cDataDir/$appName/$2
		git pull	
	fi
cd $cdr	
}

_db(){ 
	docker build "$@"
}

_cloneAndBuild(){
	cloneUDfAndBuild "$@"
	return "$?";
}

#@desc clone given 3d party repo
#@deprecated (_cloneAndBuild)
#@arg $1 repo path
#@arg $2 dockerfile folder inside this repo (the path will be available in container under /i3c/data)
#@arg $3 image/container name/appName to build
#@arg $4 optional arg for image name if different than appName 


#@alias cldb
cloneUDfAndBuild(){
	doCommand=true
	dCommand=$dockerBin' build'
	sCommand=cldb
	imP=$3
	IFS='/' read -r -a arrIN <<< "$3"
	appName=${arrIN[0]};
	cName=$appName
	iName=$3

folderWithDockerF=$i3cDataDir/$appName/$2
    
    if [ ! -e $i3cDataDir/$appName/$2 ]; then
    	if [ ! -e $i3cDataDir/$appName ]; then
    		_mkdir $i3cDataDir/$appName
    	fi
    	cd $i3cDataDir/$appName
    	git clone $1
	else
		cd 	$folderWithDockerF
		git pull	
	fi

	
	i3cDfHome=$i3cDataDir	
	i3cDfFolder=$appName
	iPath=$2
	
	echo "Storing i3cDFHomes[$iName]=$i3cDfHome ...."
	i3cDFHomes[$iName]=${i3cDFHomes[$cName]}
	i3cOptStrs[$iName]=$i3cOptStr' -o fromDir:'$i3cDfHome'/'$i3cDfFolder'/'$iPath
	_autoconf store	
	
	_build $iName

		
}

#@desc clone a workspace from git, build and run given git repo, imagedef/app name and also name of container to run
#@alias clur

#@arg $1 repo path (ie https://github.com/virtimus 
#@arg $2 repo name (ie i3c-openapi)
#@arg $3 imagedef/containder name (ie swagger-editor)

#@example 1
#    /i clur https://github.com/virtimus i3c-openapi swagger-editor
cloneUdfAndRun(){
	cd $i3cRoot
	if [ -e $i3cRoot/$2 ]; then
		echo "Folder "$i3cRoot/$2." exists ... runing pull ..."
		cd $i3cRoot/$2
		git pull
	else
		git clone $1/$2	 	 
	fi	 	
	i3cUdfHome=$i3cRoot/$2
	#create local i3c autoconf
	_autoconf create $i3cUdfHome
	rebuild $3
	rerun $3
}

cloneDfAndBuild(){
	cloneUDfAndBuild "$@"
	return "$?";
}


_procDCPath(){
	if [ -e $i3cDfHome/$i3cDfFolder/$cName/docker-compose.yml ]; then
		dfHome=$i3cDfHome 
	fi		
	if [ -e $i3cDfHome.local/$i3cDfFolder/$cName/docker-compose.yml ]; then
		dfHome=$i3cDfHome'.local' 
	fi		
	if [ -e $i3cUdfHome/$i3cDfFolder/$cName/docker-compose.yml ]; then
		dfHome=$i3cUdfHome 
	fi
	if [ -e $i3cUdfHome.local/$i3cDfFolder/$cName/docker-compose.yml ]; then
		dfHome=$i3cUdfHome'.local' 
	fi	
}
#@desc run bootstrap script for current folder or from i3c.local
_bs(){
	if [ -e $PWD/bootstrap/i3c-run.sh ]; then
		_echoi "Running i3c/bootstrap script from $PWD/bootstrap/i3c-run.sh ..."
		. $PWD/bootstrap/i3c-run.sh	
	else 
		if [ -e $I3C_ROOT/i3c.local/bootstrap/i3c-run.sh ]; then
			_echoi "Running i3c/bootstrap script from $I3C_ROOT/i3c.local/bootstrap/i3c-run.sh ..."
			. $I3C_ROOT/i3c.local/bootstrap/i3c-run.sh
		fi
	fi	
}


_iup(){ 
cName=$1
if [[ "$(_running $cName)" ]]; then
	echo "$cName is running ..."
else
	_up "$@"
fi
}

#@desc up with composer (if docker-compose.yml file present)
#or try to rebuild & rerun
#@arg $1 appDef
_up(){
ret=0;	
		doCommand=true
		
		
		cName=$1
		
		dCommandBuild='docker-compose build '
		dCommandRun='docker-compose run -d --name '$cName' '
	
	#todo! integrate with build version	
	dfHome=''
	_procDCPath;	
	
	
	uData=$i3cDataDir/$cName;
	uLog=$i3cLogDir/$cName;
	iName=$1;
	
	_procConfig;				
	sCommand='config'
	_procVars $sCommand $cName "${@:2}";
	
	
		if [ -e $i3cOverridesDir/$cName/i3c-up-config.sh ]; then
			. $i3cOverridesDir/$cName/i3c-up-config.sh $sCommand $cName "${@:2}"
		fi
		if [ "$doCommand" == false ]; then
			return $?;
		fi	
	
			
	sCommand=up
	_procVars $sCommand $cName "${@:2}";
	#cho "doCommand:$doCommand"
	[ $doCommand == true ] || return;
	#echo "up run"
	#return;	
	#cName readonly here ?
	cName=$1

	if [ "x$i3cImage" = "x" ]; then		
		i3cImage=i3c/$iName
	fi
	if [ "x$iPath" = "x" ]; then		
		iPath=$iName
	fi	
		
	if [ "x$dfHome" != "x" ]; then			
		if [ $doCommand == true ]; then
			if [ "x$dfHome" != "x" ]; then
				cd $dfHome/$i3cDfFolder/$cName
			fi
				
			sCommand=build
			_procVars $sCommand $cName "${@:2}";
			#cName readonly here ?
			cName=$1
			rd1=$?;
			if [ $rd1 -ne 0 ]; then
				return $rd1;
			fi				
			
			if [ ${i3cOpt[v]} -le 1 ]; then
				echo "$dCommandBuild $i3cParams $dParams $cName"
			fi
			$dCommandBuild $i3cParams $dParams $cName
			ret=$?;
			if [ $ret -eq 0 ]; then
				
				sCommand=run
				_procVars $sCommand $cName "${@:2}";				
				
				if [ "x$i3cParams" = "x" ]; then
					_procI3cParams;
				fi				
				
				#cName readonly here ?
				cName=$1			
				if [ "x$cService" == "x" ]; then
					cService=$cName;	
				fi	
			
				if [ ${i3cOpt[v]} -le 1 ]; then
					echo "$dCommandRun $i3cParams $dParams $cService $rParams"
				fi
				$dCommandRun $i3cParams $dParams $cService $rParams				
				
			fi	
			#-t $i3cImage:$i3cVersion -t $i3cImage:latest $i3cDfHome/$i3cDfFolder/$iPath/.
		fi
	else
		#try to rebuild/rerun?
		echo "[ up]/rebuild $@"
		/i rb "$@";
		ret=$?;
			if [ $ret -eq 0 ]; then
	    		/i rr "$@";		
			fi
	fi
	return $ret;		
}

#well, for a complete clear one currently has to use his own i3c-down script
_down(){
	ret=0;	
	doCommand=true
	cName=$1
	dCommandRm='docker-compose rm -s -f -v '$cName
	
	#todo! integrate with build version	
	dfHome=''
	_procDCPath;	
	
	
	uData=$i3cDataDir/$cName;
	uLog=$i3cLogDir/$cName;
	iName=$1;	
	
	cName=$1;
	_procConfig;
	sCommand='config';
	_procVars $sCommand $cName;	
	sCommand=down
	_procVars $sCommand $cName;	
	
	if [ "x$dfHome" != "x" ]; then			
		if [ $doCommand == true ]; then
			if [ "x$dfHome" != "x" ]; then
				cd $dfHome/$i3cDfFolder/$cName
			fi
			sCommand=rm
			_procVars $sCommand $cName;						
			if [ ${i3cOpt[v]} -le 1 ]; then
				echo "$dCommandRm $dParams"
			fi
			$dCommandRm $dParams
			ret=$?;			
		fi	
	else
		e1=$(stop $1 2>&1);
		r1=$?;						
		#try to rm?		
		_rm "$@";
		ret=$?;
	fi
	
	ret=$?;
	if [ $ret -ne 0 ]; then
		return $ret;	 
	fi
	sCommand=down
	_procI3cAfter "$@"
	ret=$?;
	
	return $ret;	
	
}

#@desc build with docker
#@arg $1 - appDef
build(){
#	if [ -e $i3cUdfHome/$i3cDfFolder/$1/i3c-build.sh ]; then
#		i3cDfHome=$i3cUdfHome 
#	fi
#	if [ -e $i3cDfHome/$i3cDfFolder/$1/i3c-build.sh ]; then
#		. $i3cDfHome/$i3cDfFolder/$1/i3c-build.sh
#	else
	ret=0;
	_echov "[build()] starting with args: $@ ..."
		doCommand=true
		dCommand=$dockerBin' build'
		
		cName=$1
		iName=$1
	
	#for use in .i3c file	
	dfHome=''	
	if [ -e $i3cDfHome/$i3cDfFolder/$cName/dockerfile ] || [ -e $i3cDfHome/$i3cDfFolder/$cName/Dockerfile ] || [ -e $i3cDfHome/$i3cDfFolder/$cName/i3c-build.sh ]; then
		dfHome=$i3cDfHome 
	fi				
	if [ -e $i3cDfHome.local/$i3cDfFolder/$cName/dockerfile ] || [ -e $i3cDfHome.local/$i3cDfFolder/$cName/Dockerfile ] || [ -e $i3cDfHome.local/$i3cDfFolder/$cName/i3c-build.sh ]; then
		i3cDfHome=$i3cDfHome'.local' 
		dfHome=$i3cDfHome
	fi		
	if [ -e $i3cUdfHome/$i3cDfFolder/$cName/dockerfile ] || [ -e $i3cUdfHome/$i3cDfFolder/$cName/Dockerfile ] || [ -e $i3cUdfHome/$i3cDfFolder/$cName/i3c-build.sh ]; then
		i3cDfHome=$i3cUdfHome
		dfHome=$i3cDfHome 
	fi
	if [ -e $i3cUdfHome.local/$i3cDfFolder/$cName/dockerfile ] || [ -e $i3cUdfHome.local/$i3cDfFolder/$cName/Dockerfile ] || [ -e $i3cUdfHome.local/$i3cDfFolder/$cName/i3c-build.sh ]; then
		i3cDfHome=$i3cUdfHome'.local'
		dfHome=$i3cDfHome 
	fi
	
	if [ "x$dfHome" != "x" ]; then		
		i3cDFHomes[$cName]=$dfHome
		i3cOptStrs[$cName]=$i3cOptStr
		_autoconf store
	fi 
	
	uData=$i3cDataDir/$cName;
	uLog=$i3cLogDir/$cName;	
	
	_autoconf readOptStrs $cName;	
	
	_procConfig;
	sCommand='config';
	_procVars $sCommand $cName "${@:2}";	
	sCommand=build
	_procVars $sCommand $cName "${@:2}";
	#cho "==========================="
	if [ "x$dfHome" == "x" ]; then
		_procHomes $cName i3c-build.sh;
		if [ "x$i3cDfcHome" != "x" ]; then
			i3cDfHome=$i3cDfcHome;
			dfHome=$i3cDfHome 
		fi	
	fi
	if [ "x$dfHome" == "x" ]; then
		_procHomes $cName dockerfile;
		if [ "x$i3cDfcHome" != "x" ]; then
			i3cDfHome=$i3cDfcHome;
			dfHome=$i3cDfHome 
		fi	
	fi
	if [ "x$dfHome" == "x" ]; then
		_procHomes $cName Dockerfile;
		if [ "x$i3cDfcHome" != "x" ]; then
			i3cDfHome=$i3cDfcHome;
			dfHome=$i3cDfHome 
		fi	
	fi	
	#cho "[build ] $1 ${@:2}"	
	if [ $doCommand == true ]; then
		_build $iName "${@:2}"
		ret=$?;
	fi
	return $ret;
#	fi		
}


#@desc internal build part
#@arg $1 - appDef
_build(){
	ret=0;
	
		iName=$1
		#cName=$1
				
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName
		fi
		if [ "x$iPath" = "x" ]; then		
			iPath=$iName
		fi		
		if [ $doCommand == true ]; then
			#check dependencies	
			fromClause=""
			doCommand=false
			if [ -e $i3cDfHome/$i3cDfFolder/$iPath/dockerfile ]; then 
				fromClause="$(cat  $i3cDfHome/$i3cDfFolder/$iPath/dockerfile | sed  -e '/^FROM i3c/!d')"
				doCommand=true;
			elif [ -e $i3cDfHome/$i3cDfFolder/$iPath/Dockerfile ]; then
				fromClause="$(cat  $i3cDfHome/$i3cDfFolder/$iPath/Dockerfile | sed  -e '/^FROM i3c/!d')"
				doCommand=true;
			fi
			#cho "i3cOptStr:$i3cOptStr";
			tFolder=$i3cDfHome/$i3cDfFolder/$iPath/.
			if [ "x${i3cOptO[fromDir]}" != "x" ]; then
				#dParams=$dParams' -f '${i3cOptO[fromDir]} 
				tFolder=${i3cOptO[fromDir]}/.
				doCommand=true;
			fi				
			if [ "x$fromDir" != "x" ]; then
				tFolder=$fromDir/.
				doCommand=true;
			fi
			if [ "x${i3cOptO[fromFile]}" != "x" ]; then
				#dParams=$dParams' -f '${i3cOptO[fromDir]} 
				tFolder='-f '${i3cOptO[fromFile]}' '$tFolder
				doCommand=true;
			fi			
			
			if [[ $dParams == *"-f "* ]]; then
			#ok - custom docker file
				doCommand=true;
			fi	
			if [ $doCommand == true ]; then
				if [ "x${i3cOptO[skipFroms]}" == "x" ] && [ "x$fromClause" != "x" ]; then 
					while read -r line; do
						if [ -n "$line" ]; then
							line="${line/FROM i3c\//}"	
							if [ "${line:0:5}" != "FROM " ]; then
								i3cDFFroms[$cName]=$line;
								_autoconf store;
		    					echo "==================================================="
		    					echo " REBUILDING Base image: $line ..."
		    					echo "==================================================="
		    					/i $i3cOptStr rebuild $line
								echo " ENDED REBUILDING Base image: $line ..."
		    					echo "==================================================="
	    					fi	    					
	    				fi
					done <<< "$fromClause"
				fi
				if [ ${i3cOpt[v]} -le 1 ]; then
					echo "$dCommand $dParams -t $i3cImage:$i3cVersion -t $i3cImage:latest $tFolder"
				fi	
				$dCommand $dParams -t $i3cImage:$i3cVersion -t $i3cImage:latest $tFolder
				ret=$?;
				if [ $ret -ne 0 ]; then
					return $ret;	 
				fi	
				sCommand=build
				_procI3cAfter "$@"
				ret=$?;				
			else
				_echoe "[_build] appDef/dockerfile "$iPath" not found. If custom folder is used check if it was initialized with /i winit and has .i3c file";
				return 1;					
			fi
		fi
	return $ret;
}

#@desc scheck if running
#@arg $1 - appDef
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

#@desc scheck if running and do up if needed
#@arg $1 - appDef
_checkRunningWithUp(){
	_checkRunning $1
	ret=$?;
	if [ $ret -ne 0 ]; then
		/i up $1
	fi	
}


#@desc check if runing and run
#@arg $1 - appDef
crun(){
	_checkRunning $1;
	if [ $? -eq 1 ]; then
		rerun $@;
	fi			
}

_sanitCName(){
 	echo "$1" | sed -r 's/[\/]+/_/g'	
}

#@desc create secret
_sc(){
	name=$1;
	value=$2;
	if [[ $name == *"."* ]]; then
		_echoe "Unallowed chars in secret name";
		return 1;
	fi	
	if [ -e $i3cSecretsDir/.secrets/$name ]; then
		_echoe "Secret exists. Delete it first with /i sd name"
		return 2
	fi	
	if [ ! -e $i3cSecretsDir/.secrets ]; then
		_mkdir $i3cSecretsDir/.secrets	
	fi
	echo $value > $i3cSecretsDir/.secrets/$name;
	return 0;
}

#@desc delete secret
_sd(){
	name=$1;
	if [[ $name == *"."* ]]; then
		_echoe "Unallowed chars in secret name";
		return 1;
	fi	
	if [ ! -e $i3cSecretsDir/.secrets/$name ]; then
		_echoe "Secret not exists. Create it first with /i sc name value"
		return 2
	fi	
	rm -f $i3cSecretsDir/.secrets/$name
}	

_procDParams(){
itParams='';
#cho "procDPArams:$dParams"
		if [ "x$dParams" != "x" ]; then
			IFS=' ' read -ra ADDR <<< "$dParams"
			irSecret=false;
			for K in "${!ADDR[@]}"; do
				#cho "K:$K"
				irParams=true;
				os=${ADDR[$K]};
				#cho "os0:$os"
				os2=$(echo $os | awk '{$1=$1};1')
				#cho "os2:$os2"
				irError=false;
				if [ "x$os" != "x" ] && [ "$irSecret" == true ];then
					if [ ! -e $i3cSecretsDir/.secrets/$os ]; then
						if [ "$irSecretConditional" != true ]; then
							irError=true;
						else
							irParams=false;
						fi
					fi
					if [ "$irError" == true ]; then	
						_echoe "Secret $os not exists. Create with /i sc name value"
						return 1;
					else
						os='-v '$i3cSecretsDir/.secrets/$os:/run/secrets/$os:ro
					fi
					#irParams=false;
					irSecret=false;
					irSecretConditional=false;
				fi	
				if [ "x$os2" != "x" ] && [ "$os2" == "--secret" ];then
					irSecret=true; 
					irParams=false;
				fi
				if [ "x$os2" != "x" ] && [ "$os2" == "--isecret" ];then
					irSecret=true; 
					irParams=false;
					irSecretConditional=true;
				fi				
				if [ "x$os2" != "x" ] && [ "$os2" == "--link" ];then
					_echoe "WARNING: usage of --link option is deprecated. Use rather /i nc [cname] [netName] in i3cAfter()."; 
				fi				
				if [ "$irParams" == true ]; then
					itParams=$itParams' '$os	
				fi	
			done
			dParams=$itParams	
		fi
return 0		
}

#@desc run given container by name
#@arg $1 - appDef 
run(){
#echo 'run:'$@;	


# check home folder & cd if needed
if [ ${i3cDFHomes[$1]+_} ]; then 
	echo 'changing current dir to:'${i3cDFHomes[$1]}'...'
	cd ${i3cDFHomes[$1]}
	currDir=$(pwd)
	_autoconf readUHome $currDir	
fi	
	
	
		doCommand=true
		cName=$1
		iName=$1
		dCommand=$dockerBin' run'
		# for config convenience
		uData=$i3cDataDir/$cName;
		uLog=$i3cLogDir/$cName;
		addVHost='';
		
		_autoconf readOptStrs $cName;
		
		_procConfig;
		sCommand='config';
		_procVars $sCommand $cName "${@:2}";		
		
		#configure run
		sCommand=run-config
		_procVars $sCommand $cName "${@:2}";
		
		if [ -e $i3cOverridesDir/$cName/i3c-run-config.sh ]; then
			. $i3cOverridesDir/$cName/i3c-run-config.sh $sCommand $cName "${@:2}"
		fi
		if [ "$doCommand" == false ]; then
			return $?;
		fi
		
		sCommand=run
		_procVars $sCommand $cName "${@:2}";
		
		if [ -e $i3cOverridesDir/$cName/i3c-run.sh ]; then
			. $i3cOverridesDir/$cName/i3c-run.sh $sCommand $cName "${@:2}"
		fi
		if [ "$doCommand" == false ]; then
			return $?;
		fi		
		
		echo "[ i3c.h ]cName:$cName"
		#check if need to proces base files
		if [ "$1" == "$iName" ]; then
			#cName here is readonly
			cName=$1;
			
		fi
		
		if [ "x$i3cParams" = "x" ]; then
			_procI3cParams;
		fi
		
		oParams="";
		if [ "x${i3cOptO[restart]}" != "x" ]; then
			oParams=$oParams' --restart '${i3cOptO[restart]}
		fi		

		# make sure shared subfolder is created
		if [ ! -e $i3cSharedHome/$i3cSharedFolder/$cName ]; then
			_mkdir $i3cSharedHome/$i3cSharedFolder/$cName
		fi
		
		#if choosen - add /i config
		i3iParams='';
		if [ "$addIParams" == true ]; then
			i3iParams="	-v $i3cUdiHome/$i3cUdiFolder:$i3cUdiHome/$i3cUdiFolder \
						-v $i3cDataDir:/i3c/i3c.data \
						-v $i3cLogDir:/i3c/i3c.log \
						-v $i3cRoot/$i3cUdiFolder:$i3cRoot/$i3cUdiFolder \
						-v $i3cHome.local:$i3cHome.local \
						-v /var/run/docker.sock:/var/run/docker.sock"
		fi	
		
		if [ "x$i3cImage" = "x" ]; then		
			i3cImage=i3c/$iName:$i3cVersion
		fi	
		if [ "x$rCommand" = "x" ]; then
			rCommand="${@:2}";
		fi
		if [ "$doCommand" == true ]; then
			#processing dParams
			_procDParams
			ret=$?;
			if [ $ret -ne 0 ]; then
				return $ret;	 
			fi			
			
			
			if [ ${i3cOpt[v]} -le 1 ]; then
				echo $dCommand --name $(_sanitCName $cName) \
					 $oParams \
					 $i3cParams \
					 $i3iParams \
					 $dParams \
					 $i3cImage \
					 $rCommand \
					 $rParams
			fi	
					echo "dParams:$dParams"	
					 $dCommand --name $(_sanitCName $cName) \
					 $oParams \
					 $i3cParams \
					 $i3iParams \
					 $dParams \
					 $i3cImage \
					 $rCommand \
					 $rParams 			
		fi
	
	ret=$?;
	if [ $ret -ne 0 ]; then
		return $ret;	 
	fi			
	
	sCommand=run	
	_procI3cAfter "$@"
	ret=$?;
		
	return $ret;
#docker exec  $1 sh -c "echo \$(/sbin/ip route|awk '/default/ { print \$3 }')' $i3cHost' >> /etc/hosts"
}

#echo "echo \$(/sbin/ip route|awk '/default/ { print \$3 }')' $i3cHost' >> /etc/hosts"

#@desc remove container by name
#@arg $1 - appDef
_rm(){
	sCommand='rm';
	doCommand=true;
	cName=$1
	_procVars $sCommand $cName "${@:2}";
	if [ "$doCommand" == true ]; then
		ret=1;		
		$dockerBin rm $(_sanitCName $cName);
		ret=$?;
		return $ret;
	fi
	return 0;
}

psFormat="table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Size}}\t{{.Ports}}"


#@desc list all containers
#@na
psa(){
	ret=1;	
	$dockerBin ps -a --format "$psFormat"
	ret=$?;
	return $ret;	
}

#@desc list runing containers
#@na
_ps(){
	ret=1;	
	$dockerBin ps --format "$psFormat"
	ret=$?;
	return $ret;	
}

#@desc remove all dangling images
#@na
rmidangling(){
	ret=1;	
	$dockerBin rmi $(docker images -a -q --filter "dangling=true")
	ret=$?;
	return $ret;   
}

#@desc start stopped container
#@arg $1 - appDef
start(){
	ret=1;	
	$dockerBin start $(_sanitCName $1);
	ret=$?;
	return $ret;
}

#@desc stop runing container
#@arg $1 - appDef
stop(){
	sCommand='stop';
	doCommand=true;
	cName=$1
	_procVars $sCommand $cName "${@:2}";
	if [ "$doCommand" == true ]; then
		ret=1;			
		$dockerBin stop $(_sanitCName $cName);
		ret=$?;
		return $ret;
	fi
	return 0;			
}


#@desc pid
#@arg $1 - appDef
pid(){
	ret=1;	
	$dockerBin inspect --format '{{ .State.Pid }}' "$@"
	ret=$?;	
	return $ret;	
}

#@desc ip
#@arg $1 - appDef
_ip(){
	ret=1;	
	$dockerBin inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
	ret=$?;	
	return $ret;		
}

#@deprecated
ip(){ 
	_ip "$@"
	ret=$?;	
	return $ret;	
}

#@desc logs
#@arg $1 - appDef
logs(){
	ret=1;	
	$dockerBin logs -f "$(_sanitCName $1)"
	ret=$?;	
	return $ret;	
}

logsd(){
	ret=1;	
	$dockerBin logs "$(_sanitCName $1)"
	ret=$?;	
	return $ret;	
}

#@desc use midnight commander on container
_mc(){
	ret=1;	
	cNameSanit="$(_sanitCName $1)"
	subPath=$2
	cFsPath=/proc/$(docker inspect --format {{.State.Pid}} $cNameSanit)/root$subPath
	if [ "x${DOCKER_HOST}" == "x" ]; then
		dHost='sh://'$cNameSanit'@localhost'
	else
		dHost=$(echo $DOCKER_HOST | sed 's/tcp:\/\/\(.*\)[:]\(.*\)/sh:\/\/'$cNameSanit'@\1/')
	fi		
	#if [ "x${DOCKER_HOST}" == "x" ]; then
	#	#local one	
	#	sudo mc $PWD $cFsPath
	#else
		#remote
		exists=$(docker inspect -f {{.State.Running}} ssh)
		if  [ ! $exists ]; then
			/i rbrr ssh
		fi	

		echo "dHost:$dHost"
		mc $PWD "$dHost:2222$subPath"
	#fi		
	
	#$dockerBin logs -f "$(_sanitCName $1)"
	ret=$?;	
	return $ret;
}

#@desc stats
#@arg $1 - appDef
stats(){
	ret=1;	
	$dockerBin stats "$(_sanitCName $1)"
	ret=$?;	
	return $ret;	
}

#@desc run command on container using sh -it
#@arg $1 - appDef
#@arg ${@:2} - command(s)
exsh(){
	ret=1;	
	$dockerBin exec -it $(_sanitCName $1) sh -c "${@:2}";
	ret=$?;	
	return $ret;	
}

#@desc run command on container using sh non-interactive
#@arg $1 - appDef
#@arg ${@:2} - command(s)
exshd(){
	ret=1;	
	$dockerBin exec $(_sanitCName $1) sh -c "${@:2}";
	ret=$?;	
	return $ret;	
}

#@desc run command on container -it
#@arg $1 - appDef
#@arg ${@:2} - command(s)
exec(){
	ret=1;	
	$dockerBin exec -it $(_sanitCName $1) "${@:2}";
	ret=$?;	
	return $ret;
}

#@desc run command on container non-interactive
#@arg $1 - appDef
#@arg ${@:2} - command(s)
execd(){
	ret=1;	
	$dockerBin exec $(_sanitCName $1) "${@:2}";
	ret=$?;	
	return $ret;	
}

#@desc tag a container
#@arg $1 - appDef
#@arg ${@:2} - rest of args
tag(){
	ret=1;	
	$dockerBin tag $1 "${@:2}";
	ret=$?;	
	return $ret;	
}

#@desc list images !todo
#@na	
images(){

#result=$( sudo docker images -q nginx )

#if [[ -n "$result" ]]; then
#  echo "Container exists"
#else
#  echo "No such container"
#fi
#docker contaianers ls -f name =$1

echo ""
	
}

#@desc stop, remove and build container by name
#@arg $1 - appDef
rebuild(){
ret=0;	
	_echov "--------------------"
	_echov "rebuild starting with args: $@ ..."
	    #>/dev/null
		e1=$(stop "$@" 2>&1); #
		r1=$?;
    	e2=$(_rm "$@" 2>&1); #
    	r2=$?;
    	if [ $r1 -ge 0 ]; then
    		r1=$r1"("$e1")"
    	fi
		if [ $r2 -ge 0 ]; then
    		r2=$r2"("$e2")"
    	fi    		
    	_echov "stoping returned: $r1, remove returned: $r2 ..."
    	build "$@"; 
    	ret=$?;
    _echov "rebuild returned:$ret"	
    	return $ret;
}

#@desc stop, remove and run container by name
#@arg $1 - appDef
rerun(){
		e1=$(stop "$@" 2>&1);
		r1=$?;
    	e2=$(_rm "$@" 2>&1);
    	r2=$?;
		if [ $r1 -ge 0 ]; then
    		r1=$r1"("$e1")"
    	fi
		if [ $r2 -ge 0 ]; then
    		r2=$r2"("$e2")"
    	fi    	
    	_echov "stop=$r1, rm=$r2 ..."
    	echo "rerun/run $@"
    	run "$@";
    	return $?;
}

lrerun(){ 
	load "$1"
	rerun "$@"
}

#@desc get new letsencrypt certificate for given subdomain(ie container name)
# currently using certbot/letsgetencrypt 
# beware of using it in production - small break of availability (restart of main proxy is performed)
#@arg $1 - appDef
#@arg $2 - (optional) domainname (if other than i3cExHost) 
# - domain and appDef.domain should resolve to our host !
cert(){

echo "running cert $@ ..."
	
if [ ! -e $i3cDataDir/.certs ]; then
	_mkdir $i3cDataDir/.certs
fi
if [ ! -e $i3cDataDir/.certslib ]; then
	_mkdir $i3cDataDir/.certslib
fi		
	
#configure run
cnName=$1;
if [ "x$2" == "x" ]; then
	fullDomain=$cnName.$i3cExHost
else
	fullDomain=$cnName.$2
fi
stop i3cp

$dockerBin run -it --rm --name certbot -p 80:80 -p 443:443 -v $i3cDataDir/.certs:/etc/letsencrypt -v  $i3cDataDir/.certslib:/var/lib/letsencrypt certbot/certbot certonly --register-unsafely-without-email --standalone -d $fullDomain

cp $i3cDataDir/.certs/live/$fullDomain/cert.pem $i3cDataDir/i3cp/certs/$fullDomain.crt
cp $i3cDataDir/.certs/live/$fullDomain/privkey.pem $i3cDataDir/i3cp/certs/$fullDomain.key

#restart i3cp

rerun i3cp

}

cert-cp(){
cName=$1
fullDomain=$cName

cp $i3cDataDir/.certs/live/$fullDomain/cert.pem $i3cDataDir/i3cp/certs/$fullDomain.crt
cp $i3cDataDir/.certs/live/$fullDomain/privkey.pem $i3cDataDir/i3cp/certs/$fullDomain.key
}

cert-renew(){
stop i3cp
$dockerBin run -it --rm --name certbot -p 80:80 -p 443:443 -v $i3cDataDir/.certs:/etc/letsencrypt -v  $i3cDataDir/.certslib:/var/lib/letsencrypt certbot/certbot renew --register-unsafely-without-email --standalone
rerun i3cp
}

#@desc Initialize new user workspace in current folder, no args needed
#@arg $1 - optional dfRegistry url
#@arg $2 - user email in case create repo
#@arg $3 - user name in case create repo 
winit(){
#echo "params $1: $@"
if [ "x$1" != "x" ]; then #clone repo from git url
 	stage="git init"
 	git init
 	ret=$?;
 	if [ $ret -eq 0 ]; then 
 		stage="git remote add origin"
 		git remote add origin $1
 		ret=$?;
 	fi
 	if [ $ret -ne 0 ]; then
 		return $ret;
 	fi
 	if [ $ret -eq 0 ]; then
 		stage="git ls-remote $1"
 		git ls-remote $1
 		ret=$?;
 	fi
 	if [ $ret -eq 0 ]; then 
 		stage="git pull origin master"
 		git pull origin master
 		ret=$?;
 	else 
 		ret=0;
 		stage="git push -u origin master"
 		if [ "x$2" == "x" ]; then 
 			stage="$stage, user email not set"
 			rm -r .git
 			ret=1;
 		fi
  		if [ "x$3" == "x" ]; then 
 			stage="$stage, user name not set"
 			rm -r .git
 			ret=1;
 		fi	
 		if [ $ret -eq 0 ]; then	
 			git config user.email $2
 			git config user.name $3
	 		git add *
			git commit -m "first commit"
	 		git push -u origin master
	 		ret=$?;	
 		fi
	fi
 	if [ $ret -eq 0 ]; then 
 		stage="git branch --set-upstream-to=origin/master master"
 		git branch --set-upstream-to=origin/master master
 		ret=$?;
	fi	
	if [ $ret -eq 0 ]; then
		_echo "i3c.Cloud workspace initialized properly from $1 ..." 
	else
		_echo "Init problem("$stage"):"$ret;
		return $ret;
	fi
fi	
#local init repo
p=$(pwd)
_autoconf create $p	
ret=$?;
if [ $ret -eq 0 ]; then 
	_echo "i3c.Cloud workspace initialized properly ..."
elif [ $ret -eq 99 ]; then
	_echo "i3c.Cloud workspace already initialized."		
else
	_echo "Init problem:"$ret;
fi			
}

#@ add appdef in current workspace
#@arg $1 - appDef
wadd(){	
	if [ "x$1" == "x" ]; then
		echo "Must provide name of appDef to create"
		return 1;	
	fi
	cName=$1
	if [ "x$2" != "x" ]; then
		cName=$2
	fi
	fPath="$i3cHome.local/$i3cDfFolder/$cName";
	#echo "Checking if $fPath exists ..."
	if [ -e $fPath ]; then
		echo "appDef $cName already exists in $i3cHome.local/$i3cDfFolder/$cName."
		return 2;
	fi	
	if [ ! -e $i3cUdfHome/$i3cDfFolder/$1 ]; then 
		_mkdir $i3cUdfHome/$i3cDfFolder/$1
	fi
	ln -s $i3cUdfHome/$i3cDfFolder/$1 $fPath
	ret=$?;
	if [ $ret -eq 0 ]; then 
		_echo "appDef $1 referenced in i3c.local as $cName."
	fi
}

wrem(){	
	#cho "removing"
	if [ "x$1" == "x" ]; then
		echo "Must provide name of appdef to remove"
		return 1;	
	fi
	fPath="$i3cHome.local/$i3cDfFolder/$1";
	#echo "Checking if $fPath exists ..."
	if [ -e $fPath ]; then
		if [ ! -L $fPath ]; then
			_echoe "Cannot remove $fPath. It is not a reference (symlink)"
			return 2;
		fi
		echo "removing $fPath"
		rm $fPath 
		ret=$?;
		if [ $ret -eq 0 ]; then
			_echo "appDef $1 i3c.local reference removed." 
		else 
			_echoe "appDef $1 i3c.local reference removal error:"$ret 
		fi
		return $ret;
	else
		_echoe "appDef $1 i3c.local reference not found."
	fi	
}

#@desc cp into or from container
#@arg $@ - same as docker cp
_cp(){
	ret=1;	
	$dockerBin cp "$@";
	ret=$?;	
	return $ret;	
	}
	
#@desc list images
#@arg $@ - same as docker images	
function images(){
	$dockerBin images "$@";
}	

_nconnect(){ 
	nn=$2
	if [ "x$2" = "x" ]; then
		nn=$1;
	fi
	docker network inspect $nn &>/dev/null || docker network create --driver bridge $nn
	if [ "x$2" != "x" ]; then
		cNameSanit="$(_sanitCName $1)"
		docker network connect "${@:3}" $2 $cNameSanit
	fi 
	#&>/dev/null
}

_top(){
$dockerBin stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"

}

_fromCase=1
case "$1" in
	bs|bootstrap)
		_bs "${@:2}";
		;;
	db)
		_db "${@:2}";
		;;
	images)
		images "${@:2}";
		;;
	iup)
		_iup "${@:2}";
		;;
	up)
		_up "${@:2}";
		;;
	down)
		_down "${@:2}";
		;;
	dup)
		_down "${@:2}";
		#ret=$?;
		#if [ $ret -eq 0 ]; then		
		_up "${@:2}";
		#fi	
		;;			
	build)
 		build "${@:2}";
        ;;	
	run)
 		run "${@:2}";
        ;;	
	runb)
 		runb "$2";
        ;;	
	start)
 		start "$2";
        ;;
	stop)
 		stop "$2";
        ;;		
	rm)
 		_rm "${@:2}";
        ;;
	ps)
 		_ps "$2";
        ;;		
	psa)
 		psa "$2";
        ;;	        
    rmi)
    	rmidangling "$2";
    	;;	    
    rb|rebuild)
    	rebuild "${@:2}";    
        ;;
    rr|rerun)
		rerun "${@:2}";    
	    ;;
    lrr|lrerun)
		_lrerun "${@:2}";    
	    ;;
	rbrr)
	    /i rb "${@:2}";
	    ret=$?;
		if [ $ret -eq 0 ]; then
	    	/i rr "${@:2}";
		fi	
	    ;;	
    crun)
    	crun "${@:2}";
    	;;  	
	pid)
		pid "$2";
		;;
	ip)
		ip "$2";
		;;
	exsh)
		exsh "${@:2}";
		;;
	exshd)
		exshd "${@:2}";
		;;		
	ex|exec)
		exec "${@:2}";
		;;
	exbb)
		exec $2 /bin/bash;
		;;		
	exe|execd)
		execd "${@:2}";
		;;			
	save)
		save "$2";
		;;
	savez)
		savez "$2";
		;;	
	savei)
		savei "$2";
		;;
	saveiz)
		saveiz "$2";
		;;		
	load)
		load "$2";
		;;								
	logs)
		logs "$2";
		;;
	logsd)
		logsd "$2";
		;;		
	tag)
		tag "${@:2}";
		;;	
	clur|cloneUdfAndRun)
		cloneUdfAndRun "${@:2}";
		;;
	cldb|cloneDfAndBuild|cloneUDfAndBuild)
		cloneDfAndBuild "${@:2}";
		;;
	cert)
		cert "${@:2}";
		;;
	cert-cp)
		cert-cp "${@:2}";
		;;
	cert-renew)
		cert-renew "${@:2}";
		;;				
	cp) _cp "${@:2}";
		;;	
	wi|winit)
		winit "${@:2}";
		;;
	wa|wadd)
		wadd "${@:2}";
		;;
	wr|wrem)
		wrem "${@:2}";
		;;				
	stats)
		stats "${@:2}";
		;;	
	mc)	
		_mc "${@:2}";
		;;	
	sc)	
		_sc "${@:2}";
		;;	
	sd)	
		_sd "${@:2}";
		;;
	nc|nconnect)
		_nconnect "${@:2}";
		;;
	s|service)
		_service "${@:2}";
		;;			
	top)
		_top "${@:2}";	
		;;		
	nop)#just be silent	
		:
		;;
	echow)
		_echow "${@:2}";
		;;
	echoe)
		_echoe "${@:2}";
		;;	
	echoi)
		_echoi "${@:2}";
		;;				
	*)
			echo "Basic usage: $0 up|build|run|runb|start|stop|rm|ps|psa|rmi|rebuild|rerun|pid|ip|exec|exe|save|load|logs|cloneUdfAndRun|help...";
			echo "cmdAliases:"
			echo "rb=rebuild"
			echo "rr=rerun"
			echo "rbrr=rebuild and rerun"
			echo "clur=cloneUdfAndRun"
			echo "Help with command: $0 help [commmand]";
			echo "====================="
			echo "Some usefull shortcuts:"
			echo "gstorec - git config credential.helper store"		
			set	
esac
 	

#tu skrypty





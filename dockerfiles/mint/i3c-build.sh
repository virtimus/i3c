

#download base iso image if not present
	
if [[ "$(docker images -q mint19 2> /dev/null)" == "" ]]; then
	
	apt-get install zip unzip
	
	if [ ! -e /i3c/.dockerimages/mint19.i3czi ]; then
		cd /i3c/.dockerimages
		
		downloadUrl="https://ncl.i3c.pl"
		
		wget --no-check-certificate  $downloadUrl/s/W9sFy22J8jzFZp4/download
		ret=$?;
		if [ $ret -eq 0 ]; then
			mv download mint19.i3czi
		else
			echo "Problem downloading base mint19 image from $downloadUrl - try once again"
			exit ret;
		fi	
	fi
	
	/i load mint19	
	
fi
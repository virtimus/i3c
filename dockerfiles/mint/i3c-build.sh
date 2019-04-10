

#download base iso image if not present
	
if [[ "$(docker images -q mint19 2> /dev/null)" == "" ]]; then
	
	apt-get install zip unzip
	
	if [ ! -e /i3c/.dockerimages/mint19.i3czi ]; then
		cd /i3c/.dockerimages
		
		wget --no-check-certificate  https://ncl.i3c.pl/s/W9sFy22J8jzFZp4/download
		
		mv download mint19.i3czi
	fi
	
	/i load mint19	
	
fi
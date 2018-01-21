#!/bin/bash
#/usr/bin/supervisord
#/usr/bin/supervisorctl

#!/bin/bash
echo 'run-i3c start ...'
#i3cHome='/i3c/i3c';	

if [ ! -f $I3C_HOME/i3c.sh ]; then  
    cd $I3C_HOME/.. 
    git clone https://github.com/virtimus/i3c.git
    
    cd i3c
    chmod -R a+x **/*.sh
fi

if [ ! -e /i ]; then  
	ln -s $I3C_HOME/i3c.sh /i
fi

while ( true )
    do
    #//echo "Detach with Ctrl-p Ctrl-q. Dropping to shell"
    sleep 1000
    #/bin/bash
done

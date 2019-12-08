



export LPORTALSRC=/opt/docker/docker-openncp
export LPORTAL=/i3c/lportal/lr
cp -R /opt/openncp-configuration /i3c/lportal/
mkdir -p $LPORTAL/deploy
mkdir -p $LPORTAL/tomcat/lib
mkdir -p $LPORTAL/tomcat/conf
mkdir -p $LPORTAL/tomcat/bin
cp $LPORTALSRC/lportal/tomcat-conf/libs/*.jar $LPORTAL/tomcat/lib/
#cp $LPORTALSRC/wars/epsosportal.war $LPORTAL/deploy
cp $LPORTALSRC/lportal/tomcat-conf/conf-files/server.xml $LPORTAL/tomcat/conf/
#cp $LPORTALSRC/lportal/tomcat-conf/conf-files/context.xml $LPORTAL/tomcat/conf/  
cp /opt/apache-tomcat-server/conf/context.xml $LPORTAL/tomcat/conf/  
cp $LPORTALSRC/lportal/tomcat-conf/conf-files/*.properties $LPORTAL/  
cp $LPORTALSRC/lportal/tomcat-conf/conf-files/setenv.sh  $LPORTAL/tomcat/bin/setenv.sh
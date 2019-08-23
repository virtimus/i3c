FROM openjdk:8-jre

ENV EPSOS_PROPS_PATH /opt/openncp-configuration/


ENV LIFERAY_TOMCAT_URL=https://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.5%20GA6/liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flportal%2Ffiles%2FLiferay%2520Portal%2F6.2.5%2520GA6%2Fliferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip%2Fdownload&ts=1525708355

WORKDIR /usr/local

RUN set -x \
			&& curl -kfSL "$LIFERAY_TOMCAT_URL" -o liferay-portal.zip \
			&& unzip liferay-portal.zip -d . \
			&& rm liferay-portal.zip \
			&& mv liferay-portal* liferay-portal \
			&& mv liferay-portal/tomcat* liferay-portal/tomcat \
			&& chmod +x /usr/local/liferay-portal/tomcat/bin/*.sh
			

COPY ./lportal/tomcat-conf/libs/*.jar /usr/local/liferay-portal/tomcat/lib/			
COPY ./wars/epsosportal.war /usr/local/liferay-portal/deploy/
COPY ./lportal/tomcat-conf/conf-files/server.xml /usr/local/liferay-portal/tomcat/conf/
COPY ./lportal/tomcat-conf/conf-files/context.xml /usr/local/liferay-portal/tomcat/conf/  
COPY ./lportal/tomcat-conf/conf-files/*.properties /usr/local/liferay-portal/  
COPY ./lportal/tomcat-conf/conf-files/setenv.sh  /usr/local/liferay-portal/tomcat/bin/setenv.sh

  
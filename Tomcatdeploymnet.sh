#!/bin/bash
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#Script Name: Tomcatdeploymnet.sh
#Date: Jul 29th, 2019. 
#Modified: NA
#Versioning: NA
#Author: Krishna Bagal.
#Info: Deploy tomcat sarvlet on remote instance.
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
TOMCATNAME=$1
TOMCATDIR=$2
TOMCAT=$3
TOMCATMIMMEMORY=$4
TOMCATMAXMEMORY=$5
SHUTDOWNPORT=$6
CONNECTORPORT=$7
AJPPORT=$8
ACL=$9

if [ "$TOMCAT" == "Version7" ];
then

	if [ -d "/$TOMCATDIR/$TOMCATNAME" ];
	then
		echo "/$TOMCATDIR/$TOMCATNAME is present"
	else
		sudo /bin/netstat -atunlp |grep -i ":$CONNECTORPORT"

		if [ $? == 1 ];
		then
			/usr/bin/dpkg -l |grep -w "bc"

			if [ $? == 0 ];
			then
				echo "BC is installed"
			else 
				sudo apt install bc -y
			fi

			TOTALMEM=`/usr/bin/free -m |grep -i mem |awk {'print $2'}`
			TOMCATTOTALMEM=`sudo ps -ef|grep tomcat|grep "Xmx"|awk -F'Xmx' '{print $2}'|cut -f 1 -d ' '|sed 's/m//g'|awk '{ SUM += $1} END { print SUM }'`

			if [ -z "$TOMCATTOTALMEM" ];
			then
				TOMCATTOTALAVLMEM=0
			else	
				TOMCATTOTALAVLMEM=$TOMCATTOTALMEM
			fi

			TOTALAVLMEM=`echo $TOTALMEM - $TOMCATTOTALAVLMEM |/usr/bin/bc`

			if [ $TOMCATMAXMEMORY -lt $TOTALAVLMEM ];
			then 
				cd /$TOMCATDIR
                                tar -zxvf tomcat-deploy07.tar.gz 
                                sudo mv -v /$TOMCATDIR/tomcat-deploy07 $TOMCATNAME
                                sudo mv -v /$TOMCATDIR/initscript /etc/init.d/$TOMCATNAME
                                sudo /bin/chown -R tomcat:tomcat /etc/init.d/$TOMCATNAME
                                sudo /bin/chmod 755 /etc/init.d/$TOMCATNAME
                                sudo /usr/bin/setfacl -R -m g:$ACL:rwx /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|TOMCATMIMMEMORY|$TOMCATMIMMEMORY|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|TOMCATMAXMEMORY|$TOMCATMAXMEMORY|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|TOMCAT_CATALINA_HOME_DIR|/$TOMCATDIR/$TOMCATNAME|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|GC_TOMCAT|gc_$TOMCAT|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/chown -R tomcat:tomcat $TOMCATNAME
                                sudo /usr/bin/setfacl -R -m g:$ACL:rx /$TOMCATDIR/$TOMCATNAME
                                sudo /usr/bin/setfacl -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/webapps
                                sudo /usr/bin/setfacl -d -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/webapps
                                sudo /usr/bin/setfacl -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/work
                                sudo /usr/bin/setfacl -d -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/work
                                sudo /bin/sed -i "s|TOMCATSERVERPORT|$SHUTDOWNPORT|g" /$TOMCATDIR/$TOMCATNAME/conf/server.xml
                                sudo /bin/sed -i "s|TOMCATCONNECTORPORT|$CONNECTORPORT|g" /$TOMCATDIR/$TOMCATNAME/conf/server.xml
                                sudo /bin/sed -i "s|TOMCATAJPPORT|$AJPPORT|g" /$TOMCATDIR/$TOMCATNAME/conf/server.xml
                                COMMAND_SUDO=$(sudo cat /etc/sudoers |egrep -i "^Cmnd_Alias" |egrep -i "TOMCAT.*tomcat")
                                if [ $? -eq 0 ];
                                then
                                        sudo /bin/sed -i "s|TOMCAT =|TOMCAT = /etc/init.d/$TOMCATNAME,|g" /etc/sudoers
                                else
					echo "Tomcat entry is missing in sudores file"
                                fi
			else
				echo "Free memory is not avaliable for tomcat deployment..!!!!"
			fi
		else	
			echo "Port $CONNECTORPORT is already in used.!!!!"
		fi
	fi
fi

####################################################################################################################################################################################################
if [ "$TOMCAT" == "Version8" ];
then

	if [ -d "/$TOMCATDIR/$TOMCATNAME" ];
	then
		echo "/$TOMCATDIR/$TOMCATNAME is present"
	else
		sudo /bin/netstat -atunlp |grep -i ":$CONNECTORPORT"

		if [ $? == 1 ];
		then
			/usr/bin/dpkg -l |grep -w "bc"

			if [ $? == 0 ];
			then
				echo "BC is installed"
			else 
				sudo apt install bc -y
			fi

			TOTALMEM=`/usr/bin/free -m |grep -i mem |awk {'print $2'}`
			TOMCATTOTALMEM=`sudo ps -ef|grep tomcat|grep "Xmx"|awk -F'Xmx' '{print $2}'|cut -f 1 -d ' '|sed 's/m//g'|awk '{ SUM += $1} END { print SUM }'`

			if [ -z "$TOMCATTOTALMEM" ];
			then
				TOMCATTOTALAVLMEM=0
			else	
				TOMCATTOTALAVLMEM=$TOMCATTOTALMEM
			fi

			TOTALAVLMEM=`echo $TOTALMEM - $TOMCATTOTALAVLMEM |/usr/bin/bc`

			if [ $TOMCATMAXMEMORY -lt $TOTALAVLMEM ];
			then 
				cd /$TOMCATDIR
                                tar -zxvf tomcat-deploy08.tar.gz 
                                sudo mv -v /$TOMCATDIR/tomcat-deploy08 $TOMCATNAME
                                sudo mv -v /$TOMCATDIR/initscript /etc/init.d/$TOMCATNAME
                                sudo /bin/chown -R tomcat:tomcat /etc/init.d/$TOMCATNAME
                                sudo /bin/chmod 755 /etc/init.d/$TOMCATNAME
                                sudo /usr/bin/setfacl -R -m g:$ACL:rwx /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|TOMCATMIMMEMORY|$TOMCATMIMMEMORY|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|TOMCATMAXMEMORY|$TOMCATMAXMEMORY|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|TOMCAT_CATALINA_HOME_DIR|/$TOMCATDIR/$TOMCATNAME|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/sed -i "s|GC_TOMCAT|gc_$TOMCAT|g" /etc/init.d/$TOMCATNAME
                                sudo /bin/chown -R tomcat:tomcat $TOMCATNAME
                                sudo /usr/bin/setfacl -R -m g:$ACL:rx /$TOMCATDIR/$TOMCATNAME
                                sudo /usr/bin/setfacl -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/webapps
                                sudo /usr/bin/setfacl -d -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/webapps
                                sudo /usr/bin/setfacl -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/work
                                sudo /usr/bin/setfacl -d -R -m g:$ACL:rwx /$TOMCATDIR/$TOMCATNAME/work
                                sudo /bin/sed -i "s|TOMCATSERVERPORT|$SHUTDOWNPORT|g" /$TOMCATDIR/$TOMCATNAME/conf/server.xml
                                sudo /bin/sed -i "s|TOMCATCONNECTORPORT|$CONNECTORPORT|g" /$TOMCATDIR/$TOMCATNAME/conf/server.xml
                                sudo /bin/sed -i "s|TOMCATAJPPORT|$AJPPORT|g" /$TOMCATDIR/$TOMCATNAME/conf/server.xml

				COMMAND_SUDO=$(sudo cat /etc/sudoers |egrep -i "^Cmnd_Alias" |egrep -i "TOMCAT.*tomcat")
				if [ $? -eq 0 ];
				then
					sudo /bin/sed -i "s|TOMCAT =|TOMCAT = /etc/init.d/$TOMCATNAME,|g" /etc/sudoers 
				else
					echo "Tomcat entry is missing in sudores file"
				fi
			else
				echo "Free memory is not avaliable for tomcat deployment..!!!!"
			fi
		else	
			echo "Port $CONNECTORPORT is already in used.!!!!"
		fi
	fi
fi

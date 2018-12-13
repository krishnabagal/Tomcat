#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Script Name: greplogs.sh
# Date: Dec 18th, 2017. 
# Modified: NA
# Versioning: NA
# Owner: Krishna Bagal.
# Info: Check string in logs and send an alert to email address. 
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
HOSTNAME=`hostname -f`
HOSTIP=`ip route get 1 | awk '{print $NF;exit}'`
MAILFILELOCATION="/tmp/tomcat.log"
CURRENTHOUR=$(date +%a" "%b" "%d" "%H:%M)
LASTFIVEMIN=$(date +%a" "%b" "%d" "%H:%M -d "5 min ago")
FILENAME="catalina.out"
DIRPATH="<TOMCAT-DIRECTORY>"
FILEPATH="$DIRPATH/logs/$FILENAME"
EXCEPTIONSTRING="java.lang.OutOfMemoryError"
TO="root@krishnabagal.com"
SED="/bin/sed"

# Clean old mail logs.
cat /dev/null > $MAILFILELOCATION

# Filter last/old 5 min logs from file.
$SED -n "/$LASTFIVEMIN/ , /$CURRENTHOUR/p" $FILEPATH > $MAILFILELOCATION
 
cat $MAILFILELOCATION |egrep -i "$EXCEPTIONSTRING"
 
if [ $? -eq 0 ];
then
        mail -s "CRITICAL: $HOSTNAME: $EXCEPTIONSTRING String found in logs" $TO < $MAILFILELOCATION
        exit 2
else
        echo "OK: $EXCEPTIONSTRING String not found in log."
        exit 0
fi

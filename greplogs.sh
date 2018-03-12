#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#Script Name: greplogs.sh
#Date: Dec 18th, 2017. 
#Modified: NA
#Versioning: NA
#Owner: Krishna Bagal.
#Info: Check string in logs and send an alert to email address. 
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
hostname=`hostname`
logFileLocation=`<Tomcat Directory Location>`
mailFileLoc="/tmp/tomcat.log"
curhour=$(date +%a" "%b" "%d" "%H:%M)
last5min=$(date +%a" "%b" "%d" "%H:%M -d  "5 min ago")
fileName="catalina.out"
filePath=$logFileLocation/logs/$fileName
cc="krishna.bagal@gmail.com"
 
cat $filePath |sed -n "/$last5min/ , /$curhour/p" >$mailFileLoc
 
cat $mailFileLoc |egrep -i "<string>"
 
if [ $? -eq 0 ];
then
        mail -s "CRITICAL: $hostname: String found in logs" $cc < $mailFileLoc
        exit 2
else
        echo "OK: String not found in log."
        exit 0
fi

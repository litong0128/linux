#!/bin/bash
#define variables
month1=`date -d "1 months" +%y%m`
month2=`date -d "2 months ago" +%y%m`
backupdate=`date +%Y%m%d`
backupfile=sync_config.xml.bak.$backupdate
curr_time1=`date +"%Y-%m-%d %H:%M:%S"`
#backup sync_config.xml file
cd /home/urpusr/dbrepv2.7_datacenter
cp sync_config.xml $backupfile
i=`echo $?`
	if [ $i -eq 0 ]
	then   
		echo "${curr_time1} backup successed!"
	fi

#creste new sync_config.xml
sed -e "s/${month2}/${month1}/g" $backupfile > sync_config.xml
touch sync_config.xml
echo "${curr_time1} replace completed!"



#!/bin/bash
#define variables
month1=`/home/urpusr/shell/month.pl +1`
month2=`/home/urpusr/shell/month.pl -2`
backupdate=`date +%Y%m%d`
backupfile=simple_sync_tab.txt.$backupdate
curr_time1=`date +"%Y-%m-%d %H:%M:%S"`
#backup sync_config.xml file
cd /home/urpusr/dbrepv2.7_datacenter
cp simple_sync_tab.txt $backupfile
i=`echo $?`
	if [ $i -eq 0 ]
	then   
		echo "${curr_time1} backup successed!"
	fi

#creste new sync_config.xml
sed -e "s/${month2}/${month1}/g" $backupfile > simple_sync_tab.txt
touch sync_config.xml
echo "${curr_time1} replace completed!"
#!/bin/bash
#����log����־
date
echo 'begin to clean up log!'
cd /home/urpmblst/dbrepv2.7_mblstat/log
f1=`ls|grep 201`
echo $f1 will be zip!
gzip *.log.201*
echo 'move logs to /db2data/sync_log/urpmblst/log/!'
mv *.gz /db2data/sync_log/urpmblst/log/
#�ƶ���־���洢
echo "moving the logs to store!"
/usr/bin/find /db2data/sync_log/urpmblst/log -name "*.gz" -mtime +14 -exec mv {} /backup/synclog/urpmblst/ \;
 

#����db2log����־
echo 'begin to clean up db2log!'
cd /home/urpmblst/dbrepv2.7_mblstat/db2log
n1=`ls -1rt|wc -l`
n2=`expr $n1 - 1` 
f2=`ls -1rt|head -$n2|xargs`
echo $f2 will be zip!
gzip $f2
echo 'move logs to /db2data/sync_log/urpmblst/db2log/!'
mv *.gz /db2data/sync_log/urpmblst/db2log/
#�ƶ���־���洢
echo "moving the db2logs to store!"
/usr/bin/find /db2data/sync_log/urpmblst/db2log -name "*.gz" -mtime +14 -exec mv {} /backup/synclog/urpmblst/ \;
 
date
echo 'backup logs over!'
echo '===================================================================='
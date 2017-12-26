#!/bin/bash
#�������
SYNC_APL_PATH=/home/urpvstor/dbrepv2.7_vstore
BACKUP_LOG_PATH=/backup/synclog/urpvstor
#����log����־
date
echo 'begin to clean up log!'

#ѹ����־7��ǰ
/usr/bin/find ${SYNC_APL_PATH}/log -name "*.log.201*" -mtime +7 -exec gzip {} \;

#�ƶ���־���洢
cd ${SYNC_APL_PATH}/log
echo "ftp the logs to store!"
ftp -v -n 10.101.4.101 21 <<EOF
user urpvstor taige1234 
binary
cd ${BACKUP_LOG_PATH}
prom
mput *.gz
EOF
#ɾ����־
cd ${SYNC_APL_PATH}/log
rm *.gz

 

#����db2log����־
#ѹ����־7��ǰ
echo 'begin to clean up db2logs!'
/usr/bin/find ${SYNC_APL_PATH}/db2log -name "db2log_dump.*" -mtime +7 -exec gzip {} \;

#�ƶ���־���洢
cd ${SYNC_APL_PATH}/db2log
echo "ftp the db2logs to store!"
ftp -v -n 10.101.4.101 21 <<EOF
user urpvstor taige1234 
binary
cd ${BACKUP_LOG_PATH}
prom
mput *.gz
EOF
#ɾ����־
cd ${SYNC_APL_PATH}/db2log
rm *.gz
date
echo 'backup logs over!'
echo '===================================================================='
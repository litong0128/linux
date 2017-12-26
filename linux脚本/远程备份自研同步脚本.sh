#!/bin/bash
#定义变量
SYNC_APL_PATH=/home/urpvstor/dbrepv2.7_vstore
BACKUP_LOG_PATH=/backup/synclog/urpvstor
#清理log下日志
date
echo 'begin to clean up log!'

#压缩日志7天前
/usr/bin/find ${SYNC_APL_PATH}/log -name "*.log.201*" -mtime +7 -exec gzip {} \;

#移动日志到存储
cd ${SYNC_APL_PATH}/log
echo "ftp the logs to store!"
ftp -v -n 10.101.4.101 21 <<EOF
user urpvstor taige1234 
binary
cd ${BACKUP_LOG_PATH}
prom
mput *.gz
EOF
#删除日志
cd ${SYNC_APL_PATH}/log
rm *.gz

 

#清理db2log下日志
#压缩日志7天前
echo 'begin to clean up db2logs!'
/usr/bin/find ${SYNC_APL_PATH}/db2log -name "db2log_dump.*" -mtime +7 -exec gzip {} \;

#移动日志到存储
cd ${SYNC_APL_PATH}/db2log
echo "ftp the db2logs to store!"
ftp -v -n 10.101.4.101 21 <<EOF
user urpvstor taige1234 
binary
cd ${BACKUP_LOG_PATH}
prom
mput *.gz
EOF
#删除日志
cd ${SYNC_APL_PATH}/db2log
rm *.gz
date
echo 'backup logs over!'
echo '===================================================================='
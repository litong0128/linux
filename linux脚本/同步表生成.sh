#!/bin/bash
. /home/db2inst1/sqllib/db2profile
#程序路径
PRO_PATH=/home/db2inst1/litong/umpay
#xml路径
XML_PATH=/home/db2inst1/litong/umpay/sync/
#同步表文件
SYNC_TAB_NAME=sync.del
SYNC_TAB_NAME_BAK=sync.del.`date +%Y%m%d`
#数据库名，用户名，密码
DB_NAME=UMP_DC
DB_USER=db2inst1
DB_PASSWD=0x720000
echo 更新时间`date +%Y%m%d`
cd $PRO_PATH
#解析同步xml文件
java sync.SyncTable ${XML_PATH}sync_config3.xml>${SYNC_TAB_NAME}
#连接数据库，插入数据
db2 connect to ump_dc
db2 "import from sync.del of del insert_update into monitor.synctable (srctabname,tartabname,synctype)"

#复制备份文件
cp ${SYNC_TAB_NAME} ${SYNC_TAB_NAME_BAK}

if [ $? -eq 0 ]
then
	echo "updated synctables successfully!"
else 
	echo "updated synctables fail!"
fi
echo "============================================================="
echo ""
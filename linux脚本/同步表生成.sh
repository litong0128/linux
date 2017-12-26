#!/bin/bash
. /home/db2inst1/sqllib/db2profile
#����·��
PRO_PATH=/home/db2inst1/litong/umpay
#xml·��
XML_PATH=/home/db2inst1/litong/umpay/sync/
#ͬ�����ļ�
SYNC_TAB_NAME=sync.del
SYNC_TAB_NAME_BAK=sync.del.`date +%Y%m%d`
#���ݿ������û���������
DB_NAME=UMP_DC
DB_USER=db2inst1
DB_PASSWD=0x720000
echo ����ʱ��`date +%Y%m%d`
cd $PRO_PATH
#����ͬ��xml�ļ�
java sync.SyncTable ${XML_PATH}sync_config3.xml>${SYNC_TAB_NAME}
#�������ݿ⣬��������
db2 connect to ump_dc
db2 "import from sync.del of del insert_update into monitor.synctable (srctabname,tartabname,synctype)"

#���Ʊ����ļ�
cp ${SYNC_TAB_NAME} ${SYNC_TAB_NAME_BAK}

if [ $? -eq 0 ]
then
	echo "updated synctables successfully!"
else 
	echo "updated synctables fail!"
fi
echo "============================================================="
echo ""
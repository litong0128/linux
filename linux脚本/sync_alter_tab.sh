#!/bin/bash
. /home/db2inst1/sqllib/db2profile
cd /home/db2inst1/monitor
#变量定义
DB_USER=urpods
DB_PASSWD=JhdabUI2
SEND_USER="15210870137;13601074715"
#SEND_USER="15210870137"

echo =================== `date +%Y%m%d%H%M%S` start! ====================== 
#判断是否同步表方法
function SyncTab()
{
	db2 connect to umpayods > /dev/null
	db2 -x "select TARTABNAME from monitor.SYNCTABLE where SRCTABNAME = '$1' fetch first 1 rows only"
	db2 connect reset > /dev/null
}
function isSyncTab()
{	
	
	for T in `cat $1`
	do	
		
		SRCTABNAME=`SyncTab $T`
		#如果存在表结构变更
                if [ ${SRCTABNAME} ]
		then
			#获取源端表结构描述
			db2 connect to $3 user ${DB_USER} using ${DB_PASSWD}> /dev/null
			db2 describe table ${T} |grep -v selected|awk '{print $1}' > sourcedes.txt
			db2 connect reset > /dev/null
			echo "sourcedes ==============================="
			cat sourcedes.txt
			
			#获取目标端表结构描述
			db2 connect to umpayods > /dev/null
			db2 describe table ${SRCTABNAME} |grep -i -v inodstime|grep -i -v odstime|grep -v selected|awk '{print $1}'  > targetdes.txt
			db2 connect reset > /dev/null
			echo "targetdes ==============================="
			cat targetdes.txt
			
			#比对结构差异
			ALTER=`comm -23 sourcedes.txt targetdes.txt`
			NUMCOL=`comm -23 sourcedes.txt targetdes.txt|wc -l`
			
			#如果存在发送短信
			if [ ${NUMCOL} -ge 1 ]
			then
				SMS=`echo SYNCTAB_$2_"'${T}'"_has_been_altered_add_colume_"'${ALTER}'"`
				/db2data/db2monitor_ods/umpayods_shell/sendsms/run.sh ${SEND_USER} ${SMS}
				echo 短信发送内容：${SMS}
			fi
		fi
	done
	
}

#查询变更表
##丰台
cd /home/db2inst1/monitor
db2 connect to UPOFF172 user ${DB_USER} using ${DB_PASSWD}> /dev/null
db2 -x "select rtrim(TABSCHEMA)||'.'||rtrim(TABNAME) from syscat.tables where to_char(ALTER_TIME,'yyyy-mm-dd') =  current date and ALTER_TIME<>CREATE_TIME">TEMP_ALT_TAB_UPAYOFF
#db2 -x "select rtrim(TABSCHEMA)||'.'||rtrim(TABNAME) from syscat.tables where to_char(ALTER_TIME,'yyyy-mm-dd') =  '2014-08-01' and ALTER_TIME<>CREATE_TIME">TEMP_ALT_TAB_UPAYOFF
db2 connect reset > /dev/null
isSyncTab TEMP_ALT_TAB_UPAYOFF UPAYOFF UPOFF172
echo "UPAYOFF ALTER TABLE ==============================="
cat TEMP_ALT_TAB_UPAYOFF 

##望京
cd /home/db2inst1/monitor
db2 connect to STAT201 user ${DB_USER} using ${DB_PASSWD}> /dev/null
db2 -x "select rtrim(TABSCHEMA)||'.'||rtrim(TABNAME) from syscat.tables where to_char(ALTER_TIME,'yyyy-mm-dd') =  current date and ALTER_TIME<>CREATE_TIME">TEMP_ALT_TAB_MBLSTAT
db2 connect reset > /dev/null
isSyncTab TEMP_ALT_TAB_MBLSTAT MBLSTAT STAT201
echo "MBLSTAT ALTER TABLE ==============================="
cat TEMP_ALT_TAB_MBLSTAT 

echo =================== `date +%Y%m%d%H%M%S` end! ====================== 
echo ""


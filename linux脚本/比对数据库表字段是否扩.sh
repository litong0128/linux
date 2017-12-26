####################################################
# author:litong                                    #
# date: 20140813                                   #
# version: 1.0                                     #
# function:表结构字段长度比较程序                  #
####################################################
#!/bin/bash
#定义源端表名
SRCTAB_NAME=$1
#定义目标端表名
TARTAB_NAME=$2
#源端数据库名
SRCDB_NAME=$3
#源端数据库用户名密码
#变量定义
DB_USER=urpods
DB_PASSWD=JhdabUI2
SEND_USER=15210870137

compare ${SRCTAB_NAME} ${TARTAB_NAME} $3
function compare()
{
	#获取源端表结构描述
			db2 connect to $3 user ${DB_USER} using ${DB_PASSWD}> /dev/null
			
			db2 describe table ${T}|sed '1,4d'|grep CHAR|sort -b|awk '{print $1,$3,$4}'> sourcedest.txt
			db2 connect reset > /dev/null
			echo "sourcedes ==============================="
			cat sourcedest.txt
			rm sourcedest.txt
			#获取目标端表结构描述
			db2 connect to umpayods > /dev/null
			db2 describe table ${SRCTABNAME}|sed '1,4d'|grep CHAR|sort -b|awk '{print $1,$3,$4}'  > targetdest.txt
			db2 connect reset > /dev/null
			echo "targetdes ==============================="
			cat targetdest.txt
			rm targetdest.txt
			
			#比对结构差异
			ALTER=`comm -3 sourcedes.txt targetdes.txt`
			NUMCOL=`comm -3 sourcedes.txt targetdes.txt|wc -l`
			
			#如果存在发送短信
			if [ ${NUMCOL} -ge 1 ]
			then
				SMS=`echo SYNCTAB_$3_"'${T}'"__columes_"'${ALTER}'"_were_not_expanded`
				/db2data/db2monitor_ods/umpayods_shell/sendsms/run.sh ${SEND_USER} ${SMS}
				echo 短信发送内容：${SMS}
			fi
}


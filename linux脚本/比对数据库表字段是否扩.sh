####################################################
# author:litong                                    #
# date: 20140813                                   #
# version: 1.0                                     #
# function:��ṹ�ֶγ��ȱȽϳ���                  #
####################################################
#!/bin/bash
#����Դ�˱���
SRCTAB_NAME=$1
#����Ŀ��˱���
TARTAB_NAME=$2
#Դ�����ݿ���
SRCDB_NAME=$3
#Դ�����ݿ��û�������
#��������
DB_USER=urpods
DB_PASSWD=JhdabUI2
SEND_USER=15210870137

compare ${SRCTAB_NAME} ${TARTAB_NAME} $3
function compare()
{
	#��ȡԴ�˱�ṹ����
			db2 connect to $3 user ${DB_USER} using ${DB_PASSWD}> /dev/null
			
			db2 describe table ${T}|sed '1,4d'|grep CHAR|sort -b|awk '{print $1,$3,$4}'> sourcedest.txt
			db2 connect reset > /dev/null
			echo "sourcedes ==============================="
			cat sourcedest.txt
			rm sourcedest.txt
			#��ȡĿ��˱�ṹ����
			db2 connect to umpayods > /dev/null
			db2 describe table ${SRCTABNAME}|sed '1,4d'|grep CHAR|sort -b|awk '{print $1,$3,$4}'  > targetdest.txt
			db2 connect reset > /dev/null
			echo "targetdes ==============================="
			cat targetdest.txt
			rm targetdest.txt
			
			#�ȶԽṹ����
			ALTER=`comm -3 sourcedes.txt targetdes.txt`
			NUMCOL=`comm -3 sourcedes.txt targetdes.txt|wc -l`
			
			#������ڷ��Ͷ���
			if [ ${NUMCOL} -ge 1 ]
			then
				SMS=`echo SYNCTAB_$3_"'${T}'"__columes_"'${ALTER}'"_were_not_expanded`
				/db2data/db2monitor_ods/umpayods_shell/sendsms/run.sh ${SEND_USER} ${SMS}
				echo ���ŷ������ݣ�${SMS}
			fi
}


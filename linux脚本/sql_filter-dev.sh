#!/bin/bash

#######################################
#author�� yueyx
#createdate��20150504
#function��1���ҳ�select *��SQL
#          2���ҳ�����like��SQL
#          3���ҳ�û��where������SQL
#          4���ҳ�û�󶨱�����SQL
#          5���ҳ�insert���޶���ֵ
#		       6���ҳ�update������SQL
#                       
#######################################
## include variable
####. /home/db2inst1/monitor/comm_var
. /home/udbapon/monitor/comm_var

## check active server
####. $LOCAL_MON_DIR/current_check.sh

cd $SH_OPER_DIR
## ��ȡ����
##DD=`date.pl -1`
DD=`TZ=aaa16 date +%Y%m%d`

##��ȡ����
. /home/$INSTNAME/sqllib/db2profile
db2 connect to $DBNAME
db2 -x "select substr(TABSCHEMA,1,10) as TABSCHEMA, substr(TABNAME,1,40) as TABNAME, COLNAMES from syscat.INDEXES where TABSCHEMA not in ('SYSIBM','SYSCAT','SYSSTAT','SYSIBMADM','SYSTOOLS','DB2INST1') and UNIQUERULE='P'" > $LOG_DIR/$DBNAME.pk.txt
db2 connect reset

#����ɨ���ļ�
INPUT_FILE=$LOG_DIR/$DBNAME.sql.${DD}.txt
echo ${INPUT_FILE}

#���������ļ�
PK_FILE=$LOG_DIR/$DBNAME.pk.txt
echo ${PK_FILE}

####
##############################################################################
######�ҳ�select *��SQL
####cat ${INPUT_FILE} |grep -i "select" |grep -i "*" > $LOG_DIR/tmp_selet_star
####
######�ҳ�����like��SQL
####cat ${INPUT_FILE} |grep -i "like" |grep -v "record(" > $LOG_DIR/tmp_where_like
####
######�ҳ�û��where������SQL
####cat ${INPUT_FILE} |grep -i "select" |grep -v -i "where"|grep -v "record(" > $LOG_DIR/tmp_no_where
####
######�ҳ�whereû�󶨱�����SQL
####cat ${INPUT_FILE} |grep -i "where" |grep -i -v "like" |grep -i -v "?" > $LOG_DIR/tmp_where_params
####
#####�ҳ�insert���޶���ֵ
####cat ${INPUT_FILE} |grep -i "insert"|grep -i "values" |awk -F '' '{print $0"|"}'> $LOG_DIR/tmp_insert
####OLDIFS=$IFS
####IFS='|'
####for IS in `cat $LOG_DIR/tmp_insert`
####do
####	#echo $IS
####	#��ȡinsert�����values��ǰ�벿��
####	INSERT_BPART=`echo $IS |awk -F ' ' '{$1=$2=$3=$4=$5="";print}'|awk -F 'values' '{print $1}'`	
####	[[ $INSERT_BPART =~ ")" ]] && [[ $INSERT_BPART =~ "(" ]] && echo "" || echo "$IS" > $LOG_DIR/tmp_insert_nokey
####	
####done
####IFS=$OLDIFS
####
##############################################################################
####      


#�ҳ�update������SQL 
#ɸѡ��update���
cat $INPUT_FILE|grep -i "update"|grep -i "where"|grep -v -i "select" > $LOG_DIR/tmp_update

#���������ļ�
cat $PK_FILE |grep -v "-"|grep -v "("|grep -v "TABSCHEMA"|awk -F ' ' '{print $1"."$2" "$3}' > $LOG_DIR/tmp_pk

##for_test
echo "LOG_DIR=$LOG_DIR"

#update����л�ñ������õ��ı���ͳһת���ɴ�д��
#cat upayon.sql.20150504.txt|grep -i "update"|grep -i "where"|grep -v -i "select"|awk -F ' ' '{$1=$2=$3=$4=$5="";print}'|awk -F 'update' '{print $2}'|awk -F ' ' '{print $1}'
#update����л�ø����������õ���������ͳһת���ɴ�д��
#cat upayon.sql.20150504.txt|grep -i "update"|grep -i "where"|grep -v -i "select"|awk -F 'set' '{print $2}'|awk -F 'where' '{print $1}' 
cat $LOG_DIR/tmp_update|awk -F '' '{print $0"|"}'> $LOG_DIR/tmp_update2
OLDIFS=$IFS
IFS='|'
for WH in `cat $LOG_DIR/tmp_update2`
do
	#������ת�ɴ�д
	typeset -u TAB_NAME
	typeset -u UPDATE_SET_VALUE
	#��ȡupdate����еı���
	TAB_NAME=`echo $WH |awk -F ' ' '{$1=$2=$3=$4=$5="";print}'|awk -F 'update' '{print $2}'|awk -F ' ' '{print $1}'`
	#��ȡupdate�����set�޸ĵ���
	UPDATE_SET_VALUE=`echo $WH |awk -F 'set' '{print $2}'|awk -F 'where' '{print $1}'`
	echo TAB_NAME=$TAB_NAME
	echo UPDATE_SET_VALUE=$UPDATE_SET_VALUE
	
	TAB_PK=`cat $LOG_DIR/tmp_pk |grep "$TAB_NAME" |awk -F ' ' '{print $2}'|awk -F '+' '{print $2" "$3}' `
	IFS=$OLDIFS
	for PK in `echo $TAB_PK`
	do
		#echo $PK
		##################################################################
		#str="this is a string"
		#Ҫ�����ж�str���Ƿ���"this"����ַ��������������ǿ��е�
		#[[ $str =~ "this" ]] && echo "\$str contains this" 
		#[[ $str =~ "that" ]] || echo "\$str does NOT contain this"
		##################################################################
		#[[ $UPDATE_SET_VALUE =~ ""${PK}"" ]] && echo "$UPDATE_SET_VALUE contains $PK" && break
		[[ $UPDATE_SET_VALUE =~ ""${PK}"" ]] && echo "$WH"> $LOG_DIR/tmp_update_pk && break
	done
	OLDIFS=$IFS

done
IFS=$OLDIFS





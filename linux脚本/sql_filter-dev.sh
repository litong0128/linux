#!/bin/bash

#######################################
#author： yueyx
#createdate：20150504
#function：1、找出select *的SQL
#          2、找出含有like的SQL
#          3、找出没有where条件的SQL
#          4、找出没绑定变量的SQL
#          5、找出insert不限定列值
#		       6、找出update主键的SQL
#                       
#######################################
## include variable
####. /home/db2inst1/monitor/comm_var
. /home/udbapon/monitor/comm_var

## check active server
####. $LOCAL_MON_DIR/current_check.sh

cd $SH_OPER_DIR
## 获取日期
##DD=`date.pl -1`
DD=`TZ=aaa16 date +%Y%m%d`

##获取主键
. /home/$INSTNAME/sqllib/db2profile
db2 connect to $DBNAME
db2 -x "select substr(TABSCHEMA,1,10) as TABSCHEMA, substr(TABNAME,1,40) as TABNAME, COLNAMES from syscat.INDEXES where TABSCHEMA not in ('SYSIBM','SYSCAT','SYSSTAT','SYSIBMADM','SYSTOOLS','DB2INST1') and UNIQUERULE='P'" > $LOG_DIR/$DBNAME.pk.txt
db2 connect reset

#定义扫描文件
INPUT_FILE=$LOG_DIR/$DBNAME.sql.${DD}.txt
echo ${INPUT_FILE}

#定义主键文件
PK_FILE=$LOG_DIR/$DBNAME.pk.txt
echo ${PK_FILE}

####
##############################################################################
######找出select *的SQL
####cat ${INPUT_FILE} |grep -i "select" |grep -i "*" > $LOG_DIR/tmp_selet_star
####
######找出含有like的SQL
####cat ${INPUT_FILE} |grep -i "like" |grep -v "record(" > $LOG_DIR/tmp_where_like
####
######找出没有where条件的SQL
####cat ${INPUT_FILE} |grep -i "select" |grep -v -i "where"|grep -v "record(" > $LOG_DIR/tmp_no_where
####
######找出where没绑定变量的SQL
####cat ${INPUT_FILE} |grep -i "where" |grep -i -v "like" |grep -i -v "?" > $LOG_DIR/tmp_where_params
####
#####找出insert不限定列值
####cat ${INPUT_FILE} |grep -i "insert"|grep -i "values" |awk -F '' '{print $0"|"}'> $LOG_DIR/tmp_insert
####OLDIFS=$IFS
####IFS='|'
####for IS in `cat $LOG_DIR/tmp_insert`
####do
####	#echo $IS
####	#获取insert语句中values的前半部分
####	INSERT_BPART=`echo $IS |awk -F ' ' '{$1=$2=$3=$4=$5="";print}'|awk -F 'values' '{print $1}'`	
####	[[ $INSERT_BPART =~ ")" ]] && [[ $INSERT_BPART =~ "(" ]] && echo "" || echo "$IS" > $LOG_DIR/tmp_insert_nokey
####	
####done
####IFS=$OLDIFS
####
##############################################################################
####      


#找出update主键的SQL 
#筛选出update语句
cat $INPUT_FILE|grep -i "update"|grep -i "where"|grep -v -i "select" > $LOG_DIR/tmp_update

#整理主键文件
cat $PK_FILE |grep -v "-"|grep -v "("|grep -v "TABSCHEMA"|awk -F ' ' '{print $1"."$2" "$3}' > $LOG_DIR/tmp_pk

##for_test
echo "LOG_DIR=$LOG_DIR"

#update语句中获得表名（得到的表名统一转换成大写）
#cat upayon.sql.20150504.txt|grep -i "update"|grep -i "where"|grep -v -i "select"|awk -F ' ' '{$1=$2=$3=$4=$5="";print}'|awk -F 'update' '{print $2}'|awk -F ' ' '{print $1}'
#update语句中获得更新条件（得到的条件名统一转换成大写）
#cat upayon.sql.20150504.txt|grep -i "update"|grep -i "where"|grep -v -i "select"|awk -F 'set' '{print $2}'|awk -F 'where' '{print $1}' 
cat $LOG_DIR/tmp_update|awk -F '' '{print $0"|"}'> $LOG_DIR/tmp_update2
OLDIFS=$IFS
IFS='|'
for WH in `cat $LOG_DIR/tmp_update2`
do
	#将变量转成大写
	typeset -u TAB_NAME
	typeset -u UPDATE_SET_VALUE
	#获取update语句中的表名
	TAB_NAME=`echo $WH |awk -F ' ' '{$1=$2=$3=$4=$5="";print}'|awk -F 'update' '{print $2}'|awk -F ' ' '{print $1}'`
	#获取update语句中set修改的列
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
		#要想在判断str中是否含有"this"这个字符串，下面的语句是可行的
		#[[ $str =~ "this" ]] && echo "\$str contains this" 
		#[[ $str =~ "that" ]] || echo "\$str does NOT contain this"
		##################################################################
		#[[ $UPDATE_SET_VALUE =~ ""${PK}"" ]] && echo "$UPDATE_SET_VALUE contains $PK" && break
		[[ $UPDATE_SET_VALUE =~ ""${PK}"" ]] && echo "$WH"> $LOG_DIR/tmp_update_pk && break
	done
	OLDIFS=$IFS

done
IFS=$OLDIFS





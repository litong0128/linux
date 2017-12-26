#!/bin/bash
###############################################################################
#    文件名  :    fxq_sqlldr.sh                                               #
#    功  能  :    加载数据到反洗钱表                                          #
#    编  写  :    李童                                                        #
#    修  改  :                                                                #
#    时  间  :    2015-01-12                                                  #
#    版  权  :    litong                                                      #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :    			                                                  #
#    说  明  :                                                                #
###############################################################################
#引入配置文件
. /home/litong/FXQ/shell/common
. /home/litong/FXQ/shell/publish.sh
. $HOME/.profile
#程序开始记录日志信息
_Mesg ${DATA_DATE}反洗钱sqlldr程序开始 ${FXQ_SQLLDR_LOG}
#初始化方法
function init()
{
#创建每日加载数据目录
mkdir -p ${USER_HOME_PATH}/${APP_PATH}/${DATA_PATH}/${DATA_DATE}

}

#将文件进行转码
function iconvUTF8toGBK()
{
	cd ${USER_HOME_PATH}/${APP_PATH}/${DATA_PATH}/${DATA_DATE}
	cp $1 $1.bak
	iconv -f UTF-8 -t GB18030 $1.bak > $1 
}
#定义sftp到鉴权服务器方法
function sftpTofk()
{
	cd ${EXPORT_PAHT}
	/usr/bin/sftp ${FTP_USER}@${FTP_SERVER} <<EOF>ftp.log
    cd ${FTP_PATH}
    get $1
EOF
}

# param1：tabname param2：primarykey param3 ：temptable
function delete_insert()
{
		
		/oracle/db/product/11.2/db_1/bin/sqlplus -S /nolog > $1_UPDATE.log <<EOF
		set heading off feedback off pagesize 0 verify off echo off
		conn ${DB_USER}/${DB_PASSWD}
		DELETE FROM $1 WHERE $2 in (select $2 from $3);
		INSERT INTO $1 SELECT * FROM $3;
		exit
EOF
		
}

# param1：tabname param2：values
function insert()
{
	        /oracle/db/product/11.2/db_1/bin/sqlplus -S /nolog > $1_INSERT.log <<EOF
		set heading off feedback off pagesize 0 verify off echo off
		conn ${DB_USER}/${DB_PASSWD}
		INSERT INTO $1 VALUES ($2);
		exit
EOF
}

#定义ftp到鉴权服务器方法
function ftpTofk()
{
	cd ${EXPORT_PAHT}
	/usr/bin/ftp -v -n ${FTP_SERVER} <<EOF>ftp.log
    user ${FTP_USER} ${FTP_PASS}
    binary
    cd ${FTP_PATH}
    prom
    mget $1
EOF
	grep "Transfer complete" ftp.log
	X=$?
	grep "send aborted" ftp.log
	Y=$?
	echo X:$X  Y:$Y 
	if [ $X -eq 0 -a $Y -ne 0 ]
		then
			echo ftp $1文件成功！
			return 0
		else
			echo ftp $1文件失败！
			return 1
	fi
}

#生成加载ctl文件
function load_ctl()
{
	IFS=$OLDIFS
	function write_ctl()
	{
		echo $* >> ${TAB_NAME}.ctl
	}
	>${TAB_NAME}.ctl
	write_ctl load data
    write_ctl infile "'"$1"'"
	write_ctl badfile "'"$1.bad"'"
    write_ctl truncate into table ${TAB_NAME}
    write_ctl fields terminated by "'|'"
	write_ctl TRAILING NULLCOLS
    write_ctl "("$2")"
}
#切换到数据日期文件夹
init
cd ${USER_HOME_PATH}/${APP_PATH}/${DATA_PATH}/${DATA_DATE}
#获取数据文件，和控制文件
_Mesg "ftp获取DAT数据文件，和CTL控制文件开始" ${FXQ_SQLLDR_LOG}
sftpTofk ${DATA_PFX}*_${DATA_DATE}.*
if [ $? -eq 0 ]
	then
	_Mesg "ftp获取DAT数据文件，和CTL控制文件完成" ${FXQ_SQLLDR_LOG}
	else
	_Mesg "ftp获取DAT数据文件，和CTL控制文件失败" ${FXQ_SQLLDR_LOG}
fi 

#加载数据到反洗钱表
_Mesg "开始加载数据到反洗钱表" ${FXQ_SQLLDR_LOG}
OLDIFS=$IFS;
IFS=;
echo $IFS 
for TABNAME in `cat ${SYNC_TAB_CFL}`
do
	TAB_NAME=`echo $TABNAME|awk -F '|' '{print $1}'`
	TAB_COLUMNS=`echo $TABNAME|awk -F '|' '{print $2}'`
	#生成加载ctl文件
	load_ctl ${DATA_PFX}_${TAB_NAME}_${DATA_DATE}.${DATA_SFX} $TAB_COLUMNS
	#判断控制文件是否完全，如果缺少退出程序。
	ls ${DATA_PFX}_${TAB_NAME}_${DATA_DATE}.${DATA_CTL_SFX}
	if [ $? -ne 0 ]
		then
			_Mesg "表"${TAB_NAME}"数据控制文件未找到" ${FXQ_SQLLDR_LOG}
			exit	
	fi 
	iconvUTF8toGBK ${DATA_PFX}_${TAB_NAME}_${DATA_DATE}.${DATA_SFX}
        /oracle/db/product/11.2/db_1/bin/sqlldr userid=${DB_USER}/${DB_PASSWD} control=${DBLD_CONTROL_FILE}/${TAB_NAME}.ctl log=${DBLD_LOG_FILE}/${TAB_NAME}.out
	_Mesg "加载数据到反洗钱表"${TAB_NAME}"完成" ${FXQ_SQLLDR_LOG}
done
IFS=$OLDIFS
delete_insert S01_PER_USER USER_ID S01_PER_USER_TMP
insert antilaundry.t18_ds03_flag "'"`TZ=aaa16 date +%Y-%m-%d`"'",1
#压缩数据文件
gzip *.DAT
gzip *.DAT.bak
rm *.DAT.bak.gz
_Mesg "加载数据到反洗钱表完成" ${FXQ_SQLLDR_LOG}


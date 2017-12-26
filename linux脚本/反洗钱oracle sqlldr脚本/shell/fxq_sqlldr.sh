#!/bin/bash
###############################################################################
#    �ļ���  :    fxq_sqlldr.sh                                               #
#    ��  ��  :    �������ݵ���ϴǮ��                                          #
#    ��  д  :    ��ͯ                                                        #
#    ��  ��  :                                                                #
#    ʱ  ��  :    2015-01-12                                                  #
#    ��  Ȩ  :    litong                                                      #
#    ��  ��  :                                                                #
#    ʱ  ��  :                                                                #
#    ��  ��  :    			                                                  #
#    ˵  ��  :                                                                #
###############################################################################
#���������ļ�
. /home/litong/FXQ/shell/common
. /home/litong/FXQ/shell/publish.sh
. $HOME/.profile
#����ʼ��¼��־��Ϣ
_Mesg ${DATA_DATE}��ϴǮsqlldr����ʼ ${FXQ_SQLLDR_LOG}
#��ʼ������
function init()
{
#����ÿ�ռ�������Ŀ¼
mkdir -p ${USER_HOME_PATH}/${APP_PATH}/${DATA_PATH}/${DATA_DATE}

}

#���ļ�����ת��
function iconvUTF8toGBK()
{
	cd ${USER_HOME_PATH}/${APP_PATH}/${DATA_PATH}/${DATA_DATE}
	cp $1 $1.bak
	iconv -f UTF-8 -t GB18030 $1.bak > $1 
}
#����sftp����Ȩ����������
function sftpTofk()
{
	cd ${EXPORT_PAHT}
	/usr/bin/sftp ${FTP_USER}@${FTP_SERVER} <<EOF>ftp.log
    cd ${FTP_PATH}
    get $1
EOF
}

# param1��tabname param2��primarykey param3 ��temptable
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

# param1��tabname param2��values
function insert()
{
	        /oracle/db/product/11.2/db_1/bin/sqlplus -S /nolog > $1_INSERT.log <<EOF
		set heading off feedback off pagesize 0 verify off echo off
		conn ${DB_USER}/${DB_PASSWD}
		INSERT INTO $1 VALUES ($2);
		exit
EOF
}

#����ftp����Ȩ����������
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
			echo ftp $1�ļ��ɹ���
			return 0
		else
			echo ftp $1�ļ�ʧ�ܣ�
			return 1
	fi
}

#���ɼ���ctl�ļ�
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
#�л������������ļ���
init
cd ${USER_HOME_PATH}/${APP_PATH}/${DATA_PATH}/${DATA_DATE}
#��ȡ�����ļ����Ϳ����ļ�
_Mesg "ftp��ȡDAT�����ļ�����CTL�����ļ���ʼ" ${FXQ_SQLLDR_LOG}
sftpTofk ${DATA_PFX}*_${DATA_DATE}.*
if [ $? -eq 0 ]
	then
	_Mesg "ftp��ȡDAT�����ļ�����CTL�����ļ����" ${FXQ_SQLLDR_LOG}
	else
	_Mesg "ftp��ȡDAT�����ļ�����CTL�����ļ�ʧ��" ${FXQ_SQLLDR_LOG}
fi 

#�������ݵ���ϴǮ��
_Mesg "��ʼ�������ݵ���ϴǮ��" ${FXQ_SQLLDR_LOG}
OLDIFS=$IFS;
IFS=;
echo $IFS 
for TABNAME in `cat ${SYNC_TAB_CFL}`
do
	TAB_NAME=`echo $TABNAME|awk -F '|' '{print $1}'`
	TAB_COLUMNS=`echo $TABNAME|awk -F '|' '{print $2}'`
	#���ɼ���ctl�ļ�
	load_ctl ${DATA_PFX}_${TAB_NAME}_${DATA_DATE}.${DATA_SFX} $TAB_COLUMNS
	#�жϿ����ļ��Ƿ���ȫ�����ȱ���˳�����
	ls ${DATA_PFX}_${TAB_NAME}_${DATA_DATE}.${DATA_CTL_SFX}
	if [ $? -ne 0 ]
		then
			_Mesg "��"${TAB_NAME}"���ݿ����ļ�δ�ҵ�" ${FXQ_SQLLDR_LOG}
			exit	
	fi 
	iconvUTF8toGBK ${DATA_PFX}_${TAB_NAME}_${DATA_DATE}.${DATA_SFX}
        /oracle/db/product/11.2/db_1/bin/sqlldr userid=${DB_USER}/${DB_PASSWD} control=${DBLD_CONTROL_FILE}/${TAB_NAME}.ctl log=${DBLD_LOG_FILE}/${TAB_NAME}.out
	_Mesg "�������ݵ���ϴǮ��"${TAB_NAME}"���" ${FXQ_SQLLDR_LOG}
done
IFS=$OLDIFS
delete_insert S01_PER_USER USER_ID S01_PER_USER_TMP
insert antilaundry.t18_ds03_flag "'"`TZ=aaa16 date +%Y-%m-%d`"'",1
#ѹ�������ļ�
gzip *.DAT
gzip *.DAT.bak
rm *.DAT.bak.gz
_Mesg "�������ݵ���ϴǮ�����" ${FXQ_SQLLDR_LOG}


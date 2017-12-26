#!/bin/bash
###############################################################################
#    �ļ���  :    fxq_sqlldr_rerun.sh                                         #
#    ��  ��  :    ���ܷ�ϴǮ�ű�                                          	  #
#    ��  д  :    ��ͯ                                                        #
#    ��  ��  :                                                                #
#    ʱ  ��  :    2015-03-20                                                  #
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
echo ========================`date`======================= 
#�����Ƿ�ִ��״̬�����ִ����1 ����Ϊ�ա�
STATUS=0
#���fxq_sqlldr.sh�Ƿ����У���ѯ��antilaundry.t18_ds03_flag����
function selectdate()
{
		/oracle/db/product/11.2/db_1/bin/sqlplus -S /nolog >/home/litong/FXQ/shell/$1_SELECT.log <<EOF
		set heading off feedback off pagesize 0 verify off echo off
		conn ${DB_USER}/${DB_PASSWD}
		SELECT count(STATUS) FROM $1 WHERE STATISTICDATE=$2;
		exit
EOF
} 

selectdate antilaundry.t18_ds03_flag "'"`TZ=aaa16 date +%Y-%m-%d`"'"

cd /home/litong/FXQ/shell
STATUS=`cat antilaundry.t18_ds03_flag_SELECT.log`

echo STATUS:$STATUS
if [ $STATUS -ne 1 ]
then 
	echo `date`"��ϴǮ�ű�δ�ܳɹ����п�ʼ���ܣ�"
#	echo $STATUS
	cd /home/litong/FXQ/shell
	./fxq_sqlldr.sh >> fxq_sqlldr.out
else
	echo `date`"��ϴǮ�ű��ѳɹ����У�"
#	exit;
fi
echo ==========================end===========================
echo ""
echo ""

#!/bin/bash
###############################################################################
#    文件名  :    fxq_sqlldr_rerun.sh                                         #
#    功  能  :    重跑反洗钱脚本                                          	  #
#    编  写  :    李童                                                        #
#    修  改  :                                                                #
#    时  间  :    2015-03-20                                                  #
#    版  权  :    litong                                                      #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :    			                                                  #
#    说  明  :                                                                #
###############################################################################
#引入配置文件
. /home/litong/FXQ/shell/common
. $HOME/.profile
#定义是否执行状态，如果执行是1 否者为空。
STATUS=0
#检测fxq_sqlldr.sh是否运行，查询表antilaundry.t18_ds03_flag日期
function selectdate()
{
		/oracle/db/product/11.2/db_1/bin/sqlplus -S /nolog > $1_SELECT.log <<EOF
		set heading off feedback off pagesize 0 verify off echo off
		conn ${DB_USER}/${DB_PASSWD}
		SELECT STATUS FROM $1 WHERE STATISTICDATE=$2;
		exit
EOF
} 

selectdate antilaundry.t18_ds03_flag "'"`TZ=aaa16 date +%Y-%m-%d`"'"
cd /home/litong/FXQ/shell
STATUS=`cat antilaundry.t18_ds03_flag_SELECT.log`

if [ $STATUS -ne 1 ]
then 
	echo `date`"反洗钱脚本未能成功运行开始重跑！"
	echo $STATUS
else
	echo `date`"反洗钱脚本已成功运行！"
	exit;
fi


#!/bin/bash
#
#定义变量
FAIL_DATE=`TZ=aaa24 date +%Y%m%d`

if [ $1 ]
        then
        FAIL_DATE=$1
fi
CONTEXT="${FAIL_DATE}fail_sql.log ana_result in /home/urpusr/lt/shell/fail_log_analyse.log"
cp /db2backup/urpusr/log/fail_sql.log.${FAIL_DATE}.gz ~/lt 
cd ~/lt/shell/
gzip -d fail_sql.log.${FAIL_DATE}.gz

echo ==============${FAIL_DATE}失败日志分析结果==============
#出现sqlstate的失败行数
echo --------------sqlstate总记录数--------------
grep "sqlstate" fail_sql.log.${FAIL_DATE}|wc -l

#筛选sqlstate类型出现次数
echo --------------sqlstate类型统计--------------
grep "sqlstate" fail_sql.log.${FAIL_DATE}|awk -F"|" '{ print $3 }'|sort -b|uniq -c

echo --------------sqlstate类型表分布统计--------------
#//grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep INSERT|awk -F"|" '{ print $2 }'|awk -F" " '{ print $3 }'|awk -F"(" '{ print $1 }'|sort|uniq -c
grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep INSERT|awk -F"|" '{ print $3 " " $2  }'|awk -F"(" '{ print $1 }'|awk -F" " '{ print $1 " " $4  }'|sort|uniq -c
#结果
#  47 sqlstate:23505 MOBILE.THFUSER
#  80 sqlstate:23505 MOBILE.THFUSERLTD
#7777 sqlstate:23505 MOBILE.TXEUSERLTD
#//grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep UPDATE|awk -F"|" '{ print $2 }'|awk -F" " '{ print $2 }'|sort|uniq -c
grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep UPDATE|awk -F"|" '{ print $3 " " $2  }'|awk -F" " '{ print $1 " " $3  }'|sort|uniq -c
#结果
#   1 sqlstate:40001 MOBILE.THFUSER_06

#结果：
#7904 sqlstate:23505
#   1 sqlstate:40001

#update失败无操作的
echo --------------执行UPDATE失败无后续操作总记录数--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep UPDATE|wc -l
echo --------------执行UPDATE失败无后续操作表分布情况--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep UPDATE|awk -F"|" '{ print $2 }'|awk -F" " '{ print $2 }'|sort|uniq -c
#结果：
#   1 MOBILE.THFUSER
#13434 MOBILE.THFUSERLTD
#  18 MOBILE.TSPEUSERLIST
#  30 MOBILE.TXEUSERLTD
#   1 UMPAY.T_HFWX_USER
   
#delete失败无操作的
echo --------------执行DELETE失败无后续操作总记录数--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep DELETE|wc -l
echo --------------执行DELETE失败无后续操作表分布情况--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep DELETE|awk -F"|" '{ print $2 }'|awk -F" " '{ print $3 }'|sort|uniq -c
#结果：
#   2 MOBILE.TSPEUSERLIST_06
echo ==========================================================
echo "  "
echo "  "

/db2data/monitor/umpayods_shell/sendsms/run.sh "15210870137" ${CONTEXT}
rm fail_sql.log.${FAIL_DATE}








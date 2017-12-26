#!/bin/bash
#
#�������
FAIL_DATE=`TZ=aaa24 date +%Y%m%d`

if [ $1 ]
        then
        FAIL_DATE=$1
fi
CONTEXT="${FAIL_DATE}fail_sql.log ana_result in /home/urpusr/lt/shell/fail_log_analyse.log"
cp /db2backup/urpusr/log/fail_sql.log.${FAIL_DATE}.gz ~/lt 
cd ~/lt/shell/
gzip -d fail_sql.log.${FAIL_DATE}.gz

echo ==============${FAIL_DATE}ʧ����־�������==============
#����sqlstate��ʧ������
echo --------------sqlstate�ܼ�¼��--------------
grep "sqlstate" fail_sql.log.${FAIL_DATE}|wc -l

#ɸѡsqlstate���ͳ��ִ���
echo --------------sqlstate����ͳ��--------------
grep "sqlstate" fail_sql.log.${FAIL_DATE}|awk -F"|" '{ print $3 }'|sort -b|uniq -c

echo --------------sqlstate���ͱ�ֲ�ͳ��--------------
#//grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep INSERT|awk -F"|" '{ print $2 }'|awk -F" " '{ print $3 }'|awk -F"(" '{ print $1 }'|sort|uniq -c
grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep INSERT|awk -F"|" '{ print $3 " " $2  }'|awk -F"(" '{ print $1 }'|awk -F" " '{ print $1 " " $4  }'|sort|uniq -c
#���
#  47 sqlstate:23505 MOBILE.THFUSER
#  80 sqlstate:23505 MOBILE.THFUSERLTD
#7777 sqlstate:23505 MOBILE.TXEUSERLTD
#//grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep UPDATE|awk -F"|" '{ print $2 }'|awk -F" " '{ print $2 }'|sort|uniq -c
grep "sqlstate" fail_sql.log.${FAIL_DATE}|grep UPDATE|awk -F"|" '{ print $3 " " $2  }'|awk -F" " '{ print $1 " " $3  }'|sort|uniq -c
#���
#   1 sqlstate:40001 MOBILE.THFUSER_06

#�����
#7904 sqlstate:23505
#   1 sqlstate:40001

#updateʧ���޲�����
echo --------------ִ��UPDATEʧ���޺��������ܼ�¼��--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep UPDATE|wc -l
echo --------------ִ��UPDATEʧ���޺���������ֲ����--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep UPDATE|awk -F"|" '{ print $2 }'|awk -F" " '{ print $2 }'|sort|uniq -c
#�����
#   1 MOBILE.THFUSER
#13434 MOBILE.THFUSERLTD
#  18 MOBILE.TSPEUSERLIST
#  30 MOBILE.TXEUSERLTD
#   1 UMPAY.T_HFWX_USER
   
#deleteʧ���޲�����
echo --------------ִ��DELETEʧ���޺��������ܼ�¼��--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep DELETE|wc -l
echo --------------ִ��DELETEʧ���޺���������ֲ����--------------
grep "|>" fail_sql.log.${FAIL_DATE}|grep DELETE|awk -F"|" '{ print $2 }'|awk -F" " '{ print $3 }'|sort|uniq -c
#�����
#   2 MOBILE.TSPEUSERLIST_06
echo ==========================================================
echo "  "
echo "  "

/db2data/monitor/umpayods_shell/sendsms/run.sh "15210870137" ${CONTEXT}
rm fail_sql.log.${FAIL_DATE}








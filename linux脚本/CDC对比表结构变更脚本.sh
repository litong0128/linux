#!/bin/ksh
. /home/db2inst1/sqllib/db2profile
#��ȡCDCͬ��Դ�ı��嵥��¼LIST_2

cd /home/cdc_home/cdc_home_651/bin
./dmmdcommander -I mbl187 < tbl.mbl187.sql >/home/db2inst1/monitor/LIST_2 2>&1

#ɨ����Ƿ���ڱ�ṹ���
#ȡԴ���������嵥��¼LIST_3
cd /home/db2inst1/monitor
db2 connect to MBL187 user ujfstatb using 3DetnFqz>/dev/null

echo "db connected "
db2 -x "select '10.10.1.185' as ip ,trim(TABSCHEMA) as schema,trim(TABNAME) as tablename, trim(char(ALTER_TIME)) as altertime from SYSCAT.TABLES  where substr(char(date(ALTER_TIME)),1,10) = substr(char(date(current timestamp)),1,10) and TABSCHEMA  not like 'SYS%'">LIST_3

db2 connect reset>/dev/null
echo `date +%Y%m%d%r`����������...>>alter.log
        #if����
        if test -s LIST_3
        then
        
                #�ȶ�LIST_2�б��ʱ���Ƿ���LIST_1�б��ʱ����ͬ,�õ����ʱ�䲻ͬ�ı��嵥LIST_TEMP_3
                awk -F" " 'NR==FNR{a[$2];b[$3];c[$2$3]=$4;next}{ if ($2 in a && $3 in b && c[$2$3]!=$4) print }' LIST_1  LIST_3 > LIST_TEMP_3            
                #if���ڲ�ͬ
                if test -s LIST_TEMP_3
                then
                        #��������¼��־alter.log
                        echo "`date +%Y%m%d%r`�������">>alter.log
                        awk -F" " '{print $1 " " $2 "." $3 " " $4 }' LIST_TEMP_3>>alter.log
                        #ɨ���жϱ����LIST_TEMP_3�Ƿ������CDCͬ����LIST_2����ͬ��
                        atlist=`awk -F" " 'NR==FNR{a[$2];b[$3];c[$2$3]=$4;next}{ if ($2 in a && $3 in b) print $2 "." $3 "  " }' LIST_2 LIST_TEMP_3`
                        #if����
                        if test "$atlist"
                        then
                                #������
                                alter= $atlist"��������뼰ʱ����CDCͬ������"
                                /home/db2inst1/monitor/sendsms/run.sh "15210870137" $alter
                                #���������ݼ�¼����־
                                echo `date +%Y%m%d%r` "|" $atlist��������뼰ʱ����CDCͬ������ >>alter.log
                                #��LIST_1�б�����ʱ�䣬ͬ������һֱ��ֹ���ζ���   
                                                        #������ı���ʱ���滻LIST_1�е�ʱ�������µ��ļ�LIST_TEMP_1
                                                        awk -F" " 'NR==FNR{a[$2];b[$3];c[$2$3]=$4;next}{if ($2 in a && $3 in b) $4=c[$2$3];print }' LIST_TEMP_3 LIST_1 > LIST_TEMP_1
                                                        #����Դ���嵥��¼LIST_1
                                                        cat LIST_TEMP_1 > LIST_1
                        fi
                fi
        fi
#else���ߵȴ��´�����
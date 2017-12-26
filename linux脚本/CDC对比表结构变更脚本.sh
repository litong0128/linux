#!/bin/ksh
. /home/db2inst1/sqllib/db2profile
#获取CDC同步源的表清单记录LIST_2

cd /home/cdc_home/cdc_home_651/bin
./dmmdcommander -I mbl187 < tbl.mbl187.sql >/home/db2inst1/monitor/LIST_2 2>&1

#扫描获是否存在表结构变更
#取源当天变更表清单记录LIST_3
cd /home/db2inst1/monitor
db2 connect to MBL187 user ujfstatb using 3DetnFqz>/dev/null

echo "db connected "
db2 -x "select '10.10.1.185' as ip ,trim(TABSCHEMA) as schema,trim(TABNAME) as tablename, trim(char(ALTER_TIME)) as altertime from SYSCAT.TABLES  where substr(char(date(ALTER_TIME)),1,10) = substr(char(date(current timestamp)),1,10) and TABSCHEMA  not like 'SYS%'">LIST_3

db2 connect reset>/dev/null
echo `date +%Y%m%d%r`任务检查启动...>>alter.log
        #if存在
        if test -s LIST_3
        then
        
                #比对LIST_2中变更时间是否与LIST_1中变更时间相同,拿到变更时间不同的表清单LIST_TEMP_3
                awk -F" " 'NR==FNR{a[$2];b[$3];c[$2$3]=$4;next}{ if ($2 in a && $3 in b && c[$2$3]!=$4) print }' LIST_1  LIST_3 > LIST_TEMP_3            
                #if存在不同
                if test -s LIST_TEMP_3
                then
                        #将变更表记录日志alter.log
                        echo "`date +%Y%m%d%r`变更表有">>alter.log
                        awk -F" " '{print $1 " " $2 "." $3 " " $4 }' LIST_TEMP_3>>alter.log
                        #扫描判断变更表LIST_TEMP_3是否存在于CDC同步表LIST_2中相同表
                        atlist=`awk -F" " 'NR==FNR{a[$2];b[$3];c[$2$3]=$4;next}{ if ($2 in a && $3 in b) print $2 "." $3 "  " }' LIST_2 LIST_TEMP_3`
                        #if存在
                        if test "$atlist"
                        then
                                #发短信
                                alter= $atlist"发生变更请及时更新CDC同步配置"
                                /home/db2inst1/monitor/sendsms/run.sh "15210870137" $alter
                                #将短信内容记录进日志
                                echo `date +%Y%m%d%r` "|" $atlist发生变更请及时更新CDC同步配置 >>alter.log
                                #改LIST_1中变更表的时间，同步更新一直防止二次短信   
                                                        #将变更的表日时间替换LIST_1中的时间生成新的文件LIST_TEMP_1
                                                        awk -F" " 'NR==FNR{a[$2];b[$3];c[$2$3]=$4;next}{if ($2 in a && $3 in b) $4=c[$2$3];print }' LIST_TEMP_3 LIST_1 > LIST_TEMP_1
                                                        #更新源表清单记录LIST_1
                                                        cat LIST_TEMP_1 > LIST_1
                        fi
                fi
        fi
#else休眠等待下次运行
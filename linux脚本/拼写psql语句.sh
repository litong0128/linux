#!/bin/bash
#define var
JQ_MONTH=$2
FILE_LINE=`cat $1|wc -l`
SPLIT_LINE=`expr $FILE_LINE / 3 + 1`

echo "文件总行数：${FILE_LINE}，分割文件行数：${SPLIT_LINE}"
echo "开始时间：`date`"
#split file to 3 per
split -l $SPLIT_LINE $1 lt_

#reading file to spell psql
for WH1 in `cat lt_aa`
do
	{
	MOBILE=`echo $WH1 | cut -c1-11`
	echo "insert into mcheck.mcheck (mobileid,checkdate,retcode,checkport,taskid,batchid) values('${MOBILE}','20${JQ_MONTH}','88',12353,1,'SLNG${JQ_MONTH}');">>tem1
	}&
done

for WH2 in `cat lt_ab`
do
	{
	MOBILE2=`echo $WH2 | cut -c1-11`
	echo "insert into mcheck.mcheck (mobileid,checkdate,retcode,checkport,taskid,batchid) values('${MOBILE}','20${JQ_MONTH}','88',12349,1,'SLNG${JQ_MONTH}');">>tem2
	}&
done

for WH3 in `cat lt_ac`
do
	{
	MOBILE3=`echo $WH3 | cut -c1-11`
	echo "insert into mcheck.mcheck (mobileid,checkdate,retcode,checkport,taskid,batchid) values('${MOBILE}','20${JQ_MONTH}','88',12351,1,'SLNG${JQ_MONTH}');">>tem3
	}&
done
wait
wc -l tem*
cat psqltemp* >> jqpsql.sql
echo "spelling completely!"
echo "结束时间：`date`"

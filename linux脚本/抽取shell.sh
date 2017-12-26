#!/bin/bash
#$1文件,$2起始随机数
TOTAL_ROW=`cat $1|wc -l`
RANDOM_ROW=`expr ${TOTAL_ROW} - $2`
INTERVAL=2
#求余的：
#echo $(($1 % $2))

#乘幂的：
#echo $(($1 ** $2))
#FOR_NUM=`echo $(($RANDOM_ROW % $INTERVAL))`
FOR_NUM=`echo $(($RANDOM_ROW / $INTERVAL))`
echo FOR_NUM=$FOR_NUM
echo TOTAL_ROW=$TOTAL_ROW
echo RANDOM_ROW=$RANDOM_ROW
#抽取文件
line=$2
for ((i=0; i<$FOR_NUM; ++i))
do  
	sed -n ${line},${line}p $1>>temp_result
	line=`expr $line + $INTERVAL`
	echo $line
done

#计算文件大小
echo 抽查文件大小
du -sh temp_result

#计算文件行数
echo 抽查的总记录数
wc -l temp_result



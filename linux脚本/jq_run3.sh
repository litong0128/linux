#!/bin/bash
#####################################
# describe：鉴权数据统计启动3       #
# author：litong                    #
# version：1.0                      #
# createdate：20140910              #
#####################################
#定义变量
LOG_PATH=/home/dwetl/log/sql
JQ_MONTH=$1
SBODY="鉴权作业重跑请求已成功发送！"
FBODY="鉴权作业重跑请求发送失败！"
COMBINFILE="合并文件失败！"
#FTP过来的文件位置
FTP_PATH1=/home/dwetl/data/in/${JQ_MONTH}01/ftp
#到etl作业加载的路径
JQ_EXTRACT_PATH=/home/dwetl/data/in/${JQ_MONTH}01/extract
#返回鉴权手机号结果文件名称
RETURN_FILE_NAME=fkresult_${JQ_MONTH}
#ftp鉴权服务器相关信息
FTP_SERVER="10.10.1.191 21"
FTP_PATH=/usr/mpsp/hfStlSvr/silent/check
FTP_USER=mpsp
FTP_PASS=mpsp4321
#定义ftp到鉴权服务器方法
function ftpTofk()
{
	ftp -v -n ${FTP_SERVER} <<EOF
    user ${FTP_USER} ${FTP_PASS}
    binary
    cd ${FTP_PATH}
    prom
    mget ${RETURN_FILE_NAME}.*
EOF
	
}

#合并鉴权结果文件到etl加载目录
cd ${FTP_PATH1}
ftpTofk
ls ${RETURN_FILE_NAME}.cfl
#判断控制文件是否存在如果存在进行合并，并发送重跑请求，并生成success.cfl文件
if [ $? -eq 0 ]
	then 
		cp ${RETURN_FILE_NAME}.txt ${JQ_EXTRACT_PATH}/umpayods_FILE_FK_RESULT_${JQ_MONTH}01.del
		if [ $? -ne 0 ]
			then 
			#告警短信添加++++++++++++++++++++
			sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $COMBINFILE
			echo "合并文件失败 退出！"
			exit
		fi
		touch ${FTP_PATH1}/fk_step3_${JQ_MONTH}.cfl
		wget http://10.101.1.62:8802/orcish/reload
		WEGTSTATE=`cat reload|grep -i "result"|awk -F">" '{print $2}'|cut -b 1`
		cat reload
		if [ $WEGTSTATE = S ]
			then
				echo "wget successed!"
				sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $SBODY
				#touch ${FTP_PATH1}/fk_step3_${JQ_MONTH}.cfl
			else
				echo "wget failed!"
				sh /home/dwetl/etlcenter/sms.sh "07" "13520587756;15210870137;15010129915" $FBODY
				cat reload > reload${JQ_MONTH}
				rm ${FTP_PATH1}/fk_step3_${JQ_MONTH}.cfl
		fi
		rm reload	
fi


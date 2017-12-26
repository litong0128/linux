#!/bin/bash
#####################################
# describe：鉴权数据统计启动2       #
# author：litong                    #
# version：1.0                      #
# createdate：20140910              #
#####################################
#定义变量
LOG_PATH=/home/dwetl/log/sql
JQ_MONTH=$1
SBODY="鉴权手机号已成功ftp到鉴权服务器！"
FBODY="鉴权手机号ftp到鉴权服务器失败！"
FEBODY="鉴权手机号比例抽取作业失败请处理！"
FTP_PATH1=/home/dwetl/data/in/${JQ_MONTH}01/ftp
#导出鉴权手机号文件路径和文件名称
EXPORT_PAHT=/home/dwetl/data/out/
FILE_NAME=NG`echo ${JQ_MONTH}|cut -b 3-6`
#ftp鉴权服务器相关信息
FTP_SERVER="10.10.1.191 21"
FTP_PATH=/usr/mpsp/hfStlSvr/silent/check
FTP_USER=mpsp
FTP_PASS=mpsp4321
#定义ftp到鉴权服务器方法
function ftpTofk()
{
	cd ${EXPORT_PAHT}
	/usr/bin/ftp -v -n ${FTP_SERVER} <<EOF>ftp.log
    user ${FTP_USER} ${FTP_PASS}
    binary
    cd ${FTP_PATH}
    prom
    put $1
EOF
	grep "226 File receive OK" ftp.log
	X=$?
	grep "send aborted" ftp.log
	Y=$?
	echo X:$X  Y:$Y 
	if [ $X -eq 0 -a $Y -ne 0 ]
		then
			echo ftp $1文件成功！
			return 0
		else
			echo ftp $1文件失败！
			return 1
	fi
}

#扫描日志判断作业是否完成
cd ${LOG_PATH}
#得到作业执行状态是否成功
STATE=`tail -1 T05_FK_RANDOM_CHECK_DTL_EVT_S_PD_T05_HF_REFUSE_TX_EVT_${JQ_MONTH}01.log|awk -F":" '{print $4}'|awk -F" " '{print $1}'`

#如果成功导出鉴权手机号
if [ $STATE = Successed ]
	then
		nzsql -u etl -pw data@umpay1234 -db pdata -host 10.101.1.163 -A -t -c "select distinct mobile_no from pdata.T05_FK_RANDOM_CHECK_DTL_EVT where fk_month='$JQ_MONTH'" -F , -o ${EXPORT_PAHT}${FILE_NAME}
		echo "导出鉴权手机号成功！导出条数"`wc -l ${EXPORT_PAHT}${FILE_NAME}`
		ftpTofk	${FILE_NAME}	
		if [ $? -eq 0 ]
			then 
				touch ${FILE_NAME}.cfl
				ftpTofk ${FILE_NAME}.cfl
				if [ $? -eq 0 ]
					then 
						sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $SBODY
						touch ${FTP_PATH1}/fk_step2_${JQ_MONTH}.cfl
					else
						sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $FBODY
				fi
			else
				sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $FBODY
		fi
	else
		echo "作业还未执行成功！"
		sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $FEBODY
		exit
fi

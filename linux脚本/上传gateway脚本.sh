#!/bin/bash
#####################################
# describe：打包gateway校验数据     #
# author：litong	                #
# version：1.0                      #
# createdate：20160303              #
# parameter： $1-服务名 $2-$n 被压缩文件  #
# createdate：20160303              #
#####################################
#引入配置文件
#. /home/shell/common
#定义变量
#定义ftp服务器相关
#ftp鉴权服务器相关信息
FTP_SERVER="132.35.244.114"
FTP_PATH="/"
FTP_USER=lit58@chinaunicom.cn
FTP_PASS=lt_13456
EXPORT_PAHT=`pwd`
#服务名
SERVER_NAME=$1
#定义从第二个开始到N个接收打包文件名称
FILE_NAME=""
FTP_FILE=""
#获取参数个数和所有参数值
parameter_num=$#
parameter_all=$*
#开始打包压缩文件
#echo ${parameter_all} | awk 'NF>1{print $NF}' | while read argment
for((i=2;i<=${parameter_num};i++)); do 
    argment=${!i}
	echo ${argment} "正在被压缩创建文件"
	mv ${argment} ${SERVER_NAME}-6-${argment}
	FILE_NAME=${SERVER_NAME}"-6-"${argment}
	echo ${argment} "改名为" ${FILE_NAME}
	echo "压缩文件" ${FILE_NAME}
	gzip ${FILE_NAME}
	echo "生成完成文件" "Done"-${FILE_NAME}
	touch "Done"-${FILE_NAME}
	FTP_FILE="${FTP_FILE} ${FILE_NAME}.gz Done-${FILE_NAME}"
done
echo "FTP_FILE= ${FTP_FILE}"
#定义ftp到gateway方法

function ftpTogt()
{
	cd ${EXPORT_PAHT}
	/usr/bin/ftp -v -n ${FTP_SERVER} <<EOF>ftp.log
    user ${FTP_USER} ${FTP_PASS}
    binary
    cd ${FTP_PATH}
    prom
    mput $*
EOF
	grep "Transfer complete" ftp.log
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


ftpTogt ${FTP_FILE}
if [ $? -eq 0 ]
	then
	echo "ftp获取数据文件完成" 
	else
	echo "ftp获取数据文件失败"
fi 
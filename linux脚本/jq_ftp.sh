#!/bin/bash
#####################################
# describe：鉴权文件同步到etl服务器 #
# author：litong                    #
# version：1.0                      #
# createdate：20140910              #
#####################################
#定义变量
JQ_UPLOAD_PATH=/home/resin/resin-pro-3.1.12/webapps/product/upload/fk_auth_upload/
BODY="ftp鉴权文件到亦庄etlf服务器错误,请排查问题！"
#文件模式
FILE_REGEX="mer_auth_ratio_*.txt"

#获取鉴权月份
JQ_MONTH=`/usr/bin/find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1|head -1|awk -F"/" '{print $NF}'|awk -F"_" '{print $4}'`

#无密认证登陆用户
SSH_USER="dwetl@10.101.1.62"

#ftp到etl作业加载的路径
FTP_PATH=/home/dwetl/data/in/${JQ_MONTH}01/ftp/

#检查文件本期文件是否已经ftp到指定服务器如果已经生成控制文件，则推出
cd ${JQ_UPLOAD_PATH}
ls mw${JQ_MONTH}_jq.cfl
if [ $? -eq 0 ]
	then
		exit
fi 

#移动被拒文件到指定目录
/usr/bin/find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1 -exec scp {} ${SSH_USER}:${FTP_PATH} \;

#生成控制文件ftp到etl服务器
if [ $? -eq 0 ]
	then   
		echo `/usr/bin/find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1|wc -l` > mw${JQ_MONTH}_jq.cfl
		scp mw${JQ_MONTH}_jq.cfl ${SSH_USER}:${FTP_PATH}
	else
		sh /home/resin/Function/sms.sh "13520587756;15210870137;15801157747" $BODY
fi

#测试目录输出
echo $JQ_UPLOAD_PATH ---$FILE_REGEX---$JQ_MONTH  ---$FTP_PATH  ---$SSH_USER

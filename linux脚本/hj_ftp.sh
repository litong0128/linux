#!/bin/bash
#####################################
# describe：核减文件同步到62        #
# author：litong                    #
# version：1.0                      #
# createdate：20140905              #
#####################################
#定义变量
HJ_UPLOAD_PATH=/home/resin/resin-pro-3.1.12/webapps/product/upload/hj_dtl_upload
BODY="ftp核减文件到亦庄etlf服务器错误,请排查问题！"
#文件模式
FILE_REGEX="mw*.txt"

#获取鉴权月份
HJ_MONTH=`/usr/bin/find ${HJ_UPLOAD_PATH} -name ${FILE_REGEX} -mtime -1|head -1|awk -F"/" '{print $NF}'|cut -b 3-8`

#无密认证登陆用户
SSH_USER="dwetl@10.101.1.62"

#ftp到etl作业加载的路径
FTP_PATH=/home/dwetl/data/in/${HJ_MONTH}01/ftp/

#移动被拒文件到指定目录
/usr/bin/find ${HJ_UPLOAD_PATH} -name ${FILE_REGEX} -mtime -1 -exec scp {} ${SSH_USER}:${FTP_PATH} \;

#生成控制文件ftp到etl服务器
if [ $? -eq 0 ]
	then   
		echo `/usr/bin/find ${HJ_UPLOAD_PATH} -name ${FILE_REGEX} -mtime -1|wc -l` > mw${HJ_MONTH}_hj.cfl
		scp mw${HJ_MONTH}_hj.cfl ${SSH_USER}:${FTP_PATH}
	else
		sh /home/resin/Function/sms.sh "13520587756;15210870137;15801157747" $BODY
fi

#测试目录输出
#echo $HJ_UPLOAD_PATH ---$FILE_REGEX---$HJ_MONTH  ---$FTP_PATH  ---$SSH_USER

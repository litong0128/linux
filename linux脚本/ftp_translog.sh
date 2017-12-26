#!/bin/bash
###############################################################################
#    文件名  :    ftp_translog.sh                                             #
#    功  能  :    处理推送交易流水数据脚本                                      #
#    编  写  :    李童                                                        #
#    修  改  :                                                                #
#    时  间  :    2017-12-06                                                  #
#    版  权  :    litong                                                      #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :    			                                                #
#    说  明  :                                                                #
###############################################################################
#定义变量
LAST_DATE=`date -d "1 days ago" +%Y-%m-%d`
#定义日志文件前缀
FILE_PRE_NAME='transaction.log'
#定义处理后的日志文件名称
FILE_NEW_NAME='transaction.new.'${LAST_DATE}

#ftp相关配置
INPORT_PAHT="/trans"
FTP_USER="tas_usr"
FTP_PASS="?1mbpBRd7"
FTP_SERVER="192.168.20.21"

ISPUT=1
echo `date -d +%Y-%m-%d`'ftp任务开始....' >> ftp_translog.log
echo '新数据文件名:'${FILE_NEW_NAME} >> ftp_translog.log
#筛选t-1日的数据流水生成新的文件格式transaction.new.yyyy-mm-dd文件
ls transaction.log.${LAST_DATE}|xargs awk -F '- ' '{print $NF}' >> ${FILE_NEW_NAME}

#推送数据到ftp服务器
function ftpPut()
{
	cd ${INPORT_PAHT}
	/usr/bin/ftp -v -n ${FTP_SERVER} <<EOF>ftp.log
    user ${FTP_USER} ${FTP_PASS}
    binary
    prom
    mput $@
EOF
	grep "Transfer complete" ftp.log
	X=$?
	grep "send aborted" ftp.log
	Y=$?
	echo X:$X  Y:$Y 
	if [ $X -eq 0 -a $Y -ne 0 ]
		then
			ISPUT=0
			echo ftp $1文件成功！
			return 0
		else
			ISPUT=1
			echo ftp $1文件失败！
			return 1
	fi
}

#调用ftp方法
while [ ${ISPUT} -eq 1 ]
do
	echo "`date` 文件未成功等待10秒钟继续执行"> ftp.log
	sleep 10s
	ftpPut ${FILE_NEW_NAME}
done 

echo `date -d +%Y-%m-%d`'ftp任务结束....' >> ftp_translog.log
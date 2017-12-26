#!/bin/bash
###############################################################################
#    文件名  :    get_tas_data.sh                                             #
#    功  能  :    获取ftp数据                                         		  #
#    编  写  :    李童                                                        #
#    修  改  :                                                                #
#    时  间  :    2016-12-06                                                  #
#    版  权  :    litong                                                      #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :    			                                                  #
#    说  明  :                                                                #
###############################################################################
#ftp ip:192.168.20.21
#user:tas_usr
#passwd:?1mbpBRd7
#定义变量
EXPORT_PAHT="/DXP/DATA/TAS"
FTP_USER="tas_usr"
FTP_PASS="?1mbpBRd7"
FTP_SERVER="192.168.20.21"
#设定文件名前缀前部分
PRE1="TAS_TRADE_"
PRE2="TAS_BUSINESS_"
SUF=".txt"
ISGET=1

if [ ! -n "$1" ]
	then
		DATE=`date +%Y%m%d`
	else
		DATE=$1
fi

FILE="${PRE1}${DATE}${SUF} ${PRE1}${DATE}${SUF}.done ${PRE2}${DATE}${SUF} ${PRE2}${DATE}${SUF}.done"
echo ${FILE}
#定义ftp方法
function ftpGet()
{
	cd ${EXPORT_PAHT}
	/usr/bin/ftp -v -n ${FTP_SERVER} <<EOF>ftp.log
    user ${FTP_USER} ${FTP_PASS}
    binary
    prom
    mget $@
EOF
	grep "Transfer complete" ftp.log
	X=$?
	grep "send aborted" ftp.log
	Y=$?
	echo X:$X  Y:$Y 
	if [ $X -eq 0 -a $Y -ne 0 ]
		then
			ISGET=0
			echo ftp $1文件成功！
			return 0
		else
			ISGET=1
			echo ftp $1文件失败！
			return 1
	fi
}

while [ ${ISGET} -eq 1 ]
do
	echo "`date` 文件未成功等待10秒钟继续执行"> ftp.log
	sleep 10s
	ftpGet ${FILE}
done 



#!/bin/bash
#####################################
# describe：核减数据统计启动        #
# author：litong                    #
# version：1.0                      #
# createdate：20140905              #
#####################################
#定义变量
HJ_UPLOAD_PATH=/home/dwetl/data/in
SBODY="wget发送请求核减重跑作业成功！"
FBODY="wget发送请求失败请检查！"
#文件模式
FILE_REGEX="mw*.txt"

#获取鉴权月份
HJ_MONTH=`find ${HJ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1|head -1|awk -F"/" '{print $NF}'|cut -b 3-8`

#FTP过来的文件位置
FTP_PATH=/home/dwetl/data/in/${HJ_MONTH}01/ftp

#到etl作业加载的路径
HJ_EXTRACT_PATH=/home/dwetl/data/in/${HJ_MONTH}01/extract

#检查控制文件是否存在，存在继续运行，不存在退出程序
cd ${FTP_PATH}
ls mw${HJ_MONTH}_hj.cfl
if [ $? -ne 0 ]
	then 
		echo 控制文件${HJ_MONTH}_hj.cfl不存在！
		exit
fi

#合并核减文件到作业加载目录
echo $HJ_MONTH
 
find ${HJ_UPLOAD_PATH} -name "mw*.txt" -mtime -1 -exec cat {} \;|awk '{print '"${HJ_MONTH}"' "," $1}'> ${HJ_EXTRACT_PATH}/umpayods_F
ILE_HJ_MOBILE_DTL_${HJ_MONTH}01.del

#调用调度程序接口启动重跑
#http://127.0.0.1:8802/orcish/rerun?datatime=20140630000000\&type=group\&id=YXB_DAY_GRP\&cycnum=1· 
#http://10.101.1.62:8802/orcish/reload
wget http://10.101.1.62:8802/orcish/reload
WEGTSTATE=`cat reload|grep -i "result"|awk -F">" '{print $2}'|cut -b 1`
cat reload
if [ $WEGTSTATE = S ]
	then
		echo "wget successed!"
		sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $SBODY
		
	else
		echo "wget failed!"
		sh /home/dwetl/etlcenter/sms.sh "07" "13520587756;15210870137;15010129915" $FBODY
		cat reload > reload${HJ_MONTH}
fi
rm reload
#测试目录输出
#echo $HJ_UPLOAD_PATH ---$FILE_REGEX---$HJ_MONTH  ---$FTP_PATH  ---$HJ_EXTRACT_PATH
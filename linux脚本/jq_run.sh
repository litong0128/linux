#!/bin/bash
#####################################
# describe：鉴权数据统计启动1       #
# author：litong                    #
# version：1.0                      #
# createdate：20140910              #
#####################################
#定义变量
JQ_UPLOAD_PATH=/home/dwetl/data/in
SBODY="wget发送请求鉴权重跑作业成功！"
FBODY="wget发送请求鉴权重跑作业失败请检查！"
#文件模式
FILE_REGEX="mer_auth_ratio_*.txt"

#获取鉴权月份
JQ_MONTH=`cat JQ_MONTH.cfl`
JQ_MONTH_TEMP=`date +%Y%m --date="-1 month"`
if [ $JQ_MONTH != $JQ_MONTH_TEMP ]
	then
	JQ_MONTH=`find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1|head -1|awk -F"/" '{print $NF}'|awk -F"_" '{print $4}'`
	if [ -z $JQ_MONTH ]
        then exit
    fi
fi
echo $JQ_MONTH > JQ_MONTH.cfl

#FTP过来的文件位置
FTP_PATH=/home/dwetl/data/in/${JQ_MONTH}01/ftp

#到etl作业加载的路径
JQ_EXTRACT_PATH=/home/dwetl/data/in/${JQ_MONTH}01/extract

function run()
{
#合并核减文件到作业加载目录
echo $JQ_MONTH
 
find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1 -exec cat {} \;|awk '{print '"${JQ_MONTH}"' "," $1}'> ${JQ_EXTRACT_PATH}/umpayods_FILE_MER_AUTH_RATIO_${JQ_MONTH}01.del

#调用调度程序接口启动重跑
#http://127.0.0.1:8802/orcish/rerun?datatime=20140630000000\&type=group\&id=YXB_DAY_GRP\&cycnum=1
#http://10.101.1.62:8802/orcish/reload
#wget http://10.101.1.62:8802/orcish/reload
wget http://127.0.0.1:8802/orcish/rerun?datatime=${JQ_MONTH}01000000\&type=group\&id=HF_FK_GEN_RENDOM_DTL_MONTH_GRP\&cycnum=1
cat "rerun?datatime=${JQ_MONTH}01000000&type=group&id=HF_FK_GEN_RENDOM_DTL_MONTH_GRP&cycnum=1">reload
WEGTSTATE=`cat reload|grep -i "result"|awk -F">" '{print $2}'|cut -b 1`
cat reload
if [ $WEGTSTATE = S ]
	then
		echo "wget successed!"
		sh /home/dwetl/etlcenter/sms.sh "07" "15210870137" $SBODY
		#生成控制文件1
		touch ${FTP_PATH}/fk_step1_${JQ_MONTH}.cfl
	else
		echo "wget failed!"
		sh /home/dwetl/etlcenter/sms.sh "07" "13520587756;15210870137;15010129915" $FBODY
		cat reload > reload${JQ_MONTH}
fi
#rm reload
echo ""
echo ================================`date`==================================
echo ""
}
#测试目录输出
#echo $JQ_UPLOAD_PATH ---$FILE_REGEX---$JQ_MONTH  ---$FTP_PATH  ---$JQ_EXTRACT_PATH


#检查控制文件是否存在，存在继续运行，不存在退出程序
cd ${FTP_PATH}
ls mw${JQ_MONTH}_jq.cfl
if [ $? -eq 0 ]
	then 
		#检查程序本月鉴权手机号作业是否已经完成
		cd ${FTP_PATH}
		ls fk_step1_${JQ_MONTH}.cfl
		if [ $? -eq 0 ]
			then
				echo 控制文件fk_step1_${JQ_MONTH}.cfl存在,本月鉴权手机号作业已完成！
				#检查程序ftp鉴权手机号是否已经完成
				cd ${FTP_PATH}
				ls fk_step2_${JQ_MONTH}.cfl
				if [ $? -eq 0 ]
					then 
						echo 控制文件fk_step2_${JQ_MONTH}.cfl存在,本月ftp鉴权手机号已完成！
						#检查程序本月鉴权作业是否已经完成
						cd ${FTP_PATH}
						ls fk_step3_${JQ_MONTH}.cfl 
						if [ $? -eq 0 ]
							then 
								echo 控制文件fk_step3_${JQ_MONTH}.cfl存在,本月鉴权已完成,程序退出！
								exit
							else	
								#调用脚本获取鉴权手机号，重泡作业
								cd /home/dwetl/bin
								./jq_run3.sh ${JQ_MONTH}
						fi					
					else
						#调用脚本ftp鉴权手机号到鉴权服务器
						cd /home/dwetl/bin
						./jq_run2.sh ${JQ_MONTH}		
				fi
			else
				run		
		fi
	else
		echo 控制文件mw${JQ_MONTH}_jq.cfl不存在！
		exit
fi




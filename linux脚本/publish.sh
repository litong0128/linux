#!/bin/bash
###############################################################################
#    文件名  :    public.sh                                                   #
#    功  能  :    公共函数、参数定义程序                                      #
#    编  写  :    王旭辉                                                      #
#    修  改  :                                                                #
#    时  间  :    2011-12-19                                                  #
#    版  权  :    ISOFTSTONE                                                  #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :    			                                                      #
#    说  明  :                                                                #
###############################################################################
#程序主目录
ETL_MAIN_PATH=$ETL_MAIN_PATH
unset LD_PRELOAD
#设置配置文件的路径
	cfg="${ETL_MAIN_PATH}/cfg/config.ini"
	NZ_HOST=`grep "NZ_HOST" $cfg|cut -d'=' -f2`
	schema=`grep "UMP_REP_SCHEMA" $cfg|cut -d'=' -f2`
#当前时间
  curr_time1="`date +"%Y-%m-%d %H:%M:%S"`"
  curr_time2="`date +%Y%m%d%H%M%S`"
#####################################
#函数名：_Mesg
#功能描述：记录日志信息
#输入参数: Message
#返回值:0 成功 1 失败
#####################################
_Mesg()
{
    v_sTime=`date +"%Y%m%d %H:%M:%S"`

    if [ $# != 1 ]
    then
        echo "${v_sTime} $0 Error:   参数调用错误..."
        return 1
    fi

    echo "${v_sTime} $0 Messages:  $1"

    return 0
}

#####################################
#函数名：getRepDBPara
#功能描述：获取资料库配置信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getRepDBPara()
{
	UMP_REP_HOST=`grep "UMP_REP_HOST" $cfg|cut -d'=' -f2`
	UMP_REP_DBNAME=`grep "UMP_REP_DBNAME" $cfg|cut -d'=' -f2`
	UMP_REP_DBUSER=`grep "UMP_REP_DBUSER" $cfg|cut -d'=' -f2`
	UMP_REP_DBPWD=`grep "UMP_REP_DBPWD" $cfg|cut -d'=' -f2`
	UMP_REP_NODE=`grep "UMP_REP_NODE" $cfg|cut -d'=' -f2`
	UMP_REP_PORT=`grep "UMP_REP_PORT" $cfg|cut -d'=' -f2`
	if [ -z $UMP_REP_HOST ] || [ -z $UMP_REP_DBNAME ] || [ -z $UMP_REP_DBUSER ] || [ -z $UMP_REP_DBPWD ] || [ -z $UMP_REP_NODE ] || [ -z $UMP_REP_PORT ];then
	  _Mesg "Get Rep Parameter Failed,Exit...."|tee -a $logfile
	   exit 10
	fi
	_Mesg "Get Rep Parameter Successed"|tee -a $logfile
}
#####################################
#函数名：getOdsDBPara
#功能描述：获取ods核心库信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getOdsDBPara()
{
	UMP_ODS_HOST=`grep "UMP_ODS_HOST" $cfg|cut -d'=' -f2`
	UMP_ODS_DBNAME=`grep "UMP_ODS_DBNAME" $cfg|cut -d'=' -f2`
	UMP_ODS_DBUSER=`grep "UMP_ODS_DBUSER" $cfg|cut -d'=' -f2`
	UMP_ODS_DBPWD=`grep "UMP_ODS_DBPWD" $cfg|cut -d'=' -f2`
	UMP_ODS_PORT=`grep "UMP_ODS_PORT" $cfg|cut -d'=' -f2`
	UMP_ODS_NODE=`grep "UMP_ODS_NODE" $cfg|cut -d'=' -f2`
		if [ -z $UMP_ODS_HOST ] || [ -z $UMP_ODS_DBNAME ] || [ -z $UMP_ODS_DBUSER ] || [ -z $UMP_REP_DBPWD ] || [ -z $UMP_REP_NODE ] || [ -z $UMP_REP_PORT ];then
	   _Mesg "Get ODS Parameter Failed,exit"|tee -a $logfile
	   exit 20
	fi
	_Mesg "Get ODS Parameter Successed"|tee -a $logfile
}

#####################################
#函数名：getDcpDBPara
#功能描述：获取Dcp库信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getDcpDBPara()
{
	UMP_DCP_HOST=`grep "UMP_DCP_HOST" $cfg|cut -d'=' -f2`
	UMP_DCP_DBNAME=`grep "UMP_DCP_DBNAME" $cfg|cut -d'=' -f2`
	UMP_DCP_DBUSER=`grep "UMP_DCP_DBUSER" $cfg|cut -d'=' -f2`
	UMP_DCP_DBPWD=`grep "UMP_DCP_DBPWD" $cfg|cut -d'=' -f2`
	UMP_DCP_PORT=`grep "UMP_DCP_PORT" $cfg|cut -d'=' -f2`
	UMP_DCP_NODE=`grep "UMP_DCP_NODE" $cfg|cut -d'=' -f2`
		if [ -z $UMP_DCP_HOST ] || [ -z $UMP_DCP_DBNAME ] || [ -z $UMP_DCP_DBUSER ] || [ -z $UMP_DCP_DBPWD ] || [ -z $UMP_DCP_NODE ] || [ -z $UMP_DCP_PORT ];then
	   _Mesg "Get DCP Parameter Failed,exit"|tee -a $logfile
	   exit 20
	fi
	_Mesg "Get DCP Parameter Successed"|tee -a $logfile
}

#####################################
#函数名：getSLOADDBPara
#功能描述：获取sload层的db信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getSLOADDBPara()
{	
	UMP_SDATA_DBNAME=`grep "UMP_SDATA_DBNAME" $cfg|cut -d'=' -f2`
	UMP_SDATA_DBUSER=`grep "UMP_SDATA_DBUSER" $cfg|cut -d'=' -f2`
	UMP_SDATA_DBPWD=`grep "UMP_SDATA_DBPWD" $cfg|cut -d'=' -f2`
	if [ -z $UMP_SDATA_DBNAME ] || [ -z $UMP_SDATA_DBUSER ] || [ -z $UMP_SDATA_DBPWD ];then
	   _Mesg "Get SD Parameter Failed,exit"|tee -a $logfile
	   exit 30
	fi
}
#####################################
#函数名：getPDATADBPara
#功能描述：获取pload 层的db信息
#输入参数
#返回值:0 成功 1 失败
####################################
function getPDATADBPara()
{
	UMP_PDATA_DBNAME=`grep "UMP_PDATA_DBNAME" $cfg|cut -d'=' -f2`
	UMP_PDATA_DBUSER=`grep "UMP_PDATA_DBUSER" $cfg|cut -d'=' -f2`
	UMP_PDATA_DBPWD=`grep "UMP_PDATA_DBPWD" $cfg|cut -d'=' -f2`
	if [ -z $UMP_PDATA_DBNAME ] || [ -z $UMP_PDATA_DBUSER ] || [ -z $UMP_PDATA_DBPWD ];then
	   _Mesg "Get PD Parameter Failed,exit"|tee -a $logfile
	   exit 42
	fi
}
#####################################
#函数名：getSUMDBPara
#功能描述：获取sum层db的信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getSUMDBPara()
{
	UMP_SUM_DBNAME=`grep "UMP_SUM_DBNAME" $cfg|cut -d'=' -f2`
	UMP_SUM_DBUSER=`grep "UMP_SUM_DBUSER" $cfg|cut -d'=' -f2`
	UMP_SUM_DBPWD=`grep "UMP_SUM_DBPWD" $cfg|cut -d'=' -f2`
	if [ -z $UMP_SUM_DBNAME ] || [ -z $UMP_SUM_DBUSER ] || [ -z $UMP_SUM_DBPWD ];then
	   _Mesg "Get SUM Parameter Failed,exit"|tee -a $logfile
	   exit 40
	fi
}
#####################################
#函数名：getQTDBPara
#功能描述：数据清洗层db信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getQTDBPara()
{
	UMP_QT_DBNAME=`grep "UMP_QT_DBNAME" $cfg|cut -d'=' -f2`
	UMP_QT_DBUSER=`grep "UMP_QT_DBUSER" $cfg|cut -d'=' -f2`
	UMP_QT_DBPWD=`grep "UMP_QT_DBPWD" $cfg|cut -d'=' -f2`
}
#####################################
#函数名：getExtDBPara
#功能描述：数据提取信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getExtDBPara()
{
	UMP_EXT_DBNAME=`grep "UMP_EXT_DBNAME" $cfg|cut -d'=' -f2`
	UMP_EXT_DBUSER=`grep "UMP_EXT_DBUSER" $cfg|cut -d'=' -f2`
	UMP_EXT_DBPWD=`grep "UMP_EXT_DBPWD" $cfg|cut -d'=' -f2`
}
#####################################
#函数名：getHostPara
#功能描述：查询ftp服务器配置信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getHostPara()
{
	UMP_HOSTIP=`grep "UMP_${FTPHOST}_IP" $cfg|cut -d'=' -f2`
	UMP_HOSTUSER=`grep "UMP_${FTPHOST}_NAME" $cfg|cut -d'=' -f2`
	UMP_HOSTPWD=`grep "UMP_${FTPHOST}_PWD" $cfg|cut -d'=' -f2`
}
#####################################
#函数名：getScpPara
#功能描述：获取scp传送的用户名和IP
#输入参数
#返回值
#####################################
function getScpPara()
{
	UMP_SCP_USER=`grep "UMP_SCP_USER" $cfg|cut -d'=' -f2`
	UMP_SCP_HOST=`grep "UMP_SCP_HOST" $cfg|cut -d'=' -f2`
	UMP_SCP_USER=`echo $UMP_SCP_USER`
}
#####################################
#函数名：getStartEndTime
#功能描述：根据作业名字返回查询sql的where 条件的开始时间time1和结束时间time2 格式"yyyy-MM-dd hh:mi:ss"
#输入参数:EXP_JOB_NAME
#返回值:0 成功 1 失败
#####################################
function getStartEndTime()
{
		if [ $# -gt 1 ]; then
    	echo "Usage: sh public.sh  getStartEndTime"
    	exit -1
		fi
#作业名称
	EXP_JOB_NAME=$1	
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  fretype=`db2 -x "select frequency_type from ${schema}.OPB_JOB_INFO_EX where job_id='${EXP_JOB_NAME}' with ur"`
  re_flag=$?
 # db2 quit > /dev/null 2>&1
  fretype=`echo $fretype`
  _Mesg "the Frequency type is ${fretype} "|tee -a $logfile
  if [ $re_flag -eq 0 ];then
    if [ $fretype -eq 3 ] ;	then 		
		   SQL="select to_char(next_time-frequency months,'yyyy-MM-dd hh24:mi:ss') from ${schema}.OPB_JOB_INFO_EX where job_id='$EXP_JOB_NAME'  with ur"
	  elif [ $fretype -eq 2 ]; then
		   SQL="select to_char(next_time-frequency days,'yyyy-MM-dd hh24:mi:ss') from ${schema}.OPB_JOB_INFO_EX  where job_id='$EXP_JOB_NAME'  with ur"
		elif [ $fretype -eq 1 ]; then
		   SQL="select to_char(next_time-frequency hours,'yyyy-MM-dd hh24:mi:ss') from ${schema}.OPB_JOB_INFO_EX  where job_id='$EXP_JOB_NAME'  with ur"		
		elif [ $fretype -eq 0 ]; then
		   SQL="select to_char(next_time-frequency seconds,'yyyy-MM-dd hh24:mi:ss') from ${schema}.OPB_JOB_INFO_EX  where job_id='$EXP_JOB_NAME'  with ur"																					
    fi
  fi
	#起始时间
	db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
	start_time=`db2 -x "$SQL"`
	if [ $? -ne 0 ];then 
	  re_flag=-1
	fi
	db2 quit > /dev/null 2>&1
	start_time=`echo $start_time`	
	#结束时间
	db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
	end_time=`db2 -x "select to_char(next_time,'yyyy-MM-dd hh24:mi:ss') from ${schema}.OPB_JOB_INFO_EX  where job_id='$EXP_JOB_NAME' with ur"`
	if [ $? -ne 0 ];then 
	  re_flag=-1
	fi
	db2 quit > /dev/null 2>&1
	end_time=`echo $end_time`
	if [ $re_flag -eq 0 ];then
	 _Mesg "Get Start_time and End_time Successed"|tee -a $logfile
	 return 0
	 else
	 _Mesg "Get Start_time and End_time,Exit..."|tee -a $logfile
	 return 22
	fi
}

#####################################
#函数名：
#功能描述：根据作业名查询操作表的信息
#输入参数
#返回值:0 成功 1 失败
#####################################
function getTableInfo()
{
#定义返回值
  re_flag=0
#查询表ID	
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
	tbid=`db2 -x "select TABLE_ID from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_NAME}' with ur"`
 	if [  $? -ne 0 ] ;then
   re_flag=-1
	fi
	tbid=`echo $tbid`
  _Mesg "Get the Table Info TABLE_ID:${tbid}"|tee -a $logfile
  
 #查询表名称
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  tbname=`db2 -x "select SOUTB_NAME from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_NAME}' with ur"`
 	if [  $? -ne 0 ] ;then
   re_flag=-2
	fi
	tbname=`echo $tbname`
  _Mesg "Get the Table Info SOUTB_NAME:${tbname}"|tee -a $logfilee

#查询表的条件
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  tbcon=`db2 -x "select CONDITION from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_NAME}' with ur"`
 	if [  $? -ne 0 ] ;then
   re_flag=-3
	fi
	tbcon=`echo $tbcon`
  _Mesg "Get the Table Info Condition:${tbcon}"|tee -a $logfilee
  #查询目标表
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  tar_table=`db2 -x "select TARTB_NAME from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_NAME}' with ur"`
 	if [  $? -ne 0 ] ;then
   re_flag=-4
	fi
	  tar_table=`echo $tar_table`
  _Mesg "Get the Table Info Condition:${tbcon}"|tee -a $logfilee
  #判断查询表信息是否有错误
	if [ $re_flag -eq 0 ] ;then
	 _Mesg "Get the Table Infomation Successed"|tee -a $logfile
	 return 0
	 else
	 _Mesg "Get the Table Infomation Failed,Exit With Code 22......"|tee -a $logfile
	 exit 22
	fi
}
#####################################
#函数名：getTableCol
#功能描述：根据tbid 去查询 column
#输入参数
#返回值:0 成功 1 失败
#####################################
function getTableCol()
{
	_Mesg "Start To Query Table Column"|tee -a $logfile
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  tb_column=`db2 -x "select  SOUTB_CLM_NAME||' ,' from ${schema}.OPB_METADATA_COLUMN_EX where TABLE_ID=${tbid} order by COLUMN_ID with ur"`
  re_flag=$?
  db2 quit > /dev/null 2>&1
	#删除最后一个 “,”
  tb_column=${tb_column%,*}
	if [ $re_flag -eq 0 ] ;then
	 _Mesg "Get the Table Column Successed"|tee -a $logfile
	 return 0
	 else
	 _Mesg "Get the Table Column Failed,Exit With Code 23..."|tee -a $logfile
	 exit 23
	fi
}
#####################################
#函数名：creTableSql
#功能描述：创建表的sql
#输入参数
#返回值:0 成功 1 失败
#####################################
function creTableSql()
{
#查询建表语句的目标表名
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  tartb_name=`db2 -x "select rtrim(TARTB_NAME) from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_NAME}' with ur"`
  re_flag=$?	
  db2 quit > /dev/null 2>&1	
  tartb_name=`echo $tartb_name`
#查询建表语句的字段
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
  col_val=`db2 -x "select rtrim(TARTB_CLM_NAME),rtrim(TYPE)||',' from ${schema}.OPB_METADATA_COLUMN_EX where TABLE_ID=${tbid} order by COLUMN_ID "`
  re_flag=$?	
  db2 quit > /dev/null 2>&1	
	col_val=${col_val%,*}
#拼装建表sql
	cre_sql="create table ${tartb_name}_$ETL_DATE  ("${col_val}" )"
	_Mesg "Create Table sql :${cre_sql}"|tee -a $logfile
#判断是否有错误
	if [ $re_flag -eq 0 ] ;then
	 _Mesg "Get Create Table sql Successed"|tee -a $logfile
	 return 0
	 else
	 _Mesg "Get Create Table sql Failed,Exit With Code 32..."|tee -a $logfile
	 exit 32
	fi
}
 
function getAppFilePath()
{
 fxq_jobname=`echo ${EXP_JOB_NAME}|cut -d '_' -f 1`
 path=`grep "${fxq_jobname}" $cfg|cut -d '=' -f2`
}

#####################################
#函数名：createTable
#功能描述: 在Sdata层创建表
#输入参数
#返回值:0 成功 1 失败
#####################################
function createTable()
{
	#根据sql 创建表
	_Mesg "Start To Nzsql To Create Table"|tee -a $logfile
	#执行netezza库中建表
	nzsql -u ${UMP_SDATA_DBUSER} -pw ${UMP_SDATA_DBPWD}  -d ${UMP_SDATA_DBNAME} -host ${NZ_HOST} <<-EOF>> ${logfile}
	\set ON_ERROR_STOP
	BEGIN;
	exec DROP_IF_EXISTS('${tartb_name}_${ETL_DATE}');
	$cre_sql;
	commit;
	EOF
	re_flag=$?
#判断建表是否有错误
	if [ $re_flag -eq 0 ] ;then
	 _Mesg "Create Table Successed"|tee -a $logfile
	 return 0
	 else
	 _Mesg "Create Table Failed,Exit With Code 33......"|tee -a $logfile
	 exit 33
	fi
}

#####################################
#函数名：jobIsExit
#功能描述：判断作业名字是否存在
#输入参数: job_id
#返回值:0 成功 1 失败
#####################################
function IsConnect()
{
  ping -c 2 $UMP_REP_HOST
  	if [ $? -ne 0 ] ;then
			_Mesg "Unable To Connect To ${UMP_REP_HOST},Please Check Your Network"|tee -a $logfile
			exit -1
	  fi
  #第一次连接数据库判断连接资料库是否有问题
  db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " 
  if [ $? -ne 0 ];then
      _Mesg "Connect to Rep DB Failed,Exit......"|tee -a $logfile
      exit 17
  fi
}
#####################################
#函数名：getConnDBExpData
#功能描述：连接数据库卸数
#输入参数:
#返回值:0 成功 1 失败
#####################################
function getConnDBExpData()
{
		ping -c 2 $UMP_ODS_HOST
		if [ $? -ne 0 ] ;then
			_Mesg "Unable To Connect To ${UMP_ODS_HOST},Please Check Your Network"|tee -a $logfile
			return -1
		else
			#连接数据库，从ods卸载数据
			_Mesg "Start To Connect To Database Export Data"|tee -a $logfile
			db2 connect to ${UMP_ODS_DBNAME} user ${UMP_ODS_DBUSER} using ${UMP_ODS_DBPWD} 
		  db2 "export to ${filepath}/${exp_file} of del modified by nochardel codepage=1208 coldel0x07  ${select_sql} " >>$logfile 2>&1 
		  if [ $? -eq 0 ];then
		   return 0
		  else
		  _Mesg "Export Data Failed,Exit With Code 24..."|tee -a $logfile
		   exit 24
		  fi
		fi
}

#####################################
#函数名：getConnDCPExpData
#功能描述：连接数据库卸数
#输入参数:
#返回值:0 成功 1 失败
#####################################
function getConnDCPExpData()
{
		ping -c 2 $UMP_DCP_HOST
		if [ $? -ne 0 ] ;then
			_Mesg "Unable To Connect To ${UMP_DCP_HOST},Please Check Your Network"|tee -a $logfile
			return -1
		else
			#连接数据库，从dcp5卸载数据
			_Mesg "Start To Connect To Database Export Data"|tee -a $logfile
			db2 connect to ${UMP_DCP_DBNAME} user ${UMP_DCP_DBUSER} using ${UMP_DCP_DBPWD} 
		  db2 "export to ${filepath}/${exp_file} of del modified by nochardel codepage=1208 coldel0x07  ${select_sql} " >>$logfile 2>&1 
		  if [ $? -eq 0 ];then
		   return 0
		  else
		  _Mesg "Export Data Failed,Exit With Code 24..."|tee -a $logfile
		   exit 24
		  fi
		fi
}


#####################################
#函数名：creLogFile
#功能描述：生成日志文件
#输入参数: 
#返回值:0 成功 1 失败
#####################################
function creLogFile()
{
	logfile=" "
#定义日志文件的路径
#日志文件名称是(作业ID_当前日期)
  if [ -z $EXP_JOB_NAME ];then
     echo "the Job Id is Null,Exit......"
     exit -1
  fi
  logfile="${logfilepath}/${EXP_JOB_NAME}_${ETL_DATE}.log"
  if [ ! -f "$logfile" ]; then  
 		touch "$logfile"  
 	fi 
 	if [ $? -eq 0 ] ;then
 	 _Mesg "---------------------start ${EXP_JOB_NAME}---------------------"|tee -a $logfile
 	 _Mesg "Log File Name is : ${logfile}"|tee -a $logfile
	 _Mesg "Create Log File Successed"|tee -a $logfile
	 return 0
	 else
	 _Mesg "Create Log File Failed,Exit With Code 13..."|tee -a $logfile
	 exit 13
	fi
}

# 这个函数的命令就是把那个需要的文件给get下来
function getftp
{
ftp -i -n $HOST_IP <<FTPIT
user $HOST_USER $HOST_PWD
cd $FILE_PATH
lcd $tmpFilepath
bin
mget $FILE_NAME
quit
FTPIT

}
#####################################
#函数名： getFilePath
#功能描述：获得平台文件路径
#输入参数
#作者：庞子珩
#返回值:0 成功 1 失败
#####################################
function getFilePath()
{
	RESIN_UPLOAD_PATH=`grep "RESIN_UPLOAD_PATH" $cfg|cut -d'=' -f2`
	RESIN_DOWNLOAD_PATH=`grep "RESIN_DOWNLOAD_PATH" $cfg|cut -d'=' -f2`
}
   
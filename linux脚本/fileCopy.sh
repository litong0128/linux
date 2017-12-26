#!/bin/bash   
###############################################################################
#    文件名  :    fileCopy.sh                                                 #
#    功  能  :    复制数据文件到下游应用系统目录                              #
#    编  写  :    王光武                                                      #
#    修  改  :                                                                #
#    时  间  :    2012-12-11                                                  #
#    版  权  :                                                                #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :                                                                #
#    说  明  :                                                                #
###############################################################################
#操作的作业名称
 EXP_JOB_NAME=$1
#ETL作业时间 开始时间格式YYYYMMDDHHMMSS
 ETL_TIME1=$2
#ETL作业时间 结束时间格式YYYYMMDDHHMMSS
 ETL_TIME2=$3
#ETL作业日期  格式YYYYMMDD
 ETL_DATE=${ETL_TIME1:0:8}
#引入公共文件
        . ${ETL_MAIN_PATH}/bin/public.sh
CPFILE_JOB_NAME=${EXP_JOB_NAME}
#日志文件路径
   logfilepath=${ETL_MAIN_PATH}/log/out
   [ ! -d ${logfilepath} ] && mkdir -p ${logfilepath}
#定义日志文件的路径
  logfile="${logfilepath}/${CPFILE_JOB_NAME}_${ETL_DATE}.log"
#日志文件
  creLogFile
  _Mesg "Start to Job :${CPFILE_JOB_NAME}"|tee -a $logfile
#获取资料库配置信息
        getRepDBPara
#获取ods核心库信息
  getOdsDBPara
#判断网络通信正常
  IsConnect

#设置导出文件的名字
    UMP_ODS_DBNAME=`echo ${UMP_ODS_DBNAME}`
    
  #根据jobid 查询表信息 
    
    #获取卸数作业名
     EXP_JOB_ID=`echo ${CPFILE_JOB_NAME}|cut -d'_' -f 2-` 
     _Mesg "EXP_JOB_ID is :${EXP_JOB_ID}"|tee -a $logfile
     #echo " EXP_JOB_ID is : " ${EXP_JOB_ID}
    
    #获取下游应用数据存放目录
    getAppFilePath
    _Mesg "PATH is :${path}"|tee -a $logfile
   
   #通过链接资料库获取数据文件名和控制文件名 
    db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
    tbname=`db2 -x "select SOUTB_NAME from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_ID}' with ur"`
      #当前月的ETLDATE
      ETL_DATE6=${ETL_TIME1:0:6}
      #上月的ETLDATE
      ETL_LDATE6=${ETL_LTime:0:6}
      #下一个月的ETLDATE
      ETL_NDATE6=${ETL_NTime:0:6}
      #获取DD时间
            ETL_DATE2=${ETL_TIME1:6:2}
            
            ETL_DATE1=-1
            if [ $ETL_DATE2 -eq 31 ];then
              ETL_DATE1=31
            elif [ $ETL_DATE2 -eq 10 ] || [ $ETL_DATE2 -eq 20 ] || [ $ETL_DATE2 -eq 30 ]  ;then
              ETL_DATE1=10
            else
              ETL_DATE1=0${ETL_TIME1:7:1}
            fi
                  curr_tbname=$tbname
            curr_tbname=`echo $curr_tbname | sed -e 's/\$YYYYMM/'$ETL_DATE6'/g' -e 's/\$DD/'$ETL_DATE1'/g'`
            currexp_file="${UMP_ODS_DBNAME}_${curr_tbname/./_}_${ETL_DATE}.del"
            ctrl_file="${UMP_ODS_DBNAME}_${curr_tbname/./_}_${ETL_DATE}.cfl"        
   
             #echo "currexp_file is :" ${currexp_file}
             _Mesg "DataFileName is :${currexp_file}"|tee -a $logfile

  # 定义源数据目录与目标数据存放目录
   
   CompletePath=${ETL_MAIN_PATH}/data/complete/${ETL_DATE}/upload/
   FailPath=${ETL_MAIN_PATH}/data/fail/${ETL_DATE}/upload/ 
   TargetPath=${ETL_MAIN_PATH}/data/out/${path}/${ETL_DATE}/
   InPath=${ETL_MAIN_PATH}/data/in/${ETL_DATE}/extract/
     
   _Mesg "TargetPath is :${TargetPath}"|tee -a $logfile
   
     [ ! -d $InPath ] && mkdir -p $InPath
     [ ! -d $TargetPath ] && mkdir -p  $TargetPath 
     [ ! -d $CompletePath ] && mkdir -p $CompletePath
     [ ! -d $FailPath ] && mkdir -p $FailPath
   
       if [ -f ${CompletePath}${currexp_file} ];then
          cp ${CompletePath}${currexp_file}  ${TargetPath} 
          _Mesg "DataFile Exsits "|tee -a $logfile
       elif [ -f ${FailPath}${currexp_file} ];then
          cp ${FailPath}${currexp_file}  ${TargetPath}
           _Mesg "DataFile Exsits "|tee -a $logfile
       elif [ -f ${InPath}${currexp_file} ];then
            cp ${InPath}${currexp_file}  ${TargetPath}
           _Mesg "DataFile Exsits "|tee -a $logfile
       else  
        _Mesg "DataFile Not found "|tee -a $logfile
         exit 70
       fi
      if [ -f ${TargetPath}${currexp_file} ];then
        _Mesg "DataFile Copy Succeed "|tee -a $logfile
      else 
        _Mesg "DataFile Copy Failed "|tee -a $logfile    
      exit 70
      fi
     if [ -f ${InPath}${ctrl_file} ];then
           cp ${InPath}${ctrl_file}  ${TargetPath} 
            _Mesg "ControlFile Exists "|tee -a $logfile 
        else
         _Mesg "ControlFile Not found "|tee -a $logfile
         exit 70
        fi 
      if [ -f ${TargetPath}${ctrl_file} ];then
        _Mesg "ControlFile Copy Succeed "|tee -a $logfile
      else
        _Mesg "ControlFile Copy Failed "|tee -a $logfile
      exit 70
      fi
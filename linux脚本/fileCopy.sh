#!/bin/bash   
###############################################################################
#    �ļ���  :    fileCopy.sh                                                 #
#    ��  ��  :    ���������ļ�������Ӧ��ϵͳĿ¼                              #
#    ��  д  :    ������                                                      #
#    ��  ��  :                                                                #
#    ʱ  ��  :    2012-12-11                                                  #
#    ��  Ȩ  :                                                                #
#    ��  ��  :                                                                #
#    ʱ  ��  :                                                                #
#    ��  ��  :                                                                #
#    ˵  ��  :                                                                #
###############################################################################
#��������ҵ����
 EXP_JOB_NAME=$1
#ETL��ҵʱ�� ��ʼʱ���ʽYYYYMMDDHHMMSS
 ETL_TIME1=$2
#ETL��ҵʱ�� ����ʱ���ʽYYYYMMDDHHMMSS
 ETL_TIME2=$3
#ETL��ҵ����  ��ʽYYYYMMDD
 ETL_DATE=${ETL_TIME1:0:8}
#���빫���ļ�
        . ${ETL_MAIN_PATH}/bin/public.sh
CPFILE_JOB_NAME=${EXP_JOB_NAME}
#��־�ļ�·��
   logfilepath=${ETL_MAIN_PATH}/log/out
   [ ! -d ${logfilepath} ] && mkdir -p ${logfilepath}
#������־�ļ���·��
  logfile="${logfilepath}/${CPFILE_JOB_NAME}_${ETL_DATE}.log"
#��־�ļ�
  creLogFile
  _Mesg "Start to Job :${CPFILE_JOB_NAME}"|tee -a $logfile
#��ȡ���Ͽ�������Ϣ
        getRepDBPara
#��ȡods���Ŀ���Ϣ
  getOdsDBPara
#�ж�����ͨ������
  IsConnect

#���õ����ļ�������
    UMP_ODS_DBNAME=`echo ${UMP_ODS_DBNAME}`
    
  #����jobid ��ѯ����Ϣ 
    
    #��ȡж����ҵ��
     EXP_JOB_ID=`echo ${CPFILE_JOB_NAME}|cut -d'_' -f 2-` 
     _Mesg "EXP_JOB_ID is :${EXP_JOB_ID}"|tee -a $logfile
     #echo " EXP_JOB_ID is : " ${EXP_JOB_ID}
    
    #��ȡ����Ӧ�����ݴ��Ŀ¼
    getAppFilePath
    _Mesg "PATH is :${path}"|tee -a $logfile
   
   #ͨ���������Ͽ��ȡ�����ļ����Ϳ����ļ��� 
    db2 "connect to ${UMP_REP_DBNAME} user ${UMP_REP_DBUSER} using ${UMP_REP_DBPWD} " > /dev/null 2>&1
    tbname=`db2 -x "select SOUTB_NAME from ${schema}.OPB_METADATA_TABLE_EX where job_id='${EXP_JOB_ID}' with ur"`
      #��ǰ�µ�ETLDATE
      ETL_DATE6=${ETL_TIME1:0:6}
      #���µ�ETLDATE
      ETL_LDATE6=${ETL_LTime:0:6}
      #��һ���µ�ETLDATE
      ETL_NDATE6=${ETL_NTime:0:6}
      #��ȡDDʱ��
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

  # ����Դ����Ŀ¼��Ŀ�����ݴ��Ŀ¼
   
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
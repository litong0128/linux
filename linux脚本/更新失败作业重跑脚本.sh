#!/bin/bash
db2 connect to etl > /dev/null
date=`date +%Y-%m-%d`
curr_time1=`date +"%Y-%m-%d %H:%M:%S"`
if [ $1 ]
        then
        date=$1
fi
echo $date
updatenum=`db2 -x "select count(1) from etl.T_SCHDL_LOG where JOB_GRP_STATUS='F' and SEND_TIMES >=1 and LOG_TYPE <> 2 and date(END_TIME) = '$date' "`
if [ $updatenum -ge 1 ]
    then
        db2 -x "select * from etl.T_SCHDL_LOG where JOB_GRP_STATUS='F' and SEND_TIMES >=1 and LOG_TYPE <> 2 and date(END_TIME) = '$date' "
        echo "${curr_time1} $updatenum jobs will be running again!"
#        db2 -x "update etl.T_SCHDL_LOG set RUN_TIMES = RUN_TIMES-1  where JOB_GRP_STATUS='F' and SEND_TIMES >=1 and LOG_TYPE <> 2 and date(END_TIME) = '$date' "
        echo "${curr_time1} update successed!"
    else
        echo "${curr_time1} no job failed!"
fi 
echo "================================================="
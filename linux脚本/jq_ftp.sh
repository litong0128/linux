#!/bin/bash
#####################################
# describe����Ȩ�ļ�ͬ����etl������ #
# author��litong                    #
# version��1.0                      #
# createdate��20140910              #
#####################################
#�������
JQ_UPLOAD_PATH=/home/resin/resin-pro-3.1.12/webapps/product/upload/fk_auth_upload/
BODY="ftp��Ȩ�ļ�����ׯetlf����������,���Ų����⣡"
#�ļ�ģʽ
FILE_REGEX="mer_auth_ratio_*.txt"

#��ȡ��Ȩ�·�
JQ_MONTH=`/usr/bin/find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1|head -1|awk -F"/" '{print $NF}'|awk -F"_" '{print $4}'`

#������֤��½�û�
SSH_USER="dwetl@10.101.1.62"

#ftp��etl��ҵ���ص�·��
FTP_PATH=/home/dwetl/data/in/${JQ_MONTH}01/ftp/

#����ļ������ļ��Ƿ��Ѿ�ftp��ָ������������Ѿ����ɿ����ļ������Ƴ�
cd ${JQ_UPLOAD_PATH}
ls mw${JQ_MONTH}_jq.cfl
if [ $? -eq 0 ]
	then
		exit
fi 

#�ƶ������ļ���ָ��Ŀ¼
/usr/bin/find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1 -exec scp {} ${SSH_USER}:${FTP_PATH} \;

#���ɿ����ļ�ftp��etl������
if [ $? -eq 0 ]
	then   
		echo `/usr/bin/find ${JQ_UPLOAD_PATH} -name "$FILE_REGEX" -mtime -1|wc -l` > mw${JQ_MONTH}_jq.cfl
		scp mw${JQ_MONTH}_jq.cfl ${SSH_USER}:${FTP_PATH}
	else
		sh /home/resin/Function/sms.sh "13520587756;15210870137;15801157747" $BODY
fi

#����Ŀ¼���
echo $JQ_UPLOAD_PATH ---$FILE_REGEX---$JQ_MONTH  ---$FTP_PATH  ---$SSH_USER

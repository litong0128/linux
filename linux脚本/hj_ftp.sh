#!/bin/bash
#####################################
# describe���˼��ļ�ͬ����62        #
# author��litong                    #
# version��1.0                      #
# createdate��20140905              #
#####################################
#�������
HJ_UPLOAD_PATH=/home/resin/resin-pro-3.1.12/webapps/product/upload/hj_dtl_upload
BODY="ftp�˼��ļ�����ׯetlf����������,���Ų����⣡"
#�ļ�ģʽ
FILE_REGEX="mw*.txt"

#��ȡ��Ȩ�·�
HJ_MONTH=`/usr/bin/find ${HJ_UPLOAD_PATH} -name ${FILE_REGEX} -mtime -1|head -1|awk -F"/" '{print $NF}'|cut -b 3-8`

#������֤��½�û�
SSH_USER="dwetl@10.101.1.62"

#ftp��etl��ҵ���ص�·��
FTP_PATH=/home/dwetl/data/in/${HJ_MONTH}01/ftp/

#�ƶ������ļ���ָ��Ŀ¼
/usr/bin/find ${HJ_UPLOAD_PATH} -name ${FILE_REGEX} -mtime -1 -exec scp {} ${SSH_USER}:${FTP_PATH} \;

#���ɿ����ļ�ftp��etl������
if [ $? -eq 0 ]
	then   
		echo `/usr/bin/find ${HJ_UPLOAD_PATH} -name ${FILE_REGEX} -mtime -1|wc -l` > mw${HJ_MONTH}_hj.cfl
		scp mw${HJ_MONTH}_hj.cfl ${SSH_USER}:${FTP_PATH}
	else
		sh /home/resin/Function/sms.sh "13520587756;15210870137;15801157747" $BODY
fi

#����Ŀ¼���
#echo $HJ_UPLOAD_PATH ---$FILE_REGEX---$HJ_MONTH  ---$FTP_PATH  ---$SSH_USER

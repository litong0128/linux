#!/bin/bash

BACKUP_DATE=`date +%Y%m%d`
echo ======================
echo `date` starting backup!
mkdir ~/backup/${BACKUP_DATE}

cd ~/apache-tomcat-7.0.59/webapps

cp -r JFPLAT/ ~/backup/${BACKUP_DATE}
cp JFPLAT.war ~/backup/${BACKUP_DATE}

cd ~/backup

tar -czf ${BACKUP_DATE}.tar.gz ${BACKUP_DATE}
rm -rf ${BACKUP_DATE}
echo `date` backup successfully!
echo "     "

find ~/backup/ -name "*.tar.gz" -mtime +3 -exec rm -rf {} \;


#00 09 * * * /app/jfuser/shell/backup.sh >> /app/jfuser/shell/backup.out
#* * * * * /app/jfuser/shell/backup.sh >> /app/jfuser/shell/backup.out
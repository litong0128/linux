#!/bin/sh
echo "#################################################" >> /tmp/ftp.log
echo "Cron task was invoked" >> /tmp/ftp.log
date>>/tmp/ftp.log
ls /opt/ftp108/*.gz >> /dev/null 2>&1
if [ `echo $?` -eq 0 ]
then
        for loops in `ls /opt/ftp108/*.gz`
        do
                scp $loops ftp108@10.249.252.13:/opt/ftp108 >> /tmp/ftp.log 2>&1

                if [ `echo $?` -eq 0 ]
                then 
                        echo "$loops transfered successfully" >> /tmp/ftp.log
                        echo "current ssh connection number for ftp108 is :" >> /tmp/ftp.log
                        ps -ef | grep ssh | grep -v grep | awk '/^ftp108/' | wc -l >> /tmp/ftp.log
                else
                        echo "file transfer failed" >> /tmp/ftp.log
                fi
        done

        mv /opt/ftp108/*.gz /opt/ftp108/data_bak

else

echo "no file needs to be transferd for now" >> /tmp/ftp.log
echo "no ssh connection was ESTABLISHED by the cron task" >> /tmp/ftp.log
echo "current ssh connection number from ftp108 is :" >> /tmp/ftp.log
sudo ps -ef | grep ssh | grep -v grep | awk '/^ftp108/' | wc -l >> /tmp/ftp.log
fi

#sudo sh /opt/ftp108/stop_ssh.sh
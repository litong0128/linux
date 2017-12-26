#!/bin/bash
#show the using status of hard disk
df -h
#clear /etlcenter/data
cd /usr/mpsp/etlcenter/data
dir=$(ls)
echo $dir 
for d in $dir
        do
                cd $d
                n=$(ls|grep -e txt$|wc -l)
                #echo $n
                if test $n -gt 0
                then
                        gzip *.txt
                        echo $d has been zip!
                else
                        echo $d no file to zip.
                fi
                cd ..
        done
echo 'data dir *.txt has been zip successful!'

#clear txn_mw.out
cd /usr/mpsp/etlcenter/doSql
>txn_mw.out
du -sh txn_mw.out
echo txn_mw.out has been clear successful!

#clear etlcenter/doSql/txn_mw/loaded
cd /usr/mpsp/etlcenter/doSql/txn_mw/loaded
n=$(ls|grep -e sql$|wc -l)
if test $n -gt 0
	then
		gzip *.sql
		echo loaded *.sql has bean zip successful!
	else
		echo $d no file to zip.
fi

#clear odsper/filepath
cd /usr/mpsp/odsper/filepath
n=$(ls|grep -e txt$|wc -l)
if test $n -gt 0
	then
		gzip *.txt
		echo filepath *.txt has bean zip successful!
	else
		echo $d no file to zip.
fi
echo the using status of hard disk after cleared!
df -h
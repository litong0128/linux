#!/bin/bash
. /home/db2inst1/sqllib/db2profile
db2 connect to ump_dc user db2inst1 using Dx720000 
#db2 update command options using c OFF
date
j=0
while read line
do
  	db2 +c $line>>error.out
        i=`echo $?`
       
	if [ $i -ne 0 ]
	then   
		echo "$line">>cf.out
	fi
        echo "$line">>run.out	
	let j+=1 
	if [ $j -eq 20000 ]
	 then	
		db2 commit
		j=0
	fi
done < $1
db2 commit
db2 connect reset
date

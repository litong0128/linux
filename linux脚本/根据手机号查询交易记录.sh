#!/bin/bash

db2 connect to umpayods user uetlusr using uetlusr >/dev/null
	for WH in `cat $1`
do   
	MOBILEID=`echo $WH | cut -c1-11`
	STATE=`echo $WH | cut -c13-13`

	db2 -x "select mobileid,sum(amount) as amount,'$STATE' from umpay.t_mfeetrans where platdate between '20121001' and '20130113' and mobileid = '$MOBILEID'  and channelid in ('M0791000','Z3791000','Z5791000') group by mobileid ">>jft1008620130113.txt

done    

db2 connect reset >/dev/null

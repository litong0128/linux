#!/bin/bash

nzsql -u dwadm -pw dwadm -db sdata -host 10.101.1.163 -c "drop table FK_RESULT_TEMP"

nzsql -u dwadm -pw dwadm -db sdata -host 10.101.1.163 -c "create table FK_RESULT_TEMP as select * from FK_RESULT_20140201 where 1=2"

nzload -host 10.101.1.163 -db sdata -t FK_RESULT_TEMP -u dwadm -pw dwadm -df $1 -delim ',' -maxErrors 1 -encoding internal 

nzsql -u etl -pw etl1 -db pdata -host 10.101.1.163 -A -t -c "select FK_DATA,mobile_id,case ret_code when '00' then '020' when '01' then '024' when '02' then '022' when '03' then '023' when '04' then '026' when '05' then '025' when '06' then '021' when '90' then '027' when '99' then '028' else '029' end as retcode from FK_RESULT_TEMP " -F , -o /home/dwetl/data/in/$2/extract/umpayods_FILE_FK_RESULT_$2.del
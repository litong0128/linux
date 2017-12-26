#!/bin/bash
#定义变量

#NAME=
#循环拼写
for TMP in `cat $1`
do
	SYNC_NAME=`echo $TMP|awk -F"." '{print $2}'|awk 'gsub(/^ *| *$/,"")'`
	TAB_NAME=`echo $TMP|awk 'gsub(/^ *| *$/,"")'`
echo '<SyncLet name="'${SYNC_NAME}'">'>>sync_config.xml
echo '       <MonitorTable>'${TAB_NAME}'</MonitorTable>'>>sync_config.xml
echo '       <Method>'>>sync_config.xml
echo '            <TargetTable jdbc="jdbc_rp">'>>sync_config.xml
echo '                '${TAB_NAME}''>>sync_config.xml
echo '            </TargetTable>'>>sync_config.xml
echo '            <ColumnMapping>'>>sync_config.xml
echo '                <Mapping from="j$TIMESTAMP" to="ODSTIME"/>'>>sync_config.xml
echo '            </ColumnMapping>'>>sync_config.xml
echo '       </Method>'>>sync_config.xml
echo '</SyncLet>'>>sync_config.xml
echo ''>>sync_config.xml
done


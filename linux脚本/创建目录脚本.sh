#!/bin/bash
##################
#des:����Ŀ¼�ű�#
#author:litong   #
#date:20140917   #
##################
#�������
DATABASE=$1
YEAR=$2
#��������Ŀ¼
mkdir -p /history/$DATABASE/$2/data
echo "mkdir /history/$DATABASE/$2/data successfully!"
#������ṹ����Ŀ¼
mkdir -p /history/$DATABASE/$2/ddl
echo "mkdir /history/$DATABASE/$2/ddl successfully!"
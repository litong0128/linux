#!/bin/bash
##################
#des:创建目录脚本#
#author:litong   #
#date:20140917   #
##################
#定义变量
DATABASE=$1
YEAR=$2
#创建数据目录
mkdir -p /history/$DATABASE/$2/data
echo "mkdir /history/$DATABASE/$2/data successfully!"
#创建表结构定义目录
mkdir -p /history/$DATABASE/$2/ddl
echo "mkdir /history/$DATABASE/$2/ddl successfully!"
#!/bin/bash
echo "$1"
OLDIFS=$IFS;
IFS='\n';
for i in `cat tt`;
do echo $i;
done;
IFS=$OLDIFS
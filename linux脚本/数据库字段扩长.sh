#!/bin/bash


#awk -F '(' '{print $1"|"$2}' 1.txt|awk -F ')' '{ print $1"|"$2}'|awk -F '|' '{ print $1"("$2*2")"$3}'

#awk -F '(' '$2!="" {print $1"|"$2}' 1.txt|awk -F ')' '{ print $1"|"$2}'|awk -F '|' '{ print $1"("$2*2")"$3}'

#
awk -F '(' '{print $2!="" ? $1"|"$2 : $1}' 1.txt|awk -F ')' '{print $2!="" ? $1"|"$2 : $1}'|awk -F '|' '{ print $2!="" ? $1"("$2*2")"$3 : $1}'